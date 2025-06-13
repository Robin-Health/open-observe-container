FROM debian:bullseye-slim

# Install dependencies
RUN apt-get update && apt-get install -y \
    ca-certificates \
    curl \
    nginx \ 
    jq \
    && rm -rf /var/lib/apt/lists/*

# Set the OpenObserve version
ENV OO_VERSION=v0.10.9-rc3

# Install AWS CLI v2
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && ./aws/install \
    && rm -rf awscliv2.zip aws

# Download and install OpenObserve
RUN curl -L https://github.com/openobserve/openobserve/releases/download/${OO_VERSION}/openobserve-${OO_VERSION}-linux-amd64.tar.gz | tar xvz -C /usr/local/bin

# Make sure the binary is executable
RUN chmod +x /usr/local/bin/openobserve

# Copy the entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Copy Nginx configuration
COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 5080 5081 8080

# Set the entrypoint
ENTRYPOINT ["/entrypoint.sh"]


