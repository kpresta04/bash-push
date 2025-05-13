#!/bin/bash
# Define available commit types
COMMIT_TYPES=(fix feat docs style refactor test chore ci breaking perf)

# Default values
commit_type=""
input_msg=""
git_options=()
show_help=false
use_date=false

# Function to display help message
show_usage() {
    echo "Usage: $0 [commit-type] \"commit message\" [git options]"
    echo "Formats git commits using conventional commits standard."
    echo
    echo "Commit types:"
    for type in "${COMMIT_TYPES[@]}"; do
        echo "  $type"
    done
    echo
    echo "Common git options:"
    echo "  -a, --all            Commit all changed files"
    echo "  -n, --no-verify      Skip git hooks"
    echo "  --amend              Amend previous commit"
    echo "  -s, --signoff        Add Signed-off-by line"
    echo "  -S, --gpg-sign       GPG sign commit"
    echo "  -d, --date           Use current date as commit message (YYYY-MM-DD), sets type to chore"
    echo
    echo "Any valid git commit option can be used."
    echo
    echo "Example: $0 feat \"Add new login feature\" --no-verify --signoff"
    echo "Example: $0 -d --all"
    exit 0
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    key="$1"
    
    # Check if argument is a valid commit type
    valid_type=false
    for type in "${COMMIT_TYPES[@]}"; do
        if [[ "$key" == "$type" ]]; then
            commit_type="${type}:"
            valid_type=true
            break
        fi
    done
    
    if $valid_type; then
        shift
        continue
    fi
    
    # Process other arguments
    case "$key" in
        -h|--help)
            show_help=true
            ;;
        -d|--date)
            use_date=true
            commit_type="chore:"
            ;;
        -*)
            # This is a git option, save it
            git_options+=("$key")
            ;;
        *)
            # If we already have a message, it's probably another option or argument for git
            if [[ -n "$input_msg" ]]; then
                git_options+=("$key")
            else
                input_msg="$key"
            fi
            ;;
    esac
    shift
done

# Show help if requested
if $show_help; then
    show_usage
fi

# Validate required inputs
if [[ -z "$commit_type" ]]; then
    echo "Error: Commit type is required."
    show_usage
fi

# Handle date flag
if $use_date; then
    if [[ -n "$input_msg" ]]; then
        echo "Error: Cannot use -d/--date flag with a commit message."
        show_usage
    fi
    input_msg="$(date +%Y-%m-%d)"
fi

if [[ -z "$input_msg" ]]; then
    echo "Error: Commit message is required."
    show_usage
fi

# Extract ticket number from branch name (supports various formats)
branch=$(git symbolic-ref --short HEAD 2>/dev/null || echo "")
if [[ -z "$branch" ]]; then
    echo "Error: Not in a git repository or no branch checked out."
    exit 1
fi

# Extract ticket number from branch - supports formats like:
# feature/ABC-123, bugfix/123, 123-some-description
ticket_pattern='([A-Z]+-)?([0-9]+)'
if [[ $branch =~ $ticket_pattern ]]; then
    # Use the ticket prefix if it exists, otherwise just use the number
    if [[ -n "${BASH_REMATCH[1]}" ]]; then
        # Remove trailing dash from ticket prefix
        prefix=${BASH_REMATCH[1]%?}
        ticket_number="${prefix}-${BASH_REMATCH[2]}"
    else
        ticket_number="${BASH_REMATCH[2]}"
    fi
    commit_prefix="$commit_type (#$ticket_number)"
else
    commit_prefix="$commit_type"
fi

# Format the commit message
commit_msg="$commit_prefix $input_msg"

# Display the message and options before committing
echo "Committing with message: $commit_msg"
if [[ ${#git_options[@]} -gt 0 ]]; then
    echo "Using git options: ${git_options[*]}"
fi

# Build the commit command
commit_cmd=("git" "commit" "-m" "$commit_msg")

# Add any additional git options
if [[ ${#git_options[@]} -gt 0 ]]; then
    commit_cmd+=("${git_options[@]}")
fi

# Execute the commit command
"${commit_cmd[@]}"

# Check if commit was successful
if [[ $? -eq 0 ]]; then
    echo "Commit successful!"
else
    echo "Commit failed!"
    exit 1
fi