package com.snake.youtubedownloader;

import javafx.application.Application;
import javafx.application.Platform;
import javafx.geometry.Insets;
import javafx.geometry.Pos;
import javafx.scene.Scene;
import javafx.scene.control.*;
import javafx.scene.layout.*;
import javafx.stage.DirectoryChooser;
import javafx.stage.Stage;

import java.io.*;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;

/**
 * JavaFX App
 */
public class App extends Application {
    private TextArea logArea;
    private TextField urlField;
    private ComboBox<String> formatBox;
    private TextField dirField;
    private Button loadFormatsBtn, downloadBtn, pauseBtn, resumeBtn, cancelBtn, browseBtn;

    private volatile Process currentProcess;

    public static void main(String[] args) {
        launch(args);
    }

    @Override
    public void start(Stage stage) {
        stage.setTitle("YouTube Downloader (JavaFX + yt-dlp)");

        // URL row
        urlField = new TextField();
        urlField.setPromptText("Paste YouTube URL");
        urlField.setPrefWidth(520);
        loadFormatsBtn = new Button("Load formats");

        HBox urlRow = new HBox(8, new Label("URL:"), urlField, loadFormatsBtn);
        urlRow.setAlignment(Pos.CENTER_LEFT);

        // Output directory row
        dirField = new TextField();
        dirField.setPromptText("Choose download folder");
        dirField.setText(new File("downloads").getAbsolutePath());
        browseBtn = new Button("Browse…");

        HBox dirRow = new HBox(8, new Label("Save to:"), dirField, browseBtn);
        dirRow.setAlignment(Pos.CENTER_LEFT);

        // Format row
        formatBox = new ComboBox<>();
        formatBox.setPrefWidth(520);
        formatBox.setPromptText("best (default)  — or click 'Load formats'");

        HBox fmtRow = new HBox(8, new Label("Quality:"), formatBox);
        fmtRow.setAlignment(Pos.CENTER_LEFT);

        // Buttons
        downloadBtn = new Button("Download");
        pauseBtn    = new Button("Pause");
        resumeBtn   = new Button("Resume");
        cancelBtn   = new Button("Cancel");
        pauseBtn.setDisable(true);
        resumeBtn.setDisable(true);
        cancelBtn.setDisable(true);

        HBox actions = new HBox(10, downloadBtn, pauseBtn, resumeBtn, cancelBtn);
        actions.setAlignment(Pos.CENTER_LEFT);

        // Log area
        logArea = new TextArea();
        logArea.setEditable(false);
        logArea.setPrefRowCount(16);

        VBox root = new VBox(12, urlRow, dirRow, fmtRow, actions, logArea);
        root.setPadding(new Insets(12));

        // Wire UI
        browseBtn.setOnAction(e -> chooseDirectory(stage));
        loadFormatsBtn.setOnAction(e -> loadFormats());
        downloadBtn.setOnAction(e -> startDownload());
        pauseBtn.setOnAction(e -> pauseDownload());
        resumeBtn.setOnAction(e -> resumeDownload());
        cancelBtn.setOnAction(e -> cancelDownload());

        // Disable pause/resume on Windows (signals not supported)
        if (isWindows()) {
            pauseBtn.setDisable(true);
            resumeBtn.setDisable(true);
            appendLog("Note: Pause/Resume is currently supported on Linux only.");
        }

        stage.setScene(new Scene(root, 820, 520));
        stage.show();
    }

    private boolean isWindows() {
        String os = System.getProperty("os.name", "").toLowerCase();
        return os.contains("win");
    }

    private void chooseDirectory(Stage stage) {
        DirectoryChooser chooser = new DirectoryChooser();
        chooser.setTitle("Select download folder");
        if (!dirField.getText().isBlank()) {
            File f = new File(dirField.getText());
            if (f.isDirectory()) chooser.setInitialDirectory(f);
        }
        File dir = chooser.showDialog(stage);
        if (dir != null) dirField.setText(dir.getAbsolutePath());
    }

    private void appendLog(String s) {
        Platform.runLater(() -> logArea.appendText(s + System.lineSeparator()));
    }

    private String findYtDlpOnPath() {
        // Try PATH
        String[] candidates = {"yt-dlp", "yt-dlp.py", "yt-dlp.exe"};
        for (String c : candidates) {
            try {
                Process p = new ProcessBuilder(c, "--version")
                        .redirectErrorStream(true).start();
                if (p.waitFor() == 0) return c;
            } catch (Exception ignored) { }
        }
        // Fallback to user install path (Linux)
        String home = System.getProperty("user.home");
        File local = new File(home + "/.local/bin/yt-dlp");
        if (local.canExecute()) return local.getAbsolutePath();

        return null;
    }

