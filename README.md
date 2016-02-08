ImgCache
========

Simple Web Image Resolving and Caching Utility NPM Module

*Still in experimental state, please check back soon*


## Location

  npm: https://www.npmjs.com/package/imgcache

  github: https://github.com/wheller/imgcache


## Installation

  npm install imgcache --save


## Usage
  
```
  imgcache = require("imgcache.js")({ "cachedir": "/home/user/mycachedir" });
  imgcache.get("http://www.phirephly.com/someimage.jpeg", function(err,file,info){

  });
```


## Testing

  `$ grunt test`

  or

  `$ npm test`


## Debugging

  `$ grunt debug`

  which is basically...
  `$ node-debug --debug-brk $(which grunt) nodeunit`

  then load in chrome..
  http://127.0.0.1:8080/?ws=127.0.0.1:8080&port=5858


## Contributing

  The original code is written in CoffeeScript, please make your edits there and create appropriate tests if you would like any merge request to be considered.


## Building

  `$ grunt`



