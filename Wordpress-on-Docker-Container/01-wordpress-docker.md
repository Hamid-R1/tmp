01-wordpress-docker


# Wordpress Application Deploy on Docker Container With MySQL Databse


### launche one instance 
- ami: ubuntu-20.04, SG-All && go with default configuration


### install docker
```
sudo su

{
apt-get update
apt install docker.io -y
docker --version
}


# create docker network
docker network create webnet
```




### mysql container 
```
{
mkdir mysql
cd mysql
}


# create Dockerfile
vim Dockerfile

# see Dockerfile
cat Dockerfile
FROM mysql
ENV MYSQL_ROOT_PASSWORD admin123
ENV MYSQL_DATABASE UserDB


# build image
docker build -t mysql_image .

# see images
docker images

# create container(mysql_cont)
docker run --name mysql_cont -d -p 3306:3306 --network webnet mysql_image

# see container
docker ps
```




### wordpress container
```
cd ../
pwd			#/home/ubuntu


{
mkdir wp
cd wp/
}


# create Dockerfile for wordpress application
vim Dockerfile


# see Dockerfile
cat Dockerfile
FROM wordpress
WORKDIR /var/www/html/



# build Dockerfile
docker build -t wp_image .

# see images
docker images

# create container from wp_image
docker run --name wp_cont -d -p 80:80 --network webnet wp_image

# see container
docker ps
```



### go inside container `wp_cont` & do configration for database connection:
```
docker exec -it wp_cont bash

# do configration for database connection:
ls
cp wp-config-sample.php wp-config.php
sed -i "s/'database_name_here'/'UserDB'/g" wp-config.php
sed -i "s/'username_here'/'root'/g" wp-config.php
sed -i "s/'password_here'/'admin123'/g" wp-config.php
sed -i "s/'localhost'/'mysql_cont'/g" wp-config.php
# come out from container to host_os
exit
```




### Next >> paste public-ip in new tab & install wordpress
- open 'hello world' post & `comment` something...


### Next go to `mysql_cont` & see database:
```
docker ps
docker exec -it mysql_cont bash

mysql -u root -p			#password is 'admin123'

# see sql queries
show databases;
use UserDB;
show tables;
select * from wp_comments;

# come out into host_os
exit
exit
```


##### =============>Thank You<============================
