# Use an official Nginx base image
FROM nginx:latest

# Install necessary build tools
RUN apt-get update && apt-get install -y \
    build-essential \
    make \ 
    pandoc \
    && rm -rf /var/lib/apt/lists/*

# Copy the Nginx configuration file
COPY nginx.conf /etc/nginx/nginx.conf

# Copy the makefile and source files to the container
COPY . /usr/src/app

# Set the working directory
WORKDIR /usr/src/app

# Run make to build the site
RUN make

# Copy the built site to the Nginx HTML directory
RUN cp -r site /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
