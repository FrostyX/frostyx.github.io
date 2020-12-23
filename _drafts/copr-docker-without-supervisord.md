---
layout: post
title: Copr docker-compose without supervisord
lang: en
categories: dev copr fedora howto
---

http://frostyx.cz/posts/copr-stack-dockerized
https://pagure.io/copr/copr/pull-request/1214


## Install

```
$ docker-compose up -d
$ docker exec --user root -it copr_frontend_1 bash
bash-5.0$ init-database.sh
```


## Cheat sheet

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


TODO services are not here anymore


How can I see running services in the container?

supervisorctl status
How can I control services in the container?

supervisorctl start/stop/restart all/<name>





How can I throw away a changes, that I made inside the container

    docker-compose up -d --force-recreate <service>

How can I drop the whole docker-compose environment

    docker-compose down --rmi 'all'



## Running services from git

### Frontend

```
$ docker-compose -f docker-compose.yaml -f docker-compose.shell.yaml up -d frontend
$ docker exec -it copr_frontend_1 bash
PYTHONPATH=/opt/copr/frontend/coprs_frontend /opt/copr/frontend/coprs_frontend/manage.py runserver -p 5000 -h 0.0.0.0 --without-threads --no-reload
```

### Distgit

TODO distgit

### Backend

TODO build

```
$ docker-compose -f docker-compose.yaml -f docker-compose.shell.yaml up -d backend-build
$ docker exec -it copr_backend-build_1 bash
PYTHONPATH=/opt/copr/backend /usr/sbin/runuser -u copr -g copr -- /usr/bin/copr-run-dispatcher builds
```

TODO action

```
$ docker-compose -f docker-compose.yaml -f docker-compose.shell.yaml up -d backend-action
$ docker exec -it copr_backend-action_1 bash
PYTHONPATH=/opt/copr/backend /usr/sbin/runuser -u copr -g copr -- /usr/bin/copr-run-dispatcher actions
```

TODO log

```
$ docker-compose -f docker-compose.yaml -f docker-compose.shell.yaml up -d backend-log
$ docker exec -it copr_backend-log_1 bash
PYTHONPATH=/opt/copr/backend /usr/sbin/runuser -u copr -g copr -- /opt/copr/backend/run/copr_run_logger.py
```


### Builder

TODO builder

```
$ docker exec -it copr_backend-builder-1 bash
TODO
```


## Troubleshooting

### Permission denied for openid_store

When running `copr-frontend` from git, the `data/openid_store`
contains files that were created within the frontend container. The
problem is accessing them from the host system or from a new container
when the old one is dropped. Those doesn't have the user and group
available.

```
PermissionError: [Errno 13] Permission denied: "/opt/copr/frontend/data/openid_store/associations/https-id.fedoraproject.org-b'ahW3p5yqmHART1i9_lWSDz825NY'-b'VOcKQaT5MFkyT4oYgexUGGSA8zI'"
```

It is safe to simply drop all generated data

```
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
