---
layout: post
title: Copr - Vagrant development
lang: en
categories: dev copr fedora howto
---

This article explains my local setup and personal workflow for developing [Copr](http://copr.fedoraproject.org/). This doesn't neccessary mean that it is the best way how to do it, but it is the way that suits best to my personal preferences. Other team members probably approach this differently.


## Theory
Developing in vagrant has lot of advantages, but it also brings us few unpleasant things. You can basically set up your whole environment just by running `vagrant up` which allows you to test your code in production-like machine. This is absolutely awesome. The bad thing (while developping) is that on such machine you can't do things like "I am gonna change this line and see what happens" or interactive debugging via [ipdb](https://pypi.python.org/pypi/ipdb).

Actually what you have to do is commiting the change first, building package from your commit, installing it and then restarting your server. Or if you are lazy, commiting change and reloading the whole virtual machine. However it doesnt matter, it will be slow and painfull either way. In this article I am going to explain how you can benefit from Vagrant features, but still develop comfortably and "interactively".


## Prerequisites

<pre class="prettyprint">
# You should definitely not turn off your firewall
# I am lazy to configure it though
$ sudo systemctl stop firewalld
$ sudo dnf install vagrant
</pre>


## Example workflow

Lets imagine that we want to make some change in frontend code. First of all we have to setup and start our dev environment. Following command will run virtual machines with frontend and distgit.

	$ vagrant up

Then we will connect to machine, that we want to modify - in this case frontend.

	$ vagrant ssh frontend

Now, as it is described in [frontend section](#Frontend), we will stop production server and run development one from `/vagrant` folder which is synchronized with our host machine. It means, that every change from your IDE is immediately projected to your web server. For instance, try to put `import ipdb; ipdb.set_trace()` somewhere to the code and reload copr-frontend in the browser. You can see the debugger in your terminal.

	ipdb>

Similarly you can use such workflow for distgit.


<div id="Frontend"></div>

## Frontend

<pre class="prettyprint">
# [frontend]
sudo systemctl stop httpd
sudo python /vagrant/frontend/coprs_frontend/manage.py runserver -p 80 -h 0.0.0.0
</pre>


## Dist-git

<pre class="prettyprint">
# [dist-git]
sudo systemctl stop copr-dist-git
sudo su copr-service
cd
PYTHONPATH=/vagrant/dist-git /vagrant/dist-git/run/importer_runner.py
</pre>


## Backend

There is no vagrant support for backend. We rather use [docker image](#) for it. Let's leave this topic for another post.


## Follow up

I've been using this setup for over a year now and it served me quite well. Right until I wanted to run several machines at once, IDE and browser on a laptop with limited RAM capacity. That is one of the reasons why I decided to dockerize the whole Copr stack and move away from Vagrant. See my current workflow in a newer post - [The whole Copr stack dockerized!](#)
