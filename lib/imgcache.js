(function() {
  var imgcache;

  imgcache = function(opt) {
    var cachedir, debug, fs, mkdirp, parse, path;
    fs = require('fs');
    mkdirp = require('mkdirp');
    path = require('path');
    parse = function() {};
    opt = opt || {};
    cachedir = opt.cachedir || __dirname + '/imgcache';
    debug = opt.debug || false;
    return {
      get: function(url, callback) {
        var dirname, info, self;
        dirname = void 0;
        self = void 0;
        info = {
          'path': cachedir,
          'dirname': ''
        };
        info.path += '/' + url.replace(/^(ht|f)tps?:\/\//i, '').replace(/[^a-z0-9_\.\/-]/gi, '_');
        info.dirname = path.dirname(info.path);
        self = this;
        return fs.readFile(info.path, function(err, file) {
          if (!err) {
            this.info.loadedFromCache = true;
            return callback(err, file);
          } else {
            this.info.loadedFromCache = false;
            if (this.options.debug) {
              console.log('Downloading file: ' + info.path);
            }
            return mkdirp(info.dirname, function(error) {
              if (error) {
                this.info.error = error;
                if (this.options.debug) {
                  console.log('Directory Creation Error: ' + error);
                }
                return callback(error);
              }
              return request(url).pipe(fs.createWriteStream(info.path)).on('close', function() {
                return fs.readFile(info.path, function(err, file) {
                  return callback(error, file, info);
                });
              });
            });
          }
        });
      },
      isimage: function(url, callback) {}
    };
  };

  module.exports = imgcache;

}).call(this);
