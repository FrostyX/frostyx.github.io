---
layout: post
title: Creating Cockpit plugins in ClojureScript
lang: en
tags: fedora cockpit dev
---

TODO

## Init project

```
npm install
npx create-cljs-app my-app
```

## Manifest

TODO

## Index

From pinger ...

```html
<div id="app">
  <h3>ClojureScript has not been compiled!</h3>
  <p>Please run <b>npx shadow-cljs release app</b></p>
</div>
```

At the very end of the `<body></body>`

```html
<script src="public/js/app.js" type="text/javascript"></script>
<script src="public/js/init.js"></script>
```

## Init.js

```javascript
// Init our ClojureScript code
cockpit_ssh_keys.core.init_BANG_();

// Send a 'init' message.  This tells integration tests that we are ready to go
cockpit.transport.wait(function() { });
```

## ClojureScript

TODO

## Build

```
npx shadow-cljs release app
```

## Patternfly

TODO

## CSS

TODO Show style.scss

```
npx sass --load-path=node_modules --style compressed \
    public/css/style.scss:public/css/style.css
```

```html
<link href="public/css/style.css" type="text/css" rel="stylesheet">
<link href="node_modules/@patternfly/patternfly/patternfly.min.css" type="text/css" rel="stylesheet">
```

## RPM Packaging

TODO
