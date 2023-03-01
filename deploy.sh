value=$(sudo lsof -n -i :80 | grep LISTEN | awk -F ' ' '{print $2}') && sudo kill -9 $value > /dev/null

if [-d $value]
then
  sudo MICRONAUT_SERVER_PORT=80 nohup java -jar esop-0.1-all.jar  > /dev/null &
  exit
else
  sudo kill -9 $value
  sudo MICRONAUT_SERVER_PORT=80 nohup java -jar esop-0.1-all.jar > /dev/null &
  exit
fi