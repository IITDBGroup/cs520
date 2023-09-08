# Running Dockerized Vizier

For the project we will use a docker installation of Vizier. If you are not familiar with docker, please install it on your system and learn how to download images and run containers.

## Intel users

You have to download the following image

```sh
docker pull iitdbgroup/vizier_iit_cs520_fall23:intel
```

**Vizier stores all project files in a directory. You want this directory to be on your machine rather than in the docker container. Otherwise, all your projects will be deleted when the container is removed.** This can be achieved by mounting a local directory on your machine into the container at the place where vizier stores its files. Let's first create such a directory, e.g.,

```sh
mkdir ~/vizier-520-project-data
```

Now when you start Vizier as a docker container you want to mount this directory and forward the right ports to your local machine:

```sh
cd ~/vizier-520-project-data
docker run  --name vizier --rm -v `pwd`:/vizier.db -p 5001:5001 -p 8089:8089 iitdbgroup/vizier_iit_cs520_fall23:intel -p 5001
```

Afterwards, you can access Vizier through a browser on your local system by opening the url: [http://127.0.0.1:5001](http://127.0.0.1:5001)

## Apple Silicon and ARM users

You have to use this image instead: `iitdbgroup/vizier_iit_cs520_fall23:arm`

Otherwise, the command to start Vizier is the same as above.

```sh
docker pull iitdbgroup/vizier_iit_cs520_fall23:arm
```

# Using Vizier

Detailed documentation for Vizier can be found here: [https://github.com/VizierDB/vizier-scala/wiki](https://github.com/VizierDB/vizier-scala/wiki)

If you are familiar with Jupyter, you may have some trouble with using Vizier initially as it operates differently in several regards. Have a look at [https://github.com/VizierDB/vizier-scala/wiki/Migrating-from-Jupyter](https://github.com/VizierDB/vizier-scala/wiki/Migrating-from-Jupyter) to see where Vizier's notebook experience differs from Jupyter and why.

