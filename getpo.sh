#!/bin/bash
#### e.g.
#### alias kpo='bash /home/larry/util/getpo.sh -action yaml -keyword'
#### alias kpl='bash /home/larry/util/getpo.sh -action log -keyword'
set -e

while [[ $# -gt 0 ]]
do
    key="$1"
    case $key in
        -action) action=$2
          shift
          shift
          ;;
        -keyword) keyword=$2
          shift
          shift
          ;;
        *) POSITIONAL+=("$1")
          shift
          ;;
    esac
done

pod_name=$(kubectl get po | grep $keyword | awk '{print $1}' | sed -n '1p')
if [ ! -n "$pod_name" ];then
  echo "no pod found"
  exit
fi

if [ $action = "log" ];then
  kubectl logs $pod_name
elif [ $action = "yaml" ];then
  kubectl get po $pod_name -o yaml
fi
