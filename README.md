Simple DBpedia Docker Container
===============================

This repository contains all files needed to build a [Virtuoso Open Source](https://github.com/openlink/virtuoso-opensource) instance preloaded with the [latest DBpedia dataset](http://wiki.dbpedia.org/Downloads) inside a [Docker](http://docker.com/) container.

# Running

**Warning!**
> Running Virtuoso with DBpedia requires significant resources.
Make sure you have at least 80 Gb of free disk space!
It is also recommended to run it on system that has at least 16 Gb of RAM.

To start the local version of DBpedia simply execute:
```sh
$ docker run -p 8890:8890 -e DEFAULT_GRAPH=http://dbpedia.org -d aksw/dbpedia
```

This will spawn a local Virtuoso instance with DBpedia and link the port 8890 to your Docker host.
Which will allow you to navigate to [http://localhost:8890/sparql](http://localhost:8890/sparql) to see the SPARQL endpoint with DBpedia data.

If you have not followed build instructions below and don't have `aksw/dbpedia` image locally, it will be downloaded from [Docker Hub](https://hub.docker.com/r/aksw/dbpedia/).
Pre-built container includes only core and English data for DBpedia, so if you need additional languages - you will have to build it yourself.

# Building

**Warning!**
> Building Virtuoso with DBpedia requires significant resources.
Make sure you have at least 150 Gb of free disk space!
It is also recommended to run it on system that has at least 64 Gb of RAM.
It might take several days to finish, so it is recommended to execute build process on a standalone server.

To build your own container you have do the following.
First, download, unpack and prepare required DBpedia files by executing:
```sh
$ make prepare
```
Then, start new virtuoso instance by executing:
```sh
$ make virtuoso
```
Finally, start import procedure by executing:
```sh
$ make import
```

As noted in the warning, the import procedure might take up to several days depending on the hardware you are using.

### Additional languages

Currently Makefile and import scripts will only download and import core and English DBpedia files.
If you wish to add more languages, you'll need to edit `download`, `unpack` and `move` targets in Makefile as well as list of imported folders in `virtuoso/import.sh` file.
