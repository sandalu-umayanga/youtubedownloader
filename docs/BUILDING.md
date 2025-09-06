# Building from Source

Prereqs
- Java 21 (JDK) with jpackage for native installers (optional)
- Maven 3.8+
- Internet access for Maven to resolve dependencies

Quick start
```
mvn clean compile
mvn javafx:run
```

Create a self-contained runtime image (jlink)
```
mvn -Pjlink clean javafx:jlink
```
Output goes to target/image.

Run the app from the image
```
./target/image/bin/java -m youtubedownloader/com.snake.youtubedownloader.App
```

Profiles
- linux (default)
- windows
- macos
Switch JavaFX platform:
```
mvn -Plinux javafx:run
mvn -Pwindows -DskipTests clean compile
```

Tests
```
mvn test
```

