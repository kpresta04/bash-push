# Git Conventional Commit Script

A bash script that simplifies the process of creating standardized git commit messages following the [Conventional Commits](https://www.conventionalcommits.org/) specification. This script automatically formats your commit messages, integrates ticket/issue numbers from your branch names, and supports all Git commit options.

## Features

- Enforces conventional commit message format
- Automatically extracts ticket numbers from branch names
- Supports all standard conventional commit types
- Passes through any Git commit options
- User-friendly command-line interface

## Installation

1. Choose one of these options to make the script easily accessible:

   **Option A: Move to a directory in your PATH**
   ```bash
   sudo mv commit.sh /usr/local/bin/git-cc
   ```

   **Option B: Create a Bash alias**
   
   Add this line to your `~/.bashrc`, `~/.zshrc`, or equivalent shell configuration file:
   ```bash
   alias gitc="/path/to/commit.sh"
   ```
   
   Then reload your shell configuration:
   ```bash
   source ~/.bashrc  # or source ~/.zshrc for Zsh users
   ```

## Usage

```bash
./commit.sh [commit-type] "commit message" [git options]
```

Or if installed as a global command:

```bash
git-cc [commit-type] "commit message" [git options]
```

Or if using the bash alias:

```bash
gitc [commit-type] "commit message" [git options]
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

### Git Options

The script passes through all Git commit options, allowing you to use any option supported by `git commit`. Common options include:

- `-a, --all`: Commit all changed files
- `-n, --no-verify`: Skip git hooks
- `--amend`: Amend previous commit
- `-s, --signoff`: Add Signed-off-by line
- `-S, --gpg-sign`: GPG sign commit

### Examples

```bash
# Simple feature commit
gitc feat "Add user authentication"

# Fix with all changed files and skipped hooks
gitc fix "Resolve login redirect issue" -a --no-verify

# Documentation update with signed commit
gitc docs "Update API documentation" -s

# Amend previous commit
gitc chore "Fix typo in previous commit" --amend

# Complex example with multiple options
gitc refactor "Clean up authentication flow" -a -s --no-verify
```

## Branch Name Integration

The script automatically extracts ticket numbers from your branch name and adds them to the commit message. Supported branch name formats include:

- `feature/ABC-123-description`
- `bugfix/123-fix-something`
- `123-some-description`

For example, if your current branch is `feature/ABC-123-new-login` and you run:

```bash
gitc feat "Implement login form" -a
```

The resulting commit message will be:

```
feat: (#ABC-123) Implement login form
```

## Setting Up Git Aliases

You can also set up Git aliases for even more convenience:

```bash
# Add a Git alias to use the script
git config --global alias.cc '!/path/to/commit.sh'
```

Then you can use:

```bash
git cc feat "Add new feature" -a
```

## Pre-commit Hooks Compatibility

This script works seamlessly with pre-commit hooks:

- By default, all configured Git hooks will run normally
- Use the `-n` or `--no-verify` option to bypass hooks when needed
- Works with hook managers like Husky, pre-commit, and native Git hooks

## Customization

You can modify the script to:
- Change the commit message format
- Add new commit types
- Modify the ticket number extraction regex
- Adjust the output formatting
- Change how Git options are handled

## Requirements

- Bash shell
- Git

## License

[MIT License](LICENSE)
