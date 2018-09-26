#/bin/bash
#set -x
set -e

usage()
{
cat <<EOF
Usage:
`basename $0` [OPTIONS] <non-option arguments>

Purpose:
　　xxxxxxxxxxxx

Description:
　　None

Parameters:

　　OPTIONS
　　　　-i image -- images, registry:2 by default
　　　　-p -- host port, 5000 by default

　　<non-option arguments>

Author:
　　anor@xxxx.com

Revision:
　　2016-07-04 Anor Initial Versiona

EOF
exit 1
}

############################################
#declare options string including optional
#argument names separated from withsapce.
#g_opt_name includs optional arg names
#g_opt_<g_opt_name>, just holds optional arg value
#for example,
# Given optional args, -i, -p,
# the option arg variables respectivly should be as,
# g_opt_i
# g_opt_p
############################################
declare -a g_opt_names=(i: p:)

############################################
#init_args()
#initialize arguments before set them with
#command line values
############################################
init_args()
{
    g_opt_i="registry:2" # the registry image from hub.docker.com
    g_opt_p=5000
}

############################################
#parse_non_option_args()
#parse non option arguments here
############################################
parse_non_option_args()
{
    #//TODD add your code to parse non-option arguments here.

    return 0;
}

############################################
#main()
#add business logics in this [main] function
############################################
main()
{
    #//TODD add your bussiness code here

    return 0;
}


#*******************************************************
########################################################
### Common functions here
########################################################
#*******************************************************
parse_args()
{

    #check if showing usage
    if [ "$1" ==  "--help" ]; then usage; fi

    init_args

    parse_options "$@"

    parse_non_option_args "$@"
}
parse_options()
{
    local opt_names="${g_opt_names[@]}"

    local opt_string="$(echo -e "$opt_names" | tr -d '[[:space:]]')"

    log "opt_string=$opt_string"

    if [ -n "$opt_names" ]; then
        while getopts $opt_string opt
        do
            for i in "${g_opt_names[@]}"
            do
                local opt_name=${i:0:1}
                local opt_var_name=g_opt_$opt_name
                case $opt in
                    $opt_name )
                        if [ -z "$OPTARG" ]
                        then
                            eval $opt_var_name=1
                        else
                            eval $opt_var_name=\"$OPTARG\"
                        fi
                        log "$opt_var_name=${!opt_var_name}"
                        ;;
                    h ) usage ;;
                    \?) usage ;;
                esac
            done
        done
    fi
}

#Purpose:
#   echo log message
#
#Parameters:
#   @1.... -- log messages
#
log()
{
    echo "[`date +'%Y-%m-%d %H:%M:%S'` $0]" "${@:1}"
}

_main()
{

    #parse optional
    parse_args "$@"

    #main routine
    main "$@"

    #successful log
    log "Done!"
}

_main "$@"