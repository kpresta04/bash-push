# Git Conventional Commit Script

A bash script that simplifies the process of creating standardized git commit messages following the [Conventional Commits](https://www.conventionalcommits.org/) specification. This script automatically formats your commit messages and integrates ticket/issue numbers from your branch names.

## Features

- Enforces conventional commit message format
- Automatically extracts ticket numbers from branch names
- Supports all standard conventional commit types
- Option to bypass pre-commit hooks
- User-friendly command-line interface

## Installation

1. Download the script:

```bash
curl -o git-commit-script.sh https://your-script-location.com/git-commit-script.sh
```

2. Make it executable:

```bash
chmod +x git-commit-script.sh
```

3. Optional: Move to a directory in your PATH for easy access:

```bash
sudo mv git-commit-script.sh /usr/local/bin/git-cc
```

## Usage

```bash
./git-commit-script.sh [commit-type] "commit message" [options]
```

Or if installed as a global command:

```bash
git-cc [commit-type] "commit message" [options]
```

### Commit Types

- `fix`: Bug fixes
- `feat`: New features
- `docs`: Documentation changes
- `style`: Code style changes (formatting, missing semi-colons, etc.)
- `refactor`: Code refactoring
- `test`: Adding or updating tests
- `chore`: Maintenance tasks
- `ci`: CI/CD changes
- `breaking`: Breaking changes
- `perf`: Performance improvements

### Options

- `-n, --no-verify`: Skip git hooks
- `-h, --help`: Show help message

### Examples

```bash
# Simple feature commit
./git-commit-script.sh feat "Add user authentication"

# Fix with skipped hooks
./git-commit-script.sh fix "Resolve login redirect issue" --no-verify

# Documentation update
./git-commit-script.sh docs "Update API documentation"
```

## Branch Name Integration

The script automatically extracts ticket numbers from your branch name and adds them to the commit message. Supported branch name formats include:

- `feature/ABC-123-description`
- `bugfix/123-fix-something`
- `123-some-description`

For example, if your current branch is `feature/ABC-123-new-login` and you run:

```bash
./git-commit-script.sh feat "Implement login form"
```

The resulting commit message will be:

```
feat: (#ABC-123) Implement login form
```

## Customization

You can modify the script to:
- Change the commit message format
- Add new commit types
- Modify the ticket number extraction regex
- Adjust the output formatting

## Requirements

- Bash shell
- Git

## License

[MIT License](LICENSE)