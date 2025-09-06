package com.snake.youtubedownloader;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

class SystemInfoTest {
    @Test
    void javaVersionIsPresent() {
        assertNotNull(SystemInfo.javaVersion());
        assertFalse(SystemInfo.javaVersion().isBlank());
    }
}

