ImgCache
========
[![Build Status](https://travis-ci.org/wheller/imgcache.svg?branch=master)](https://travis-ci.org/wheller/imgcache)
[![npm version](https://badge.fury.io/js/imgcache.svg)](https://badge.fury.io/js/imgcache)
[![Known Vulnerabilities](https://snyk.io/test/github/wheller/imgcache/badge.svg)](https://snyk.io/test/github/wheller/imgcache)

Simple Web Image Resolving and Caching Utility NPM Module

*Still in experimental state, please check back soon*


## About
>
>  This library was written originally to supply images for a secure chat client that interfaces with Hubot.
>  The project itself was designed to be a framework for building good npm modules including testing and
>  debugging.  The library is written in CoffeeScript and published in JS for compatibility.  CoffeeScript
>  was selected not because of any particular preference, rather as Hubot itself is written in CS, we needed
>  a good proof of concept for debugging and interacting with CoffeeScript for pure JS developers who may
>  contribute to our more complex code.  At least on our team, good JavaScript developers are much easier 
>  to find than good JavaScript developers who already know CoffeeScript.
>


## Locations
>
>  npm: https://www.npmjs.com/package/imgcache
>
>  github: https://github.com/wheller/imgcache
>


## Installation
>
> ### As dependency for your project
>  `$ npm install imgcache --save`
>
> ### For module testing and development
> Assumes you already have Node.js and npm installed.<br />
>  *clone the repo:*
>  ```
>   $ git clone https://github.com/wheller/imgcache
>  ```
>
>  *Optionally install global tools (might need sudo depending upon your environment)*
>  ```
>   $ npm install -g grunt-cli coffee-script
>  ```
>
>  *Install all dependencies*
>  ```
>   $ cd imgcache
>   $ npm install
>  ```
>


## Usage
  
```
  imgcache = require("imgcache.js")({ "cachedir": "/home/user/mycachedir" });

  // Get image by url, from cache if available, otherwise downloaded from the supplied URL and then added to cache.
  imgcache.get("http://www.phirephly.com/someimage.jpeg", function(err,file,info){
    ... your code here ...
  });

  // Check to see if the supplied URL is an image
  imgcache.isimage("http://www.phirephly.com/someimage.jpeg" function(err, urlisimage){
    ... boolen urlisimage based upon http headers, follows redirects ...
  });
```


## Testing
>
>  `$ grunt test`
>
>  or
>
>  `$ npm test`
>


## Debugging
>
>  Build and Debug<br />
>  `$ grunt debug`
>
>  Which equates to grunt build then...<br />
>  `$ node-debug --debug-brk $(which grunt) nodeunit`
>
>  then load in chrome..<br />
>  http://127.0.0.1:8080/?ws=127.0.0.1:8080&port=5858
>


## Contributing
>
>  The original code is written in CoffeeScript, please make your edits there and create appropriate tests if you would like any merge request to be considered.
>


## Building
>
>  Transpile CoffeeScript (./src/) to final JavaScript (./lib/)<br />
>  `$ grunt build`
>
>  Or full build with tests and linting<br /> 
>  `$ grunt`
>


## ToDo
>
>  * add options to listen to (or ignore) cache headers
>  * add callback to iscached
>  * add way to specify mimetypes we care about (currently: /image/i )
>  * add promise support
