#!/bin/bash
#--------------------------------------------------------------------
#
#   TODO: Add program description
#
#--------------------------------------------------------------------


pushd $(dirname $0) >/dev/null
secure_dir=$(pwd)
popd >/dev/null


dockerfile_path="."
tag="qt_build_env"
debug=false


usage()
{
    echo "Usage: sudo ./$(basename $0) [optional params]"
    echo "Supported optionnal params:"
    echo " -p,--path        <path>  path to dockerfile (default: .)"
    echo " -c,--clean               clean docker container and image"
    echo " -d,--debug               activate debug flag"
    echo " -h,--help                print this help and exit"
    echo " -v,--version             print program version and exit"
}


version()
{
    printf "program: $(basename $0) version 0.0.1\n"
}


clean()
{
    docker rmi "$tag"
}


init_qt_env()
{
    docker build -t "$tag" "$dockerfile_path"

    docker run --rm -it -e DISPLAY=$DISPLAY \
        -v /tmp/.X11-unix:/tmp/.X11-unix \
        -v "$(pwd)/project:/home/project" \
        "$tag"
}


while [ $# -gt 0 ]
do
    key="$1"
    case $key in
        -p|--path)
            dockerfile_path="$2"
            shift
            ;;
        -c|--clean)
            clean
            exit 0
            ;;
        -d|--debug)
            debug=true
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        -v|--version)
            version
            exit 0
            ;;
        *)
            usage
            exit 1
            ;;
    esac
    shift
done


if [ "$debug" == true ]; then
    set -x
fi


init_qt_env


if [ "$debug" == true ]; then
    set +x
fi

