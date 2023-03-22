project-08-V2





======= install docker && docker-compose on ubuntu20.04 =========

```
sudo su -
apt-get update -y
apt install docker.io -y
docker --version
apt install docker-compose -y
docker-compose -v
```


```
mkdir project
cd project
vim docker-compose.yml
mkdir db_data
mkdir wp_data
docker-compose up -d
```


```
cat docker-compose.yml
version: '3'
services:
  db:
    image: mysql:latest
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: admin123
      MYSQL_DATABASE: hr_db
    volumes:
      - db_data:/var/lib/mysql
  wordpress:
    depends_on:
      - db
    image: wordpress:latest
    restart: always
    ports:
      - "80:80"
    environment:
      WORDPRESS_DB_HOST: db:3306
      WORDPRESS_DB_USER: root
      WORDPRESS_DB_PASSWORD: admin123
      WORDPRESS_DB_NAME: hr_db
    volumes:
      - wp_data:/var/www/html
volumes:
  db_data:
  wp_data:
```


## access wp-apps via public-ip
- yes access,
- install & configure wordpress, done.


```
docker exec -it project_db_1 bin/bash

# go to mysql client/cli
mysql -u root -p		#password is 'admin123'

# see databases
mysql> show databases;

mysql> use hr_db;

mysql> show tables;

mysql> select * from wp_posts;

```




### check database connection
- stop mysql_container (project_db_1) & refresh website page & observer if wordpress is  still connected or not, 
-
```
root@ip-172-31-22-205:~/project# pwd
/root/project

docker ps -a

docker stop project_db_1
```

- Next go to website page & refresh page:
	- here we get this `Error establishing a database connection` bcuz mysql_container is not running & connected with application.

- Next, now if you again run mysql_container in backgroud & then if you go to website so now you will get website,
```
docker start project_db_1
```
	- yes now website is live, bcuz mysql database is connected with wordpress_application,




### now, create images from both running containers
- create 1 image from `project_wordpress_1`(wordpress_container)
- create 1 image from `project_db_1`(mysql_container)
```
docker ps -a

# create 1 image with image_name `wp_dev1` from `project_wordpress_1` (wordpress_container)
docker commit project_wordpress_1 wp_dev1

# create 1 image with image_name `mysql_dev1` from `project_db_1` (mysql_container)
docker commit project_db_1 mysql_dev1

# see created images
docker images
```

### pull these images to docker-hub repo
- `wp_dev1`
	- this is wordpress_application which is already configure and its all data is stored in `mysql_dev1` images,
- `mysql_dev1`

```
# logine with docker-hub credentials
docker login
	# docker credentials: username= hra3375 

# push both images from this instance to docker-hub repo
docker tag wp_dev1 hra3375/wp_1
docker push hra3375/wp_1

docker tag mysql_dev1 hra3375/mysql_1
docker push hra3375/mysql_1
```



## Next launch one more ec2-instance with ubuntu20.04
- install docker & docker-compose
```
sudo su -
apt-get update -y
apt install docker.io -y
docker --version
apt install docker-compose -y
docker-compose -v
```


### To deploy the WordPress and MySQL containers that you have created and pushed to Docker Hub, you can follow these steps:
- Create a new directory for your project, and then create a file named `docker-compose.yml` in that directory,
```
mkdir project
cd project/
vim docker-compose.yml
mkdir db_data
mkdir wp_data
```


- see `docker-compose.yml`
	- this `docker-compose.yml` file is going to pull your images & configured,
```
cat docker-compose.yml
version: '3'
services:
  db:
    image: hra3375/mysql_1
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: admin123
      MYSQL_DATABASE: hr_db
    volumes:
      - db_data:/var/lib/mysql
  wordpress:
    depends_on:
      - db
    image: hra3375/wp_1
    restart: always
    ports:
      - "80:80"
    environment:
      WORDPRESS_DB_HOST: db:3306
      WORDPRESS_DB_USER: root
      WORDPRESS_DB_PASSWORD: admin123
      WORDPRESS_DB_NAME: hr_db
    volumes:
      - wp_data:/var/www/html
volumes:
  db_data:
  wp_data:
```


- run docker-compose file
```
docker-compose up -d
```


- copy public-ip & paste to new tab & see website,
	- get error `Error establishing a database connection`






=========================================



