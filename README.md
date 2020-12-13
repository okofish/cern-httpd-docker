# CERN httpd Docker image

## See this image running at [http://oldwww.jesse.ws/](http://oldwww.jesse.ws/).

The [CERN httpd](https://en.wikipedia.org/wiki/CERN_httpd) (HTTP daemon), initially released in June 1991, was the first web server software. This [Docker image](https://hub.docker.com/r/jessews/cern-httpd) contains the final version of the software, version 3.0A, released in July 1996. The CERN httpd was developed starting in 1990 by [Tim Berners-Lee](https://en.wikipedia.org/wiki/Tim_Berners-Lee), later joined by [Ari Luotonen](https://www.w3.org/People.html#Luotonen) and [Henrik Frystyk Nielsen](https://en.wikipedia.org/wiki/Henrik_Frystyk_Nielsen).

## Quick start

To start a container using the "history" image tag, with bundled historical content, run:
```shell
$ docker run -p 8080:80 jessews/cern-httpd:history -v
```

This will start a container with host port 8080 forwarded to container port 80, so you should be able to access the server at [http://localhost:8080](http://localhost:8080).

A command-line HTTP client such as [curl](https://curl.se) can be used to inspect the headers sent by this server. Note the `Server: CERN/3.0A` header, the [`HTTP/1.0`](https://tools.ietf.org/html/rfc1945) version, and the nonstandard `Document follows` reason phrase after the `200` status code:
```shell
$ curl -I http://localhost:8080
HTTP/1.0 200 Document follows
Server: CERN/3.0A
Date: Sun, 13 Dec 2020 23:24:01 GMT
Content-Type: text/html
Content-Length: 2370
Last-Modified: Sun, 13 Dec 2020 23:14:13 GMT
```

## Image variants

### [`jessews/cern-httpd`](https://hub.docker.com/r/jessews/cern-httpd) *([Dockerfile](https://github.com/okofish/cern-httpd-docker/blob/master/Dockerfile))*
*Base: [`alpine:3.12`](https://hub.docker.com/_/alpine)*  
This tagged image contains version 3.0A of the CERN httpd at `/usr/local/bin/httpd`. It also contains an `httpd.conf` configuration file (or "rule file") in the default location `/etc/httpd`. The configuration file instructs `httpd` to serve the contents of the `/src/www` directory (empty by default) on port 80.

The `ENTRYPOINT` of this image is the `httpd` executable, so you can simply invoke it like `docker run -p 8080:80 jessews/cern-httpd [FLAGS]`. The server works fine with no flags, but the `-v` and `-vv` flags are useful for logging and debugging. Supported flags are listed [here](https://www.w3.org/Daemon/User/CommandLine.html), and supported configuration file settings are listed [here](https://www.w3.org/Daemon/User/Config/Overview.html).

The `httpd` executable in this image is compiled from source by the [Dockerfile](https://github.com/okofish/cern-httpd-docker/blob/master/Dockerfile). Only [three lines](https://github.com/okofish/cern-httpd-docker/blob/master/httpd-patches.patch) in the 1996 code have been changed, in order for the software to compile in a modern Linux environment. 

### `jessews/cern-httpd:history` *([Dockerfile](https://github.com/okofish/cern-httpd-docker/blob/master/Dockerfile-history))*
*Base: `jessews/cern-httpd`*  
This tagged image is based on the base image variant, with the addition of a 1992 partial snapshot of [http://info.cern.ch](http://info.cern.ch), the first WWW site, in the `/hypertext` subdirectory (i.e. at `/srv/www/hypertext` on disk). This snapshot is obtained from the [W3C Historical Archives](https://www.w3.org/History/19921103-hypertext/hypertext), and has been merged with additional contents from the CERN httpd 3.0A distribution archive in order to fix some broken links. The image also includes an additional [landing page](https://github.com/okofish/cern-httpd-docker/blob/master/content-history/Welcome.html) ("welcome page") served at the root.

## Security notice

The version of the CERN httpd in these images is from 1996. Despite the containerization, care should nonetheless be taken when running a server exposed to the public Internet, as buffer overflows and other vulnerabilities likely exist in this old code.

## License

The contents of the cern-http-docker GitHub repository are released under the MIT license as given in the [LICENSE](https://github.com/okofish/cern-httpd-docker/blob/master/LICENSE) file.

The version 3.0A source distribution of the CERN httpd software is released under an MIT license; see the [W3C website](https://www.w3.org/Daemon/) for more information. The [distribution archive](https://www.w3.org/Daemon/httpd/w3c-httpd-3.0A.tar.gz) contains a license statement file.

These Docker images use Alpine Linux as a base. See the [`alpine` image page](https://hub.docker.com/_/alpine) for license information.

### CERN acknowledgement
This product includes computer software created and made available by CERN. This acknowledgment shall be mentioned in full in any product which includes the CERN computer software included herein or parts thereof.