#!/bin/bash
# Define available commit types
COMMIT_TYPES=(fix feat docs style refactor test chore ci breaking perf)

# Default values
commit_type=""
input_msg=""
no_verify=false
show_help=false

# Function to display help message
show_usage() {
    echo "Usage: $0 [commit-type] \"commit message\" [options]"
    echo "Formats git commits using conventional commits standard."
    echo
    echo "Commit types:"
    for type in "${COMMIT_TYPES[@]}"; do
        echo "  $type"
    done
    echo
    echo "Options:"
    echo "  -n, --no-verify    Skip git hooks"
    echo "  -h, --help         Show this help message"
    echo
    echo "Example: $0 feat \"Add new login feature\" --no-verify"
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
    
    case "$key" in
        -n|--no-verify)
            no_verify=true
            ;;
        -h|--help)
            show_help=true
            ;;
        *)
            # If we already have a message, append this argument to it
            if [[ -n "$input_msg" ]]; then
                input_msg="$input_msg $key"
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

# Display the message before committing
echo "Committing with message: $commit_msg"

# Execute the commit
if $no_verify; then
    git commit -m "$commit_msg" -n
else
    git commit -m "$commit_msg"
fi

# Check if commit was successful
if [[ $? -eq 0 ]]; then
    echo "Commit successful!"
else
    echo "Commit failed!"
    exit 1
fi