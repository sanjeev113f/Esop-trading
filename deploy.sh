value=$(sudo lsof -n -i :80 | grep LISTEN | awk -F ' ' '{print $2}') && sudo kill -9 $value > /dev/null
if [-z $value]
then
  sudo nohup MICRONAUT_SERVER_PORT=80 java -jar esop-0.1-all.jar  > /dev/null &
  exit
else
  sudo kill -9 $value
  sudo nohup MICRONAUT_SERVER_PORT=80 java -jar esop-0.1-all.jar > /dev/null &
  exit
fi