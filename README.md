# cbox-commerce

[![Master Branch Build Status](https://img.shields.io/travis/jclausen/cbox-commerce/master.svg?style=flat-square&label=master)](https://travis-ci.org/jclausen/cbox-commerce)

## An e-commerce module for the coldbox platform

## Development Environment Installation

### Asset Pipeline ( WebPack )

Assets for the project are compiled using WebPack, which allows for minification and consolidation of Javascript and CSS dependencies for the application.  You will need the following installed, in order to compile the static assets for for the application:

* NodeJS
* NPM ( Installed with NodeJS in most installations )
* Python - This is installed, by default, for OSX users.  Windows users will need to point their NPM installation to the python binary manually.

Once the above dependencies are installed and configured, from the root of the site run:

```
npm install
```

This first command will install all necessary libraries for asset compilation.  The three commands for asset compilation are defined in the `script` section of the `package.json` file in the root of of the project ( all of which leverage the base `webpack` command ).  They are:

- `npm run dev` - compiles the assets for development without continuing to watch for changes

- `npm run watch` - compiles the assets for development and continues to watch for changes until `Ctrl+C` triggers an exit

- `npm run prod` - compiles the assets for production.  This process is more intensive because of advanced minification and cache-busting features built in to the production compilation.

_Note: Since the generated `rev-manifest.json` file contents are cached, switching between the `dev` and `prod` compilations will require a framework reinit for the file path changes to be reflected in the application_

The following paths are automatically compiled via convention:

* `/resources/assets/js` - compiles to `/includes/js`
* `/resources/assets/sass` - compiles to `/includes/css`

### Docker environment setup instructions

The following dependencies will need to be installed on your machine prior to starting the environment for the first time:

- Docker ^v17.03
- Docker Compose ^v1.15.0

#### Windows Users

1. Docker w/ Compose - https://docs.docker.com/docker-for-windows/
2. Obtain the private IP address of your default docker machine using the Docker Admin GUI ( examples: `127.0.0.` or  `192.168.99.100` )

#### Mac Users

1. Docker (w/GUI) - https://docs.docker.com/docker-for-mac/
2. Docker (Homebrew) - `brew install docker docker-compose`
3.  If your installation did not already created a default Docker machine, do so now.  Your machine requires at least 5GB of memory to run all of the required containers.

	- If you installed via Docker for Mac, this will already have been done for you.  You will need to adjust the memory allocation in the GUI tool to at least 5GB.
	- If you installed docker via homebrew, you will need to create it from the command line:  `docker-machine create default --virtualbox-memory "5120" && docker-machine start default`


#### Application Startup

1. To build and start all containers, in one command, use `docker-compose up -d --build` - the `-d` flag will start your containers in the background.
2. To start the app and tail the console output of all containers, once the initial `--build` command has been run, you may omit the `-d` flag ( for "daemon" ).
3. To view logs for any of the containers ( see the container names in `docker-compose.yml` ), you may run the command `docker-compose logs [ compose service name ]`.  To tail the output of the logs and limit it to the last 50 lines, use `docker-compose logs --follow --tail=50 [ compose name ]`
4. See `docker-compose help` for additional docker compose commands
5. To enter a host via ssh, you will need to find the id of the container by running `docker ps` and then "ssh" in to that container by running `docker exec -it [ container ID ] bash` or by running `docker-run [ compose service name] bash`

#### Starting and stopping indvidual containers

You may also start/stop individual containers using the `docker-compose start|stop|restart [ service name ]`.  The service names are listed in the root `docker-compose.yml` file:

1. `mysql` - MySQL (MariaDB) Server Service Name
3. `app` - The Lucee application server

To use the start/stop/restart commands, however the container must first be built.  To rebuild and start and indvidual container in the background you would use the following command:

```
docker-compose up -d --build [ service name ]
```

From that point on, you can use the `start|stop|restart` commands.

You may also stop individual containers from the command line.  To do so, run `docker ps` to show a list of running containers.  The ID of the container will be the hash on the left of the container row in the output:

```
CONTAINER ID        IMAGE                       COMMAND                  CREATED             STATUS                   PORTS                                              NAMES
4d3f96cd409d        ortussolutions/contentbox   "/bin/sh -c ${BUILD_…"   3 hours ago         Up 3 hours (unhealthy)   0.0.0.0:61651->8080/tcp, 0.0.0.0:61653->8443/tcp   cbcommerce_app_1
3af094131695        mariadb                     "docker-entrypoint.s…"   3 hours ago         Up 3 hours               0.0.0.0:3307->3306/tcp                             cbcommerce_mysql_1
```

To stop our MySQL container, for example, we would run `docker stop cbcommerce_mysql_1`, which would shutdown the container normally.  To force a container to stop we would use the `kill` directive `docker kill 3af094131695` or `docker kill cbcommerce_mysql_1`.

#### Removing old containers and restoring to a fresh state
If you need to restore your environment to a fresh state, simply stop all containers using `docker-compose stop` or `docker-compose down` and then run the command `docker system prune`, which will remove all containers, images, and volume references which are not in use.

#### SSH Access to containers

Sometimes, if configuration issues are suspected, you may need to enter a running container to look around.  There are several ways to do this:

* `docker-compose run -T [service name] bash`
* `docker-compose exec -T [ service name ] bash`
* `docker exec -it [ CONTAINER ID FROM docker ps ] bash`

For additional help information on available compose and docker commands, run `docker-compose [ COMMAND ] --help` or `docker [ COMMAND ] --help`

#### Application Stop

1. From the root of your project, run `docker-compose stop` ( or `Ctrl+C` if you did not start the processes as daemons ). You may also stop the individual containers:  `docker-compose stop weat-app`


###  Browsing the application

The pre-seeded administrative credentials for accessing the ContentBox admin and the cbCommerce store admin are:

- Username: `admin`
- Password: `c6C0mm3rc3!` ( this password is also the MySQL root password and the Lucee Administrator password )

Upon the initial database container creation, a seeder database which contains a fully configured Contentbox installation, with the cbCommerce module activated, will be up and running.  The base URLs of your your site are:

1. `http://127.0.0.1:61651/` - ContentBox site home
2. `http://127.0.0.1:61651/store` - cbCommerce store home
3. `http://127.0.0.1:61651/cbAdmin` - ContentBox Administrator home 
4. `http://127.0.0.1:61651/cbadmin/module/store/admin` - cbCommerce Store Admin within the ContentBox admin ( uses ContentBox authentication )
5. `http://127.0.0.1:61651/store/admin/app` - the standalone version of the cbCommerce admin which is framed in the ContentBox admin ( usefull for debugging and developing )

### Working with the Database server

To prevent port conflicts, the exposed port for the MySQL container is 3307.  You can use any MySQL client, such as MySQL Workbench, to make a connection to the database.  The credentials for the server are located in the `docker-compose.yml` file in the root of the site.


### Tests

The test suite for the application may be accessed at `http://127.0.0.1:61651/tests`

