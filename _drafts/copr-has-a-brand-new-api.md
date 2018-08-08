---
layout: post
title: Copr has a brand new API
lang: en
categories: dev copr fedora api
---

New Copr version is here and after several months of discussions and development, it finally brings a brand new API. In this article, we are going to see why it was needed, how it is better than previous API versions (i.e. why you should be happy about it) and try some code samples.


## Status quo
Currently, Copr provides two separate API interfaces. The python client for the oldest one, [version 1 (aka Legacy API)](http://python-copr.readthedocs.io/en/latest/ClientV1.html), was supposed to be a tiny wrapper around API methods. As the functionality grew up, this implementation became harder and harder to maintain. That is why we introduced a [second API version](http://python-copr.readthedocs.io/en/latest/ClientV2.html) with a REST-like architecture. The legacy API became obsolete and it was going to be removed in the future. However, we decided to support both of them and add new features even to the older one, in order to not force our users to migrate immediately, but rather when it is more convenient to them.

Unfortunately, we weren't consistent enough and from time to time it happened that something was implemented into one API version, but not into the other and otherwise. It resulted into a state where both versions provide but also lacks certain functionality. None of them is complete. Ironically enough, the obsolete, so-called Legacy API provides more features than its intended successor and therefore it was recommended over it.

<center>
    <a href="https://xkcd.com/927/" title="Not this time!"><img src="/files/img/xkcd-standards.png" alt="Not this time!" /></a>
    <p>Not this time!</p>
</center>


## Motivation
Several ways how to deal with this situation come to mind. The most obvious one is implementing missing pieces to the REST-like APIv2 and finally shut down the obsolete version. It wasn't that simple though. The reason why we occasionally forgot to add things into the APIv2 is that it is a painful experience due to its unnecessary complexity and over-engineering. We realized, that we like the first version better. Then what about un-obsoleting it and terminating the second version? Well, the APIv2 wasn't created just for fun, but because APIv1 has some limitations, which are still there. Mainly, the problem lies in inconsistencies. It uses JSON for GET requests, but plain HTML forms for POSTs, which causes several problems with data types (e.g. using `"y"` instead of `True`, strings with space separator instead of lists, etc). There are also inconsistently named methods and attributes and other issues that wouldn't be possible to properly fix without breaking the backward compatibility.

Certainly, it was possible to just address the individual issues in the APIv1 and gradually move to the desired solution, but it would force our users to rewrite their code over and over again because every Copr release would deprecate something in the API. Therefore, at some point, a third API version needed to rise.


## Goals
Even though, that with an empty canvas there were a countless of possibilities, we didn't want to implement any revolutionary ideas. The Legacy API is here for years, people seem to like it, we like using it in the [copr-cli](https://developer.fedoraproject.org/deployment/copr/copr-cli.html) and we are well aware of mistakes that were made in it. Therefore we wanted to take everything that is great about the Legacy API and do things that don't work well, differently.

<center>
    <img src="/files/img/json-everywhere.png" alt="JSON, JSON everywhere" />
</center>
<br>

Goals for the new API was:

- Unify the data format. For obvious reasons, JSON was the chosen one. This allows to easily deal with the data type issues described above.
- Unify the method names (e.g. `edit` vs `modify`) and parameter names (e.g. `ownername` vs `owner` vs `username`)
- Have a sane file and code structure. Basically, the whole Legacy API is in the `api_general.py` file (~1000 lines of code) and the whole client side is in the `client.py` file (~1600 lines of code). Both of these are not structured what so ever (one class/file with a lot of methods for everything)
- Handling a big data reasonably. There are huge projects in the main [Copr](https://copr.fedorainfracloud.org/) instance, such as [@copr/PyPI3](https://copr.fedorainfracloud.org/coprs/g/copr/PyPI3/) with ~70k builds and [@rubygems/rubygems](https://copr.fedorainfracloud.org/coprs/g/rubygems/rubygems/) with ~130k builds, etc. We need a tool, that is capable to work with them with ease. No timeouts, no enormous memory requirements.


## Show me the code
Let's quickly look on some code example.

<pre class="prettyprint">
from copr.v3 import Client

# Create an API client from config file
# By default it reads ~/.config/copr
client = Client.create_from_config_file()

# Create a new project
chroots = ["fedora-rawhide-x86_64", "fedora-rawhide-i386"]
project = client.project_proxy.add("@copr", "foo", chroots, description="My example project")

# Submit a new build
url = "http://foo.ex/bar.src.rpm"
build = client.build_proxy.create_from_url(project.ownername, project.name, url)
print(build.id)
</pre>

A configuration is needed in order to be supplied to the client. It can be read from a config file or defined as a `dict` in the code. The `client` object can be used to simplify the work with the API, but [it is not required](http://python-copr.readthedocs.io/en/latest/client_v3/working_with_proxies_directly.html). The functionality is separated among multiple proxy objects and their methods return data stored in [munches](https://github.com/Infinidat/munch) which are basically dicts with object-like access to properties.


## Read further
If you are interested in more code samples and details, there is a nice [documentation](http://python-copr.readthedocs.io/en/latest/ClientV3.html). You can see how the [client can be initialized](http://python-copr.readthedocs.io/en/latest/client_v3/client_initialization.html), how the [data structures](http://python-copr.readthedocs.io/en/latest/client_v3/data_structures.html) look, how to [handle errors](http://python-copr.readthedocs.io/en/latest/client_v3/error_handling.html), how the [pagination](http://python-copr.readthedocs.io/en/latest/client_v3/pagination.html) works, what [proxy methods](http://python-copr.readthedocs.io/en/latest/client_v3/proxies.html) are available and many more. Also, please stay tuned for upcoming blog posts about the API. Next one will describe the migration process from older versions.
