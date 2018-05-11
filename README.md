## Installing a new PHP extension

Adding a new php extension can be accomplished by creating a shell script to run an installation commands
on docker container itself. An example has been created to install php-mcrypt extension in which the file is 
called "php_ext_installer.sh"

Below are the step to run the shell script:

1. copy the shell script into the docker container where PHP installation exist.

eg. docker cp </path/to/host/shell_script.sh> <php container name>:</path/within/docker/container>

2. run docker exec command to execute the shell script.

eg. docker exec <php container name> /bin/sh -c "cd </path/where/shell_script/exist> && sh <shell script name>.sh"

3. restart php docker container

## NOTE

if you create your shell script on Windows then make sure that your .sh file has the correct carriage return for that of UNIX. by default, carriage return in files saved via Windows will be saved as \r\n which would cause issues when the .sh file is run on UNIX environment (which docker is based at). In sublime 3, you can change its settings to save file using UNIX encoded carriage return simply by going to View > Line Endings menu and tick the Unix option