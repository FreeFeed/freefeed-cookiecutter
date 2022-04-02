# Getting your own instance of FreeFeed

This repository provides a simple way to spin up your own FreeFeed instance on DigitalOcean. If you prefer or otherwise have to use another hosting provider, you might need to do some minor modifications in the config, and some manual steps might be different.

## Prerequisites

### Spin up a server

Create a user account on [DigitalOcean](https://www.digitalocean.com/), and create a [Debian 11 droplet](https://cloud.digitalocean.com/droplets). It's important to select Debian OS, and the 11 version of it.

As for the droplet size, we recommend to start with the second cheapest, which as of April 2022 costs $12/month.

We also recommend to enable backups.

### Get a domain name

Which registrar to use for domain name is not important, pick whatever works best for you. Here is links to documentation on how to create an A record pointing to the server IP address on some of the popular ones:

- [Gandi.net](https://docs.gandi.net/en/domain_names/common_operations/link_domain_to_website.html)
- [Name.com](https://www.name.com/support/articles/115004893508-adding-an-a-record)
- [Namecheap](https://www.namecheap.com/support/knowledgebase/article.aspx/434/2237/how-do-i-set-up-host-records-for-a-domain/)

## Server setup

### SSH to server and create additional user account

    $ ssh root@<your new server ip>
    useradd -G sudo -m freefeed
    cp -r .ssh /home/freefeed/
    passwd freefeed # make some password
    
Now you can logout and ssh again as `freefeed`

    exit
    $ ssh freefeed@<your new server ip>

### Install docker
    
    sudo apt-get update
    sudo apt-get install snapd ca-certificates curl gnupg lsb-release
    curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update
    sudo apt-get install docker-ce docker-ce-cli containerd.io python3-pip
    sudo pip3 install docker-compose
    sudo usermod -a -G docker freefeed
    exit
    $ ssh freefeed@<your new server ip>

### Install certbot

    sudo apt update
    sudo apt install snapd
    sudo snap install core && sudo snap refresh core
    sudo snap install --classic certbot
    sudo ln -s /snap/bin/certbot /usr/bin/certbot
    
### Obtain a certiicate

Certbot will ask a few questions in the process. You need to have your domain already by now.

    sudo certbot certonly --standalone
    sudo chmod -R 755 /etc/letsencrypt/live/
    sudo chmod -R 755 /etc/letsencrypt/archive/

### Create a directory for attachments and profile images

    sudo mkdir -p /var/freefeed-files/attachments/thumbnails
    sudo mkdir -p /var/freefeed-files/attachments/thumbnails2
    sudo chown -R freefeed:freefeed /var/freefeed-files

### Configure and run

    pip3 install cookiecutter
    cookiecutter https://github.com/id/freefeed-cookiecutter # answer questions to setup your own config
    cd <your site url>
    docker network create freefeed
    docker-compose build
    docker-compose up -d
    docker-compose logs -f
    
Wait for the `Server is running in production mode` message from the server container, and type your site url in the browser!
