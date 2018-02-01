---
layout: post
title: Copr stack dockerized!
lang: en
categories: dev copr fedora howto
---

Lately, I decided to dockerize the whole Copr stack and utilize it for development. It is quite nifty and just ridiculously easy to use. In this article, I want to show you how to run it, describe what is inside the containers and explain my personal workflow.

There are no prerequisites required, you only need to have [properly configured](https://developer.fedoraproject.org/tools/docker/about.html) docker and `docker-compose` command installed.


### Usage

Have I already said, that it is ridiculously easy to use? Just run following command in the copr root directory.

    docker-compose up -d

It builds images for all Copr services and runs containers from them. Once it is done, you should be able to open <http://127.0.0.1:5000> and successfully build a package in it.


### How so?

There is a `docker-compose.yaml` file in the copr root directory, which describes all the Copr services and ties them together. At this point, we have a frontend, distgit, backend and database. This may change in the future by splitting the functionality across more containers.

In copr repository also lies a directory called `docker` which contains the corresponding Dockerfile for each service.

All the images are built in the same way. First, the whole copr repository is copied in. Then the `tito` is used to build an appropriate package for the service. It is installed, configured and started. The only exception here is the database, which just setups a simple PostgreSQL server.

The parent process for the services running in containers is a `supervisord` so they can be controlled via `supervisorctl` command.

In the containers is also bind mounted live version of copr repository to the `/opt/copr`.


### Cheat sheet

How can I see running containers?

    docker-compose ps

Why doesn't some container start as expected?

    docker-compose logs --follow

How can I open a shell in the container?

    docker exec -it <name> bash

How can I see running services in the container?

    supervisorctl status

How can I control services in the container?

    supervisorctl start/stop/restart all/<name>

How can I throw away a changes, that I made inside the container

    docker-compose up -d --force-recreate <service>


### My personal workflow

Are you familiar with utilizing containers for development? Just stop reading here. This section describes my personal preferences and you might not endorse them. That is fine, I am not trying to force you to do it my way. However, I think that it is a good idea to describe them, so new team members (or even the current ones) can inspire themselves. Also, if everyone described their setup, we would be clear on what we need to support.

In case that you haven't read the post about [my vagrant setup](/posts/copr-vagrant-development), you should do it. The workflow remains exactly the same, just the tools changed. Let's have a frontend as an example.

Once we have a running container for the frontend, we can open a shell in it and do

    supervisorctl stop httpd
    python3 /opt/copr/frontend/coprs_frontend/manage.py runserver -p 80 -h 0.0.0.0 --no-reload

to stop the service from a pre-installed package and run a built-in server from the live code. It allows us to try uncommitted changes (_duh_) or use tools like `ipdb`.

Alternatively, for distgit, we can use

    supervisorctl stop copr-dist-git
    PYTHONPATH=/opt/copr/dist-git /opt/copr/dist-git/run/importer_runner.py

And lastly for backend

    supervisorctl status  # To find the daemon that we want to work with
    supervisorctl stop copr-backend-action
    PYTHONPATH=/opt/copr/backend /opt/copr/backend/run/copr_run_action_dispatcher.py


### Resources
1. <https://developer.fedoraproject.org/tools/docker/about.html>
2. <https://docs.docker.com/compose/overview/>
3. <https://devcenter.heroku.com/articles/local-development-with-docker-compose>
