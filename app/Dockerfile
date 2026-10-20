# Pinned base image (never :latest)
FROM nginx:1.27-alpine

# Build identifier, surfaced in index.html and the X-Build-SHA response header
ARG BUILD_SHA=dev

COPY nginx.conf /etc/nginx/nginx.conf
COPY index.html /usr/share/nginx/html/index.html

# Inject the build SHA (runs as root, before dropping privileges)
RUN sed -i "s/__BUILD_SHA__/${BUILD_SHA}/g" /etc/nginx/nginx.conf /usr/share/nginx/html/index.html

# Run as the unprivileged user that ships with the official image
USER nginx

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget -qO- http://127.0.0.1:8080/healthz || exit 1
