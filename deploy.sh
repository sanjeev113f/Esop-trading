value=$(sudo lsof -n -i :80 | grep LISTEN | awk -F ' ' '{print $2}') && sudo kill -9 $value > /dev/null
if [-z $value]
then
  sudo nohup java -jar m2.jar  > /dev/null &
  exit
else
  sudo kill -9 $value
  sudo nohup java -jar m2.jar > /dev/null &
  exit
fi