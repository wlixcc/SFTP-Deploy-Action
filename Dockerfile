# Use an up-to-date and secure Alpine version
FROM alpine:3.18

# Install required packages in one RUN statement to reduce image layers
RUN apk update && apk add --no-cache rsync sshpass openssh expect

# Copy entrypoint script and set correct permissions
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set the entrypoint for the container
ENTRYPOINT ["/bin/sh", "/entrypoint.sh"]