
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

ticket_number=${branch//[^[:digit:]]/}

if [ -z "$ticket_number" ]; then
	echo "No ticket number found in branch name"
	else
		ticket_string="(#$ticket_number)"
		echo $ticket_string
fi



echo $type
