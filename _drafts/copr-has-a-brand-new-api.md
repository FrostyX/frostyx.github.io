---
layout: post
title: Copr has a brand new API
lang: en
categories: dev copr fedora
---

New Copr version is here and after several months of disscussions and development, it finally brings a brand new API. In this article we are going to see why it was needed, how it is better than previous API versions (i.e. why you should be happy about it) and try some code samples.


@TODO https://xkcd.com/927/


## Status quo
Currently, Copr provides two separate API interfaces. The python client for the oldest one, version 1 (aka Legacy API), was supposed to be a tiny wrapper around API methods. As the functionality grew up, this implementation become harder and harder to maintain. That is why we introduced a second API version in a REST-like manner. The legacy API become obsolete and it was going to be removed in the future. However, we decided to support both of them and add new features even to the older one, in order to not force our users to migrate immediatelly, but rather when it is more convinient to them.

Unfortunatelly, we werent consistent enough and from time to time it happened that something was implemented into one API version, but not into the other one and otherwise. It resulted into a state where both versions provides but also lacks certain functionality. None of them is complete. ironically enough, the obsolete, so called Legacy API provides more features than its intended successor and therefore it was recommended over it.


## Motivation
Several ways how to deal with this situation come to mind. The most obvious one is implementing missing pieces to the REST-like APIv2 and finally shut down the obsolete one. It wasn't that simple though. The reason, why occasionally forgot to add things into the APIv2 is because it is painfull due to its unnecessary complexity and over-engineering. We realized, that we like the first version better. Then what about un-obsoleting it and terminating the second version? Well, the APIv2 wasn't created just for the fun, but because APIv1 has some limitations, which are still there. Mainly, the problem lies inconsistencies. It uses JSON for GET requests, but plain html forms for POSTs, which caused into several problems with data types (e.g. using `"y"` instead of `True`, strings with space separator instead of lists). There were also inconsistently named methods and attributes.

We didn't want to settle down with the current solutions, so at some point, a third API version needed to rise. Certainly, it was possible to just addressing the individual issues in the APIv1 and gradually moving to the desired solution, but it would force our users to rewrite their code over and over again, because every Copr release would deprecate something in the API.


## Goals
Even though, that with an empty canvas there were a countless of possibilities, we didn't want to implement any revolutionary ideas. The Legacy API is here for years, people seem to like it, we like using it in the [copr-cli](#) and we are well aware of mistakes that were made in it. Therefore we wanted to take everything, that is great in the Legacy API and do the things that doesn't work well, differently.

@TODO json, json everywhere meme?

Goals for the new API was:

- Unify the data format. For obvious reasons, JSON was the chosen one. This will allow to easily deal with the data type issues described above.
- Unify the method names (e.g. `edit` vs `modify`) and parameter names (e.g. `ownername` vs `owner` vs `username`)
- Have a sane file and code structure. Basically the whole Legacy API is in the `api_general.py` file (~1000 lines of code) and the whole client side is in the `client.py` file (~1600 lines of code). Both of these are not structured what so ever (one class/file with a lot of methods for everything)
- Handling a big data reasonably. There are huge projects in the main [Copr](#) instance, such as [@foo/PyPI](#) with X buidls and [@foo/rubygems](#) with X builds, etc. We need a tool, that is able to work with them with ease. No timeouts, no enormous memory requirements.


## Show me the code

<pre class="prettyprint">
from copr.v3 import Client

# Create an API client from config file
client = Client.create_from_config_file()

# Create a new project
chroots = ["fedora-rawhide-x86_64", "fedora-rawhide-i386"]
client.project_proxy.add("@copr", "foo", chroots, description="Some desc")

# Build a package
url = "http://foo.ex/bar.src.rpm"
build = client.build_proxy.create_from_url("@copr", "foo", url)
print(build.id)
</pre>
