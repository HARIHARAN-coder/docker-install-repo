# Use official Nginx base image
FROM nginx:latest

# Set working directory inside the container
WORKDIR /usr/share/nginx/html

# Remove default nginx index page
RUN rm -rf ./*

# Copy your HTML file(s) into the container
COPY index.html ./
# If you have images, css, js – copy them too
# COPY assets/ ./assets/

# Expose port 9009
EXPOSE 9009

# Replace default nginx.conf to use port 9009
RUN sed -i 's/listen       80;/listen 9009;/g' /etc/nginx/conf.d/default.conf

# Start nginx in foreground
CMD ["nginx", "-g", "daemon off;"]

