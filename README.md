ImgCache
========

Simple Web Image Resolving and Caching Utility NPM Module

*Still in experimental state, please check back soon*


## Location

  npm: https://www.npmjs.com/package/imgcache

  github: https://github.com/wheller/imgcache


## Installation
  
### As dependency for your project
  `$ npm install imgcache --save`

### For module testing and development
>  *clone the repo:*
>  ```
>   $ git clone https://github.com/wheller/imgcache`
>  ```
>
>  *Optionally install global tools (might need sudo depending upon your environment)*
>  ```
>   $ npm install -g grunt-cli coffee-script`
>  ```
>
>  *Install all dependencies*
>  ```
>   $ cd imgcache
>   $ npm install
>  ```

## Usage
  
```
  imgcache = require("imgcache.js")({ "cachedir": "/home/user/mycachedir" });

  // Get image by url, from cache if available, otherwise downloaded from the supplied URL and then added to cache.
  imgcache.get("http://www.phirephly.com/someimage.jpeg", function(err,file,info){
    ... your code here ...
  });

  // Check to see if the supplied URL is an image, returns boolean
  var isimage = imgcache.isimage("http://www.phirephly.com/someimage.jpeg")
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


## ToDo

  * check for evil urls... http://../../etc..
  * add iscached()
  * add real check to isimage
  * add options to listen to (or ignore) cache headers


