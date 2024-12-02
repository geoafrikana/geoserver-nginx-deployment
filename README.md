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
- Remember to add your user to the `docker` group. This [Digital Ocean Tutorial](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-20-04#step-2-executing-the-docker-command-without-sudo-optional) will help

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
   Pri=ovide your email when prompted and agree to the terms. You don't have to sign-up for the newsletter though.
   ```bash
   sudo certbot certonly --standalone
   ```



3. **Start the services**:
   ```bash
   docker-compose up -d
   ```

4. **Access GeoServer**:
   - Open your browser and go to `http://localhost/geoserver`.
   - Log in using the credentials defined in your `.env` file.

---

## Configuration

### Environment Variables
The `.env` file allows you to configure the deployment:
- `GEOSERVER_ADMIN_USERNAME`: Admin username for GeoServer.
- `GEOSERVER_ADMIN_PASSWORD`: Admin password for GeoServer.

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

