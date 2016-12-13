## Docker Build - MCE
Builds the MCE project in a Dockerized Scala/SBT environment.
Pulls latest code from stash and runs the sbt build. 

### PreReqs
You must install a Docker engine on a linux box first.

### Usage
clone this repo and navigate inside to ./docker-mce
```
docker build . -t snoo-snoo
docker run snoo-snoo ./build.sh #{build.number} #{build.branch}
```
for example
```
docker run snoo-snoo ./build.sh 564 feature/ABC-13857_awesome-feature
```

#### Packaging RPM
to build and run the RPM packaging docker jump into ./docker-rpm and run
```
docker build . -t tata
docker run tata ./package.sh #{build.number} #{build.branch}
```
for example
```
docker run tata ./package.sh 564 feature/ABC-13857_awesome-feature
```
Which will fire up the docker, download the fat jars from Artifactory with that build number
and package them into an RPM and upload the RPM to Artifactory. 

To debug and jump in the container without running the build:
```
docker run -i -t --entrypoint /bin/bash snoo-snoo
```
From there you can manually launch the ./build.sh script to debug. 
