value=$(sudo lsof -n -i :80 | grep LISTEN | awk -F ' ' '{print $2}') && sudo kill -9 $value > /dev/null
MICRONAUT_SERVER_PORT=80
if [-z $value]
then
  sudo nohup java -jar esop-0.1-all.jar  > /dev/null &
  exit
else
  sudo kill -9 $value
  sudo nohup java -jar esop-0.1-all.jar > /dev/null &
  exit
fi