#!/bin/bash
cd /home/jenkins/data/workspace/zkweb/target
#参数设定
#1.映射端口，不指定则使用随机值
PORT=8099

#2.容器名字，不指定则使用打包tag号，如：jenkins-myapp-18
NAME=harbor.hub.com/library
JOB_NAME=zkweb

#-----------------------下列内容请勿修改---------------------------------
#-----------------------下列内容请勿修改---------------------------------
#-----------------------下列内容请勿修改---------------------------------
if [ -z "$NAME" ]; then 
    NAME=$JOB_NAME
fi

TAG=19.`date "+%m.%d.%H.%M%S"`

cat << 'EOF' > Dockerfile
FROM hub.c.163.com/library/centos:7.4.1708
MAINTAINER yonge <yonge@126.com>
ARG version_tag
LABEL version=${version_tag:-0.0.1} author="yonge <yonge@126.com>"
WORKDIR /root
RUN echo ${version_tag:-0.0.1} > ./version
ADD ./jdk-8u101-linux-x64.tar.gz /root
COPY ./zkWeb-v1.2.1.war /root
ENV JAVA_HOME "/root/jdk1.8.0_101"
ENV PATH "$JAVA_HOME/bin:$PATH"
CMD ["-jar","zkWeb-v1.2.1.war"]  
ENTRYPOINT ["java"]
EOF
# sed -i "s/version=.*/version=$TAG/g" Dockerfile
IMAGE=$NAME/$JOB_NAME:$TAG
docker build --build-arg version_tag="$TAG" -t $IMAGE --rm=true .


imagename=$NAME/$JOB_NAME

docker login harbor.hub.com -u admin -p Harbor12345
lod_latest_version=`docker inspect -f "{{ .Config.Labels.version }}" $imagename:latest`
docker tag $imagename:latest $imagename:$lod_latest_version
docker push $imagename:$lod_latest_version

docker tag $IMAGE $imagename:latest
docker push $imagename:latest

# docker ps -a |grep $IMAGE

# docker inspect -f "{{ .Config.Labels.version }}" $IMAGE | python -m json.tool