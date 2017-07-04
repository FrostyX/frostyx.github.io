---
layout: post
title: Copr - Vagrant development
lang: en
categories: dev copr fedora howto
---

This article explains my local environment and personal workflow for developing [Copr](#). This doesn't neccessary mean that it is the best way how to do it, but it is the way that suits best to my personal preferences.


## Theory
Developing in vagrant has lot of advantages, but it also brings us very few unpleasant things. You can basically set up your whole environment just by running `vagrant up` which allows you to test your code in production-like machine. This is absolutely awesome. The bad thing is that on production machine you can't do things like "I am gonna change this line and see what happens" or interactive debugging via [ipdb](https://pypi.python.org/pypi/ipdb).

Actually what you have to do is commiting the change first, building package from your commit, installing it and then restarting your server. Or if you are lazy, commiting change and reloading the whole virtual machine. However it doesnt matter, it will be slow and painfull either way. In this article I am going to explain how you can benefit from Vagrant features, but still develop comfortably and "interactively".


## Prerequisites

	$ sudo systemctl stop firewalld
	$ sudo dnf install vagrant


## Example workflow

Lets imagine that we want to make some change in frontend code. First of all we have to setup and start our dev environment. Following command will run virtual machines with frontend, distgit and backend.

	$ vagrant up

Then we will connect to machine, that we want to modify - in this case frontend.

	$ vagrant ssh frontend

Now, as it is described in [frontend section](#Frontend), we will stop production server and run development one from `/vagrant` folder which is synchronized with our host machine. It means, that every change from your IDE is immediately projected to your web server. For instance, try to put `import ipdb; ipdb.set_trace()` somewhere to the code and reload copr-frontend in the browser. You can see the debugger in your terminal.

	ipdb>

Similarly you can use such workflow for distgit and backend.


<div id="Frontend"></div>

## Frontend

	# [frontend]
	sudo systemctl stop httpd
	sudo python /vagrant/frontend/coprs_frontend/manage.py runserver -p 80 -h 0.0.0.0


## Dist-git

	# [dist-git]
	sudo systemctl stop copr-dist-git
	sudo su copr-service
	cd
	PYTHONPATH=/vagrant/dist-git /vagrant/dist-git/run/importer_runner.py


## Backend

	# [backend]
	sudo supervisorctl stop copr-backend
	sudo PYTHONPATH=/vagrant/backend /usr/bin/copr_be.py -u root -g root
	sudo PYTHONPATH=/vagrant/backend /usr/bin/copr_run_job_grab.py
	sudo PYTHONPATH=/vagrant/backend /usr/bin/copr_run_vmm.py
	sudo PYTHONPATH=/vagrant/backend /usr/bin/copr_run_logger.py


Most comfortable way is to create grid of 4 panes in [tmux](#) and run and run all the commands in it.

	#!/bin/bash
	tmux new-session -ds copr 'exec sudo PYTHONPATH=/vagrant/backend /usr/bin/copr_be.py -u root -g root'
	tmux select-window -t copr:0
	tmux split-window -h 'exec sudo PYTHONPATH=/vagrant/backend /usr/bin/copr_run_job_grab.py'
	tmux split-window -v -t 0 'exec sudo PYTHONPATH=/vagrant/backend /usr/bin/copr_run_vmm.py'
	tmux split-window -v -t 1 'exec sudo PYTHONPATH=/vagrant/backend /usr/bin/copr_run_logger.py'
	tmux -2 attach-session -t copr
