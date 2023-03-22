### install docker-and-docker-compose into ubuntu from `yt`
- launche one instance with ubuntu20.04
- install docker-and-docker-compose
```
sudo su
apt-get update
apt install -y docker.io
docker --version

# install docker-compose
apt install -y docker-compose
docker-compose -v
```






### Install Docker Engine on Ubuntu (docker-and-docker-compose) from `official website`
- launche one instance with ubuntu20.04
- Install Docker Engine on Ubuntu from `official website`
	- `refference link`: https://docs.docker.com/engine/install/ubuntu/
```
sudo apt-get update

# Uninstall old versions
sudo apt-get remove docker docker-engine docker.io containerd runc

# Set up the repository
sudo apt-get update
sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# Add Docker’s official GPG key:
sudo mkdir -m 0755 -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Use the following command to set up the repository:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update the apt package index:
sudo apt-get update

# Install Docker Engine, containerd, and Docker Compose.
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# check docker && docker-compose
sudo docker --version
sudo docker compose version

# Noted: here docker-compose commands are not working
```






### install docker-and-docker-compose into amazon-linux-2
- launche one instance with amazon-linux-2
- install docker-and-docker-compose
```
sudo su
yum update -y && yum upgrade -y

# install docker
yum install docker -y
docker -v      or    docker --version

systemctl status docker
systemctl start docker
systemctl enable docker

# install docker-compose
#Noted: I think docker-compose is not supported amazon-linux-2
```
