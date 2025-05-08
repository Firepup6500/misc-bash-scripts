for i in $(\ls);do
  cd $i &> /dev/null
  if [[ "$?" == "0" ]];then
    echo pulling $i...
    git pull
    cd ..
  fi
done
