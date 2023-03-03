rm docker -rf
mkdir ./docker
cp ./build/libs/zh-gateway-0.0.1-SNAPSHOT.jar ./docker/
cp ./src/main/resources/Dockerfile ./docker
cd docker
CON=`docker image ls '10.1.0.67:5000/dev-zh-gateway' | wc -l`
if [ $CON -eq 2 ]
then
docker rmi 10.1.0.67:5000/dev-zh-gateway:latest
fi
docker build --build-arg JAR_FILE="zh-gateway-0.0.1-SNAPSHOT.jar" -t "10.1.0.67:5000/dev-zh-gateway:latest" .
docker images
docker push 10.1.0.67:5000/dev-zh-gateway:latest
