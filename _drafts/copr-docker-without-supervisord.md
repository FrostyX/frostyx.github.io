---
layout: post
title: Copr docker-compose without supervisord
lang: en
categories: dev copr fedora howto
---


A couple of years ago we decided to containerize our Copr development
environment, so it is easy for new contributors to set it up and get
started. Several improvements have happened since then and the original blog
post [Copr stack dockerized!][copr-stack-dockerized] isn't up-to-date
anymore. We are going to make that right.


## What changed

Just a quick side note, what happened since the original
[Copr stack dockerized!][copr-stack-dockerized] blog post:

- We don't use `supervisord` inside containers anymore. Instead, we spawn more
  containers than before, each of them running just a single process
- We don't run processes inside containers as root but as specific users instead
- Copr backend got reworked to use [resalloc][resalloc], therefore a `resalloc`
  container was added
- We try to maintain compatibility with `podman`, which might be the next step
  for our development environment


## Install

<div class="alert alert-warning" role="alert">
  There is no CI for testing Copr containers and therefore something might not
  work as expected. Please try to
  <a href="#troubleshooting">troubleshoot</a> first and eventually submit a
  new <a href="https://pagure.io/copr/copr/issues">issue</a> or
  <a href="https://pagure.io/copr/copr/pull-requests">pull-request</a>.
</div>

Getting started with Copr development should be as easy as possible. Make sure
you have Docker [properly configured][fedora-docker], and `docker-compose`
command installed. Then simply build, and run the stack. Once it's up and
running, the database needs to be initialized.

```
$ docker-compose up -d
$ docker exec -it copr_frontend_1 bash
bash-5.0$ init-database.sh
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
described in the [previous blog post][my-personal-workflow]. Here is its updated
version.

### Frontend

```
$ docker-compose -f docker-compose.yaml -f docker-compose.shell.yaml up -d frontend
$ docker exec -it copr_frontend_1 bash
PYTHONPATH=/opt/copr/frontend/coprs_frontend /opt/copr/frontend/coprs_frontend/manage.py runserver -p 5000 -h 0.0.0.0 --without-threads --no-reload
```

### Distgit

```
$ docker-compose -f docker-compose.yaml -f docker-compose.shell.yaml up -d distgit
$ docker exec -it copr_distgit_1 bash
PYTHONPATH=/opt/copr/dist-git /usr/sbin/runuser -u copr-dist-git -g copr-dist-git -- /opt/copr/dist-git/run/importer_runner.py
```

### Backend

Backend has multiple containers, so it depends on what you changed. For build dispatcher:

```
$ docker-compose -f docker-compose.yaml -f docker-compose.shell.yaml up -d backend-build
$ docker exec -it copr_backend-build_1 bash
PYTHONPATH=/opt/copr/backend /usr/sbin/runuser -u copr -g copr -- /usr/bin/copr-run-dispatcher builds
```

Actions dispatcher:

```
$ docker-compose -f docker-compose.yaml -f docker-compose.shell.yaml up -d backend-action
$ docker exec -it copr_backend-action_1 bash
PYTHONPATH=/opt/copr/backend /usr/sbin/runuser -u copr -g copr -- /usr/bin/copr-run-dispatcher actions
```

Logger:

```
$ docker-compose -f docker-compose.yaml -f docker-compose.shell.yaml up -d backend-log
$ docker exec -it copr_backend-log_1 bash
PYTHONPATH=/opt/copr/backend /usr/sbin/runuser -u copr -g copr -- /opt/copr/backend/run/copr_run_logger.py
```


### Builder

In production, we spawn a new builder instance in Amazon AWS, but this is
simplified for the local environment. Here we run a `builder` container use it
for all builds without recycling. This is the easiest way to debug the
`copr-rpmbuild` client tool.

```
$ docker exec -it copr_backend-builder-1 bash
PYTHONPATH=/opt/copr/rpmbuild/ /opt/copr/rpmbuild/main.py --chroot fedora-rawhide-x86_64 --task-url http://frontend:5000/backend/get-build-task/123-fedora-rawhide-x86_64
```


## Troubleshooting

### Permission denied for openid_store

When running `copr-frontend` from git, the `data/openid_store`
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
rm -rf /opt/copr/frontend/data/
```

### Outdated database schema

This might happen for various reasons, for example when trying to run
`copr-frontend` from git for the first time. Fix it by running
migrations from the git repository.

```
$ docker exec -it copr_frontend_1 bash
bash-5.0$ cd /opt/copr/frontend/coprs_frontend/
bash-5.0$ alembic-3 upgrade head
```

Alternativelly, for non-git `copr-frontend`, you might want to run
migrations from `/usr/share/copr/coprs_frontend/`.


### Some dependencies are not installed

When running a service from git, some dependencies might be missing. The most
comfortable way to install them is to just upgrade the relevant Copr
package. The following example is for `copr-frontend` but it can be done the
same way for every other service.

```
$ docker exec --user root -it copr_frontend_1 bash
dnf install tito
cd /opt/copr/frontend/
dnf builddep copr-frontend.spec
tito build --rpm --test --install --rpmbuild-options=--nocheck
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
