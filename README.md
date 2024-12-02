# GeoServer with NGINX Deployment: Infrastructure-as-Code

This repository contains an Infrastructure-as-Code (IaC) setup for deploying GeoServer with NGINX as a reverse proxy. The configuration uses Docker Compose for container orchestration.

---

## Features
- Automated deployment of GeoServer with NGINX as a reverse proxy.
- Secure and configurable setup using environment variables.
- NGINX configuration for reverse-proxying to GeoServer.
- Simple network setup with Docker bridge.

---

## Getting Started

### Prerequisites
To use this setup, ensure the following are installed on your system:
- [Docker](https://www.docker.com/get-started)
- [Docker Compose](https://docs.docker.com/compose/install/)
- Ensure that your user has been added to the docker group to run Docker commands without sudo. For guidance, refer to this [Digital Ocean Tutorial](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-20-04#step-2-executing-the-docker-command-without-sudo-optional).

### Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/geoafrikana/geoserver-nginx-deployment.git
   cd geoserver-nginx-deployment
   ```

2. **Set up environment variables**:
   Set the environment variables:
     ```bash
     export GEOSERVER_ADMIN_USERNAME=your_username
     export GEOSERVER_ADMIN_PASSWORD=your_secret_passowrd
     export DOMAIN_NAME='geoserver-site.org'
     ```
   Alternatively, you may use a `.env` file.
3. **Install snapd**:
   ```bash
   sudo apt update
   sudo apt install snapd
   ```

4. **Uninstall certbot if already present**:
   Replace apt-get with `yum` or `dnf` depending on your package manager
   ```bash
   sudo apt-get remove certbot
   ```
5. **Install Certbot with snap**:
   ```bash
   sudo snap install --classic certbot
   ```
6. **Confirm that Certbot works**:
   ```bash
   sudo ln -s /snap/bin/certbot /usr/bin/certbot
   ```
7. **Generate certificate for your domain name**:
   ```bash
   sudo certbot certonly --standalone
   ```
   Provide your email when prompted and agree to the terms. You don't have to sign-up for the newsletter though.
8. **Edit the `docker-compose.yml`**:
   Change `/etc/letsencrypt/live/geoafrikana.name.ng/` to the directory of your certbot keys


9. **Start the services**:
   ```bash
   docker-compose up -d
   ```

10. **Configure Proxy Base URL**:
   For security reasons, Geoserver must know which address its served from.
   Log in to GeoServer at http://your_domain.com:8080/geoserver. Once logged in, navigate to Settings > Global Settings and enter https://your_domain.com/geoserver/ as the Proxy Base URL.
   Ensure that your server's port 8080 is open.

11. **Confirm SSL**:
   - Open `https://your_domain.com/geoserver` 
   - Sign out if you're still signed in from he previous step.
   - Sign in to confirm your settings worked.

12. **Trigger Nginx Reload on Certbot Renewal**:
   Certbot allows us to hook into the certificate lifecycle by placing scripts in `/etc/letsencrypt/renewal-hooks/(deploy|post|pre)`.
   - Set the environment variable for the nginx container as defined in docker-compose.yml
   ```bash
   export $nginx_name=nginx_container
   ``` 
   - Copy the nginx reload script to the `post` dir:
   ```bash
   sudo cp reload-geoserver-nginx.sh /etc/letsencrypt/renewal-hooks/post/geoserver-nginx.sh
   ```
   - Reload the system daemon:
   ```bash
   sudo systemctl daemon-reload
   ```

# 🎉🎉🎉 Happy Hacking 🎉🎉🎉

### NGINX Configuration
The `nginx.conf` file contains the proxy setup for NGINX:
```nginx
...

    server_name example.com www.example.com;

...
```

- Change `example.com` and `www.example.com` to match your domain or use `localhost` during local development.
- Remove `www.example.com` if you have no CNAME in your DNS.

---

## Architecture
- **GeoServer**: Runs in a Docker container and serves geospatial data.
- **NGINX**: Acts as a reverse proxy for GeoServer, routing requests to the appropriate service.
- **Docker Bridge Network**: Ensures secure communication between containers.

---

## Troubleshooting

### Common Issues
1. **GeoServer is inaccessible**:
   - Check if the containers are running:
     ```bash
     docker ps
     ```
   - View logs for GeoServer:
     ```bash
     docker-compose logs geoserver
     ```

2. **NGINX errors**:
   - Validate the `nginx.conf` file:
     ```bash
     nginx -t
     ```
   - Check NGINX logs:
     ```bash
     docker-compose logs nginx
     ```

---

## Contributing
Contributions are welcome! To contribute:
1. Fork the repository.
2. Create a new branch:
   ```bash
   git checkout -b feature-branch
   ```
3. Commit your changes and submit a pull request.

---

## License
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

## Credits
- [Kartoza](https://kartoza.com/) for the GeoServer Docker image.
- [NGINX](https://www.nginx.com/) for the web server.

