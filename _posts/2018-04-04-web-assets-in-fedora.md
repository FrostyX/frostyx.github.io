---
layout: post
title: Web assets in Fedora
lang: en
tags: dev fedora
---

[Web assets](https://fedoraproject.org/wiki/Packaging:Web_Assets) are any static files provided by a website to a browser that are required in order to render the site properly. Such files can be for example images, fonts, javascript and CSS code and so on. In this article we are going to focus on third-party assets like frontend frameworks or icon fonts and talk about how we usually ship them, explain why it is not a good idea and see how it can be done better.


## Bundling
The most common way to provide third-party assets like [jQuery](https://jquery.com/) or [Font Awesome](https://fontawesome.com/) is to download them, put them into some static directory of the application and commit them to the git repository. This is wrong for a [number of reasons](https://fedoraproject.org/wiki/Packaging:JavaScript#Rationale). The main one is security - developers are supposed to update the bundled libraries, but this usually never happens and results in using archaic versions that are buggy and have a lot of security issues.

Next problem is licensing. Consider the following situation. You are creating an application under the GPLv3 license and bundling-in a jQuery which is released under the MIT license and the [Google's code-prettifier](https://github.com/google/code-prettify) which is available under the Apache License 2.0. What are you going to put into the `License` tag in the `.spec` file of your package?

Does your project look like this and you don't even know javascript?

![GitHub project statistics - bundled javascript](/files/img/github-project-stats-bundled-js.png)

Then you probably bundle some third-party code.


## Packaged assets
A much better way to provide third-party assets is to use some kind of package manager. Probably the most popular choice among web developers is [Bower](https://bower.io/), but we are not going to talk about it now. This article is written in a context of Fedora infrastructure and therefore it describes the preferred solution for this scenario - and that is RPM packaging system.

Did you know that there is a lot of frontend libraries and frameworks packaged in Fedora? We have [jQuery](https://src.fedoraproject.org/rpms/js-jquery), [Patternfly](https://src.fedoraproject.org/rpms/python-XStatic-Patternfly), [Bootstrap](https://src.fedoraproject.org/rpms/python-XStatic-Bootstrap-SCSS), [CoffeeScript](https://src.fedoraproject.org/rpms/coffee-script), [Font Awesome](https://src.fedoraproject.org/rpms/fontawesome-fonts) and many more.

When using these packages, you can enjoy all the benefits of RPM.


## Searching packages
This is the most tricky part of the whole process. You can easily use DNF to search the particular software that you are interested in, but currently, there is no table that would map an upstream project to Fedora asset package. However, a convention is that name of such packages starts with `js-` or `xstatic-` and packages with fonts have `-fonts` at the end. Yes, system fonts [can be served](https://fedoraproject.org/wiki/Packaging:Web_Assets#Fonts) as a web asset ;-). Try these commands to see available packages.

    dnf search xstatic-*
    dnf search js-*
    dnf search *-fonts*


## How to use them
Asset packages install their files into `/usr/share/web-assets` and there is also a `/usr/share/javascript` which is a symlink to `/usr/share/web-assets/javascript`. Directory with all system fonts `/usr/share/fonts` is symlinked to `/usr/share/web-assets/fonts`. After installing the `web-assets-httpd` package, the web assets directory becames available via <http://127.0.0.1/.sysassets/>. Simple as that.

However, we chose a different approach for the Copr project. We use [internal flask server](http://flask.pocoo.org/docs/0.12/server/) for development purposes and httpd for production, so we needed the assets to be available in both of them. Our solution was to add a view to our application, which serves the web assets directory.

<pre class="prettyprint">
@app.route("/system_static/&lt;component&gt;/&lt;path:filename&gt;")
def system_static(component, filename):
    path = os.path.join("/usr/share/javascript", component)
    return flask.send_from_directory(path, filename)
</pre>

It can be used like this.

<pre class="prettyprint">
&lt;script src="&#123;&#123; url_for('system_static', component='jquery', filename='1/jquery.min.js') }}"></script>
</pre>

Feel free to customize the code to your needs.
