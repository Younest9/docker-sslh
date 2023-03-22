# docker-sslh

Docker image of ssl/ssh (sslh)

SSH traffic routed through https port 443 (ssh over https)


### Build the docker image

Clone this repository:
```bash
git clone https://github.com/younest9/docker-sslh.git
```

Install git if not installed:
- Debian based
```bash
apt install -y git
```
- Fedora based
```bash
dnf install -y git
```

Change directory to repository folder:
```bash
cd docker-sslh
```

If you're running ssh on default port, then skip this part:
  Change ssh default port if you're running it on a port other that 22 in entrypoint.sh file:
  ```bash
  sed -i 's/127.0.0.1:22/127.0.0.1:<new-port>/g' entrypoint.sh
  ```
  >Make sure you replace the <new-port> area with the current port of you ssh server
  
  > Example:
  >
  > - ssh on port 2222, you need to change the entrypoint.sh file : 127.0.0.1:22 to 127.0.0.1:2222, or you can run this command:
  > ```bash
  > sed -i 's/127.0.0.1:22/127.0.0.1:2222/g' entrypoint.sh
  > ```

Build the docker image:
```bash
docker build -t sslh .
```

Install docker if not installed:
- Debian based
```bash
apt install docker.io -y
```
- Fedora based
```bash
dnf install docker.io -y
```
Now, you should see the image that you built named `sslh` by simply typing this command:
```bash
docker images ls
```

### Deploy a container

Now that your image is ready to use, you can deploy a container with that image:
```bash
docker run -d -p 443:443 --name sslh sslh:latest
```
You can check if you container is working properly using this command:
```bash
docker ps
```
If you don't see a container named `sslh`, then your container didn't start, you can verify that as well:
```bash
docker ps -a    # To list all containers on your machine
```

You can see the logs and try to troubleshoot the container:
```bash
docker logs sslh
```
To see continuous logs of the container, add -f flag like this:
```bash
docker logs -f sslh
```

### Access the container

Now that you have a container running theb image that you built, you can ssh to the container via https (port 443)
To do that:
```bash
ssh root@localhost -p 443 # default user is root, and default password is password
```

> The docker image is configured to let the `root` user on sslh, you can change that by deleting a few lines:
>
> - RUN echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
> - RUN echo 'root:password' | chpasswd
>
>And add new lines to create a new user, and set a password for it: (change username and password as you like)
>
> - RUN apt install sudo -y
> - RUN useradd `<username>` --home /home/<username> --create-home --groups sudo --shell /bin/bash
> - RUN echo '`<username>`:`<password>`' | chpasswd
>
> You also need to change the user in the entrypoint.sh file:
>
> - Change `root` to `<username>` that you created
>
> Rebuild the image and run the docker run command as above
> 
> Now you should be able to ssh using the username and the password that you set:
> ```bash
>ssh <username>@localhost -p 443
>```

### Publish image
To publish the docker image that you created, you start by tagging the image:
- If you want to push it to docker hub, you just need to add your username to the tag, and specify the version in `<tag>` area (defaults to latest):
  
  ```bash
  docker tag sslh:latest <docker-hub-username>/sslh:<tag>
  ```
  
- If you want to push it to a private registry, you need to add the hostname of the registry (works with IP address as well), and specify explicitly the port, and add the version in `<tag>` area (defaults to latest):
  
  ```bash
  docker tag sslh:latest <hostname:port>/sslh:<tag>
  ```

Now that you image has been tagged the right way, you can push it:
- Docker hub:
  First, you need to login to your account
  
  ```bash
  docker login
  ```
  And then push the image:
  
  ```bash
  docker push <docker-hub-username>/sslh:<tag>
  ```
 - Private registry:
   push the image directly:
   
   ```bash
   docker push <hostname:port>/sslh:<tag>
   ```
   
   
Credits (Idea): [yrutschle/sslh](https://github.com/yrutschle/sslh)
