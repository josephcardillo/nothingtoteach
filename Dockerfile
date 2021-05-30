# Install the latest Debian operating system.
FROM alpine:latest as HUGO

# Install Hugo.
RUN apk update && apk add hugo

# Copy the contents of the current working directory to the
# static-site directory.
COPY . /nothing

# Command Hugo to build the static site from the source files,
# setting the destination to the public directory.
RUN hugo -v --source=/nothing --destination=/nothing/public

# Install NGINX, remove the default NGINX index.html file, and
# copy the built static site files to the NGINX html directory.
FROM nginx:stable-alpine
RUN mv /usr/share/nginx/html/index.html /usr/share/nginx/html/old-index.html
COPY --from=HUGO /nothing/public/ /usr/share/nginx/html/

# Instruct the container to listen for requests on port 80 (HTTP).
EXPOSE 80
