
#!/bin/bash


# Echo the arguments

LONGOPTS=fix,feat,docs,style,refactor,test,chore,ci,breaking,perf

# Loop through the arguments
while [[ $# -gt 0 ]]; do
    key="$1"
    case "$key" in
        fix)
        commit_type="fix:"
        ;;
        feat|feature)
        commit_type="feat:"
        ;;
        docs)
        commit_type="docs:"
        ;;
		style)
		commit_type="style:"
        ;;
		refactor)
		commit_type="refactor:"
		;;
		test)
		commit_type="test:"
		;;
		chore)
		commit_type="chore:"
		;;
		ci)
		commit_type="ci:"
		;;
		breaking)
		commit_type="breaking:"
		;;
		perf)
		commit_type="perf:"
		;;
		-n|--no-verify)
		no_verify=true
		;;
        *)
        # Do whatever you want with extra options
        echo "Unknown option '$key'"
		
        ;;
    esac
    # Shift after checking all the cases to get the next option
    shift
done

if [ -z "$commit_type" ]; then
	exit 1
fi

branch=$(git symbolic-ref --short HEAD)

ticket_number=${branch//[^[:digit:]]/}

if [ -z "$ticket_number" ]; then
	commit_prefix=$commit_type
	else
		commit_prefix="$commit_type (#$ticket_number)"
fi


read -p "Enter commit message: " input_msg

commit_msg="$commit_prefix $input_msg"

if [ -z "$no_verify" ]; then
	git commit -m "$commit_msg"
	else
		git commit -m "$commit_msg" -n
fi