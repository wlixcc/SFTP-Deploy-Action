# Container image that runs your code
FROM alpine:3.13

# Copies your code file from your action repository to the filesystem path `/` of the container
COPY entrypoint.sh /entrypoint.sh

#Make sure to make you entrypoint.sh file executable:
RUN chmod +x entrypoint.sh

RUN apk update
RUN apk add --no-cache sshpass openssh-client

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["/entrypoint.sh"]
