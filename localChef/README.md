# Docker Container for local chefDK Server

## chefdk image build
move into localChef dir
run the command to build a docker image
> docker build -t chefdk .

## run container with the chefdk image that you have made.
> docker run -it -u root -v /home/daehyeop_ko/cookbooks:/cookbooks -v //var/run/docker.sock:/var/run/docker.sock chefdk