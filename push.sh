
#!/bin/bash


# Echo the arguments

LONGOPTS=fix,feat,docs,style,refactor,test,chore,ci,breaking,perf

# Loop through the arguments
while [[ $# -gt 0 ]]; do
    key="$1"
    case "$key" in
        fix)
        type="fix: "
        ;;
        feat|feature)
        type="feat: "
        ;;
        docs)
        type="docs: "
        ;;
		style)
		type="style: "
        ;;
		refactor)
		type="refactor: "
		;;
		test)
		type="test: "
		;;
		chore)
		type="chore: "
		;;
		ci)
		type="ci: "
		;;
		breaking)
		type="breaking: "
		;;
		perf)
		type="perf: "
		;;
        *)
        # Do whatever you want with extra options
        echo "Unknown option '$key'"
        ;;
    esac
    # Shift after checking all the cases to get the next option
    shift
done

branch=$(git symbolic-ref --short HEAD)

# [[ branch =~ ([0-9]+) ]] && echo "${BASH_REMATCH[1]}"
ticket_number=${branch//[^[:digit:]]/}

echo $ticket_number



echo $type
