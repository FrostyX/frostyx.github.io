---
layout: post
title: Copr &lt;3 Modularity
lang: en
categories: dev copr fedora
---


[Modularity](https://fedoraproject.org/wiki/Modularity) is an exciting, new initiative aimed at resolving the issue of diverging lifecycles of different "components" within Fedora.


## Modularity in Copr

In last releases we introduced a lot of interesting things regarding modularity. You can now submit existing modulemd to be build or alternatively generate modulemd in your browser through few easy steps. We also made an initial UI concept for viewing modules.


### Web UI

<div class="row">
	<div class="col-lg-6">
		<a href="/files/img/module-create-full.png">
			<img src="/files/img/module-create-thumb.png">
		</a>
	</div>
	<div class="col-lg-6">
		<a href="/files/img/module-detail-full.png">
			<img src="/files/img/module-detail-thumb.png" class="pull-right">
		</a>
	</div>
</div>


### API

To build existing modulemd please send a `POST` request to Copr API.

	POST /api/coprs/<username>/<coprname>/module/build/ HTTP/1.1
	Host: copr.fedoraproject.org
	Authorization: Basic base64=encoded=string
	Content-Type: multipart/form-data

	{
		"modulemd": "./module.yaml"
	}

Unfortunately there isn't `copr-cli` support yet, so in the meantime you can use something like this.

	curl --user <login>:<token> -F "modulemd=@`pwd`/<filename>.yaml" \
	     http://copr.fedoraproject.org/api/coprs/<user>/<copr>/module/build/

Where `<login>` and `<token>` values can be found in your `~/.config/copr` file.


## Limitations
1. Copr does not actually build the module in a way that it is supposed to do. It just takes built packages from chroots copy them into another directory and create module repository from it
2. As a consequence of the previous point, you must have all components successfully build in the repo before trying to build module
3. Missing copr-cli support


## What next
Currently we are working on the actual module building.