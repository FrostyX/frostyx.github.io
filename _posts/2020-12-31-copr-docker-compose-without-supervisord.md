---
layout: post
title: Copr docker-compose without supervisord
lang: en
tags: dev copr fedora howto
updated: 2022-07-21
---


A couple of years ago we decided to containerize our Copr development
environment to make the onboarding of new contributors easier, and to have a
unified development environment for all of our team members. Several
improvements have happened since then and the original blog post
[Copr stack dockerized!][copr-stack-dockerized] isn't up-to-date anymore. We are
going to make that right.

## TL;DR

- [Frontend](#frontend)
- [DistGit](#distgit)
- [Backend](#backend)
- [Keygen](#keygen)
- [Builder](#builder)
- [Database](#database)
- [CLI](#cli)


## What changed

Just a quick side note about what happened since the original
[Copr stack dockerized!][copr-stack-dockerized] blog post:

- We don't use `supervisord` inside the containers anymore. Instead, we spawn
  more containers than before, each of them running just a single process
- Within containers, we don't run processes as root anymore but use specific
  users instead
- Copr backend got reworked to use [resalloc][resalloc], therefore a `resalloc`
  container was added
- We try to maintain compatibility with `podman`, which might be the next step
  for our development environment


## Install

<div class="alert alert-warning" role="alert">
  There is no CI for testing Copr containers and therefore something might not
  work as expected. Please try to
  <a href="#troubleshooting">troubleshoot</a> first, and eventually submit a
  new <a href="https://pagure.io/copr/copr/issues">issue</a> or
  <a href="https://pagure.io/copr/copr/pull-requests">pull-request</a>.
</div>

Getting started with Copr development should be as easy as possible. Make sure
you have Docker [properly configured][fedora-docker], and `docker-compose`
command installed. Then simply build, and run the stack. Once it's up and
running, the database needs to be initialized.

```
$ git clone https://pagure.io/copr/copr.git
$ cd copr
$ docker-compose up -d
$ docker exec -it copr_frontend_1 bash
[copr-fe@frontend /]$ init-database.sh
```

At this moment, you should be able to open <http://127.0.0.1:5000/> in a web
browser, log-in, create a project, and successfully build a package.


## Cheatsheet

How can I start everything?

```
docker-compose up -d
```

How can I see running containers?

```
docker-compose ps
```

Why doesn’t some container start as expected?

```
docker-compose logs --follow
```

How can I open a shell in the container?

```
docker exec -it <name> bash
```

How can I open a root shell in the container?

```
docker exec --user root -it <name> bash
```

How can I throw away all changes, that I made inside the container?

```
docker-compose up -d --force-recreate <service>
```

How can I drop a container and image for one service?

```
dco rm --stop <name> && docker rmi copr_<name>
```

How can I drop the whole docker-compose environment?

```
docker-compose down --rmi 'all'
```


## Running services from git

Probably everyone has his own preferred way of testing changes. My workflow is
described in the [previous blog post][my-personal-workflow]. Here we can see its
updated version.


### Frontend

```
$ docker-compose -f docker-compose.yaml -f docker-compose.shell.yaml up -d frontend
$ docker exec -it copr_frontend_1 bash
[copr-fe@frontend /]$ PYTHONPATH=/opt/copr/frontend/coprs_frontend /opt/copr/frontend/coprs_frontend/manage.py runserver -p 5000 -h 0.0.0.0 --without-threads --no-reload
```

### Distgit

```
$ docker-compose -f docker-compose.yaml -f docker-compose.shell.yaml up -d distgit
$ docker exec -it copr_distgit_1 bash
[root@distgit /]# PYTHONPATH=/opt/copr/dist-git /usr/sbin/runuser -u copr-dist-git -g copr-dist-git -- /opt/copr/dist-git/run/importer_runner.py
```

### Backend

#### Services

Backend has multiple containers, so it depends on what you changed. For build dispatcher:

```
$ docker-compose -f docker-compose.yaml -f docker-compose.shell.yaml up -d backend-build
$ docker exec -it copr_backend-build_1 bash
[root@backend /] # PYTHONPATH=/opt/copr/backend /usr/sbin/runuser -u copr -g obsrun -- /usr/bin/copr-run-dispatcher builds
```

Actions dispatcher:

```
$ docker-compose -f docker-compose.yaml -f docker-compose.shell.yaml up -d backend-action
$ docker exec -it copr_backend-action_1 bash
[root@backend /] # PYTHONPATH=/opt/copr/backend /usr/sbin/runuser -u copr -g copr -- /usr/bin/copr-run-dispatcher actions
```

Logger:

```
$ docker-compose -f docker-compose.yaml -f docker-compose.shell.yaml up -d backend-log
$ docker exec -it copr_backend-log_1 bash
[root@backend /] # PYTHONPATH=/opt/copr/backend /usr/sbin/runuser -u copr -g copr -- /opt/copr/backend/run/copr_run_logger.py
```

#### Commands

The `copr-run-dispatcher` is a multi-thread process and therefore it might not
alway be that easy to debug. Using `ipdb` might not always be possible.

To perform a single build:

```
PYTHONPATH=/opt/copr/backend /usr/sbin/runuser -u copr -g obsrun -- /opt/copr/backend/run/copr-backend-process-build --build-id 37 --chroot fedora-33-x86_64
```

To perform a single action:

```
PYTHONPATH=/opt/copr/backend /usr/sbin/runuser -u copr -g copr -- /opt/copr/backend/run/copr-backend-process-action --task-id 331002
```

To perform a single createrepo command:

```
PYTHONPATH=/opt/copr/backend /usr/sbin/runuser -u copr -g copr -- copr-repo /var/lib/copr/public_html/results/@copr/copr/fedora-rawhide-x86_64/
```

### Keygen

```
$ docker-compose -f docker-compose.yaml -f docker-compose.shell.yaml up -d keygen-httpd
$ docker exec -it copr_keygen-httpd_1 bash
[root@keygen-httpd ~]# cd /opt/copr/keygen/src
[root@keygen-httpd src]# FLASK_APP=copr_keygen flask run --host 0.0.0.0 --port 5003
```

### Builder

In production, we spawn new builder instances in Amazon AWS, but this is
simplified for the development environment. Locally, we run a `builder`
container and use it for all builds without recycling. This is the easiest way
to debug the `copr-rpmbuild` client tool.

```
$ docker exec -it copr_builder_1 bash
[root@builder /]# PYTHONPATH=/opt/copr/rpmbuild/ /opt/copr/rpmbuild/main.py --chroot fedora-rawhide-x86_64 --task-url http://frontend:5000/backend/get-build-task/123-fedora-rawhide-x86_64
```

### Database

```
$ docker exec -it copr_database_1 bash
bash-4.2$ psql coprdb
```

### CLI

For testing the git version of `copr-cli` tool with git version of
`python3-copr` package, we can use the following command.

```
$ cd cli
$ PYTHONPATH=$HOME/git/copr/python ./copr --help
```


## Troubleshooting

### Permission denied for openid_store

When running `copr-frontend` from git, the `data/openid_store` directory
contains files that were created within the frontend container. The
problem is accessing them from the host system or a new container
when the old one is dropped. Those don't have the user and group
available.

```
PermissionError: [Errno 13] Permission denied: "/opt/copr/frontend/data/openid_store/associations/https-id.fedoraproject.org-b'ahW3p5yqmHART1i9_lWSDz825NY'-b'VOcKQaT5MFkyT4oYgexUGGSA8zI'"
```

It is safe to simply drop all generated data

```
$ docker exec --user root -it copr_frontend_1 bash
[copr-fe@frontend /]$ rm -rf /opt/copr/frontend/data/
```

### Outdated database schema

This might happen for various reasons, for example when trying to run
`copr-frontend` from git for the first time. Fix it by running
migrations from the git repository.

```
$ docker exec -it copr_frontend_1 bash
[copr-fe@frontend /]$ cd /opt/copr/frontend/coprs_frontend/
[copr-fe@frontend coprs_frontend]$ alembic-3 upgrade head
```

Alternatively, for non-git `copr-frontend`, you might want to run
migrations from `/usr/share/copr/coprs_frontend/`.


### Some dependencies are not installed

When running a service from git, some dependencies might be missing. The most
comfortable way to install them is to upgrade the relevant Copr package. The
following example is for `copr-frontend` but it can be done the
same way for every other service.

```
$ docker exec --user root -it copr_frontend_1 bash
[copr-fe@frontend /]$ dnf install tito
[copr-fe@frontend frontend]$ cd /opt/copr/frontend/
[copr-fe@frontend frontend]$ dnf builddep copr-frontend.spec
[copr-fe@frontend frontend]$ tito build --rpm --test --install --rpmbuild-options=--nocheck
```

However, it is always possible that some dependency is not properly set in the
specfile. In that case please submit a new [issue][copr-issues] or a
[pull-request][copr-prs].



[copr-stack-dockerized]: http://frostyx.cz/posts/copr-stack-dockerized
[pr-1214]: https://pagure.io/copr/copr/pull-request/1214
[resalloc]: https://github.com/praiskup/resalloc
[fedora-docker]: https://developer.fedoraproject.org/tools/docker/about.html
[copr-issues]: https://pagure.io/copr/copr/issues
[copr-prs]: https://pagure.io/copr/copr/pull-requests
[my-personal-workflow]: http://frostyx.cz/posts/copr-stack-dockerized#my-personal-workflow
