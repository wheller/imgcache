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

  `$ npm test` or `$ grunt nodeunit`


## Debugging

  `$ node-debug --debug-brk $(which grunt) nodeunit`


## Contributing

  The original code is written in CoffeeScript, please make your edits there and create appropriate tests if you would like any merge request to be considered.


## Building

  `$ grunt`



