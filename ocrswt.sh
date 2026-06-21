if [ "$2" == "root" ];then
  evelator="sudo -i "
fi
ssh $1 -t "$evelator"'bash -c '"'"'printf "\x1b]2;$(whoami)@$(hostname) $([ $(id -u) -eq 0 ]&&echo \#||echo $)\x1b\\"&&'"${@:3}'"
