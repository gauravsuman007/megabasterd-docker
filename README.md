# megabasterd-docker

A containerized app for megbasterd from https://github.com/tonikelope/megabasterd

This is a debian container with noVNC which enables the running app GUI (Megabasterd) to be accessed from a web browser. I used the base image from https://github.com/jlesage/docker-baseimage-gui and configured it to run Megabasterd.

## Setup
### Step 1: Setting up the docker container
I recommend using docker-compose, a typical script for that would look like:
```
version: '3'
services:
  megabasterd:
    image: gauravsuman007/megabasterd
    ports:
      - "5800:5800"
    volumes:
      - "./config:/config:rw"
      - "./output:/output:rw"
```

Here the folder `./output` refers to the location where the files will be downloaded on the disk, feel free to modify it as per your needs(This needs to be configured, see step 2)
You can also choose to move the `./config` folder to another location but it's not neccessary.

Alternatively, you can always clone the repo and build your own image using the provided Dockerfile.

### Step 2: Accessing the app and configuring it
The web UI can be accessed at port `5800`.
On the first run, go to the top menu "Edit" -> "Settings", here you should configure the following items:
- Download folder to to point it to /output
<img width="755" alt="image" src="https://user-images.githubusercontent.com/16671262/191015820-803abd22-6aa3-4c6f-aaa0-85204fd065a4.png">

- MEGA API key (Under Advanced)
<img width="758" alt="image" src="https://user-images.githubusercontent.com/16671262/191016225-c36cb218-9b70-4e5d-afb8-fafd707fa239.png">

- (Optional) Use Smartproxy.

