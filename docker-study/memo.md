memo
===

docker-compose properties

- hostname
    + optional
    + 해당 컨테이너의 hostname을 지정. 중요! 서비스 이름은 호스트 이름과 반드시 동일해야 한다!!
    + default: container name
    + ex. hostname: HOSTNAME

- container_name
    + optional
    + 컨테이너의 이름을 지정
    + default: compose_SERVICENAME
    + ex. container_name: CONTAINERNAME

In your docker-compose file, add the `hostname` directive to your services. Most of the time your containers will get a new IP every time you restart the container, so referring to it via hostname, means it doesn't matter what IP your container is getting.