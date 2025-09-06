# Contributing

Thanks for your interest in contributing!

## Prerequisites

- Use Java 21 and Maven 3.8+
- Follow the existing code style and structure
- Keep changes small and focused; include tests when practical
- Run `mvn test` before submitting a PR

## Getting Started

1. **Fork the repo** and create a branch
2. **Set up your development environment**:
   - See [INSTALLATION.md](INSTALLATION.md) for detailed setup instructions
   - For development, you can run directly with: `mvn javafx:run`
3. **Make your changes** and add tests under `src/test/java` when practical
4. **Test your changes**: `mvn test`
5. **Submit a Pull Request**

## Development Setup

Quick development setup:
```bash
git clone https://github.com/yourusername/youtubedownloader.git
cd youtubedownloader
mvn clean compile
mvn javafx:run
```

## Reporting Issues

When reporting bugs or requesting features, please include:
- Steps to reproduce the issue
- Error messages or logs
- Environment details (OS, Java version, etc.)
- Screenshots if applicable

For installation issues, check [INSTALLATION.md](INSTALLATION.md) first.

