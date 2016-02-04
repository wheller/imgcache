(function() {
  var fs, merge, path;

  path = require('path');

  fs = require('fs');

  merge = function(obj, defaults) {
    var k;
    for (k in defaults) {
      if (defaults.hasOwnProperty(k)) {
        if (!obj.hasOwnProperty(k)) {
          obj[k] = defaults[k];
        }
      }
    }
    return obj;
  };

  exports.imgcache = (function() {
    var imgcache, mkDirP;
    imgcache = function(options) {
      this.options = merge(options, {
        'cacheDir': __dirname + '/imgcache',
        'debug': false
      });
    };
    mkDirP = function(filepath, callback) {
      var mode, self;
      mode = void 0;
      self = void 0;
      if (this.options.debug) {
        console.log('Making dir ' + filepath);
      }
      self = this;
      mode = parseInt('0755', 8);
      return fs.mkdir(filepath, function(err) {
        if (err) {
          if (err.code === 'EEXIST') {
            callback(null);
          } else if (err.code === 'ENOENT') {
            if (this.options.debug) {
              console.log('ERROR Making dir err.code= ' + err.code);
            }
            self.mkDirP(path.dirname(filepath), function(err) {
              if (err) {
                return callback(err);
              } else {
                return fs.mkdir(filepath, function(err) {
                  return callback(err);
                });
              }
            });
          } else {
            if (this.options.debug) {
              console.log('ERROR Making dir err.code= ' + err.code);
            }
            callback(err);
          }
        } else {
          callback(null);
        }
      });
    };
    imgcache.prototype.get = function(url, callback) {
      var dirName, filePath, self;
      dirName = void 0;
      filePath = void 0;
      self = void 0;
      filePath = this.options.cacheDir;
      if (process.env.IMGCACHE_DOWNLOAD_CACHE_DIR) {
        filePath = process.env.IMGCACHE_DOWNLOAD_CACHE_DIR;
      }
      filePath += '/' + url.replace(/^(ht|f)tps?:\/\//i, '').replace(/[^a-z0-9_\.\/-]/gi, '_');
      this.info.dirName = path.dirname(filePath);
      self = this;
      return fs.readFile(filePath, function(err, file) {
        if (!err) {
          this.info.loadedFromCache = true;
          return callback(file, err);
        } else {
          this.info.loadedFromCache = false;
          if (this.options.debug) {
            console.log('Downloading file: ' + filePath);
          }
          return mkDirP(this.info.dirName, function(error) {
            if (error) {
              this.info.error = error;
              if (this.options.debug) {
                console.log('Directory Creation Error: ' + error);
              }
            }
            return request(url).pipe(fs.createWriteStream(filePath)).on('close', function() {
              return fs.readFile(filePath, function(err, file) {
                return callback(filePath, file, error);
              });
            });
          });
        }
      });
    };
    return imgcache;
  })();

  return;

}).call(this);