    private void loadFormats() {
        String url = urlField.getText().trim();
        if (url.isEmpty()) {
            showWarn("Paste a URL first.");
            return;
        }
        String yt = findYtDlpOnPath();
        if (yt == null) {
            showWarn("yt-dlp not found. Install with:  python3 -m pip install --user yt-dlp");
            return;
        }

        formatBox.getItems().clear();
        appendLog("Fetching formats…");
        new Thread(() -> {
            try {
                ProcessBuilder pb = new ProcessBuilder(yt, "-F", url);
                pb.redirectErrorStream(true);
                Process p = pb.start();
                try (BufferedReader r = new BufferedReader(
                        new InputStreamReader(p.getInputStream(), StandardCharsets.UTF_8))) {
                    List<String> formats = new ArrayList<>();
                    String line;
                    boolean table = false;
                    while ((line = r.readLine()) != null) {
                        appendLog(line);
                        // yt-dlp prints a header; once we hit lines that start with an id, capture them
                        // Format id is the first token (digits or word)
                        String trimmed = line.trim();
                        if (trimmed.matches("^(\\d+|[a-zA-Z0-9.\\-+_]+)\\s+.*")) {
                            table = true;
                        }
                        if (table && trimmed.matches("^(\\d+|[a-zA-Z0-9.\\-+_]+)\\s+.*")) {
                            formats.add(trimmed);
                        }
                    }
                    int code = p.waitFor();
                    if (code == 0 && !formats.isEmpty()) {
                        Platform.runLater(() -> formatBox.getItems().addAll(formats));
                        appendLog("Formats loaded. Pick one or leave empty for 'best'.");
                    } else {
                        appendLog("No formats parsed; leaving default 'best'.");
                    }
                }
            } catch (Exception ex) {
                appendLog("Error loading formats: " + ex.getMessage());
            }
        }, "LoadFormats").start();
    }

    private void startDownload() {
        if (currentProcess != null) {
            showWarn("A download is already running.");
            return;
        }

        String url = urlField.getText().trim();
        if (url.isEmpty()) { showWarn("Paste a URL first."); return; }

        String dir = dirField.getText().trim();
        if (dir.isEmpty()) { showWarn("Choose a download folder."); return; }
        File outDir = new File(dir);
        if (!outDir.isDirectory() && !outDir.mkdirs()) {
            showWarn("Cannot use folder: " + dir);
            return;
        }

        String yt = findYtDlpOnPath();
        if (yt == null) {
            showWarn("yt-dlp not found. Install with:  python3 -m pip install --user yt-dlp");
            return;
        }

        String selection = formatBox.getValue();
        // Default to "best" if nothing selected
        String formatId = null;
        if (selection != null && !selection.isBlank()) {
            // Take the first token as format id
            String[] toks = selection.trim().split("\\s+");
            if (toks.length > 0) formatId = toks[0];
        }

        List<String> cmd = new ArrayList<>();
        cmd.add(yt);
        if (formatId != null) {
            cmd.add("-f"); cmd.add(formatId);
        } // else leave to yt-dlp default (bestvideo+bestaudio/best)
        cmd.add("-o"); cmd.add("%(title)s.%(ext)s");
        cmd.add(url);

        appendLog("Running: " + String.join(" ", cmd));
        downloadBtn.setDisable(true);
        pauseBtn.setDisable(true == isWindows());
        cancelBtn.setDisable(false);
        resumeBtn.setDisable(true);

        new Thread(() -> {
            try {
                ProcessBuilder pb = new ProcessBuilder(cmd);
                pb.directory(new File(dir));
                pb.redirectErrorStream(true);
                // Hint JavaFX renderer to prefer OpenGL (helpful on some machines)
                pb.environment().put("_JAVA_OPTIONS", "-Dprism.order=es2");
                currentProcess = pb.start();

                try (BufferedReader r = new BufferedReader(
                        new InputStreamReader(currentProcess.getInputStream(), StandardCharsets.UTF_8))) {
                    String line;
                    while ((line = r.readLine()) != null) appendLog(line);
                }

                int code = currentProcess.waitFor();
                appendLog("Process exited with code: " + code);
            } catch (Exception ex) {
                appendLog("Error: " + ex.getMessage());
            } finally {
                currentProcess = null;
                Platform.runLater(() -> {
                    downloadBtn.setDisable(false);
                    pauseBtn.setDisable(true);
                    resumeBtn.setDisable(true);
                    cancelBtn.setDisable(true);
                });
            }
        }, "Downloader").start();
    }

    private void pauseDownload() {
        Process p = currentProcess;
        if (p == null || isWindows()) return;
        long pid = p.pid();
        try {
            // Linux pause via SIGSTOP
            new ProcessBuilder("bash", "-lc", "kill -STOP " + pid).start().waitFor();
            appendLog("Paused (SIGSTOP " + pid + ")");
            pauseBtn.setDisable(true);
            resumeBtn.setDisable(false);
        } catch (Exception ex) {
            appendLog("Pause failed: " + ex.getMessage());
        }
    }

    private void resumeDownload() {
        Process p = currentProcess;
        if (p == null || isWindows()) return;
        long pid = p.pid();
        try {
            // Linux resume via SIGCONT
            new ProcessBuilder("bash", "-lc", "kill -CONT " + pid).start().waitFor();
            appendLog("Resumed (SIGCONT " + pid + ")");
            pauseBtn.setDisable(false);
            resumeBtn.setDisable(true);
        } catch (Exception ex) {
            appendLog("Resume failed: " + ex.getMessage());
        }
    }

    private void cancelDownload() {
        Process p = currentProcess;
        if (p == null) return;
        try {
            p.destroy();
            appendLog("Cancel requested (SIGTERM).");
        } catch (Exception ex) {
            appendLog("Cancel failed: " + ex.getMessage());
        }
    }

    private void showWarn(String msg) {
        Alert a = new Alert(Alert.AlertType.WARNING, msg, ButtonType.OK);
        a.setHeaderText(null);
        a.showAndWait();
    }
}
