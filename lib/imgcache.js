(function() {
  'use strict';
  var imgcache;

  imgcache = function(opt) {
    var cachedir, debug, fs, getrelativepath, mkdirp, path, request;
    fs = require('fs');
    mkdirp = require('mkdirp');
    path = require('path');
    request = require('request');
    getrelativepath = function(url) {
      url = url.replace(/^(ht|f)tps?:\/\//i, '');
      url = url.replace(/[^\/]+\/\.\.\//g, '');
      url = url.replace(/[^a-z0-9_\.\/-]/gi, '_');
      return url.replace(/\/./g, '/_');
    };
    opt = opt || {};
    cachedir = opt.cachedir || __dirname + '/imgcache';
    debug = opt.debug || false;
    return {
      info: {
        'path': cachedir,
        'dirname': '',
        'loadedfromcache': false
      },
      clear: function(url, callback) {
        var err, limit, relativedirname, relativepath, rx, sep;
        relativepath = getrelativepath(url);
        try {
          fs.unlinkSync(cachedir + '/' + relativepath);
        } catch (_error) {
          err = _error;
          return callback(err);
        }
        limit = 30;
        relativedirname = '/' + relativepath;
        sep = (path.sep === '/' ? '\\' : '') + path.sep;
        rx = new RegExp(sep + '[^' + sep + ']+' + sep + '?$');
        while ((relativedirname = relativedirname.replace(rx, '')).length > 0 && (--limit > 0)) {
          console.log("relativedirname = " + relativedirname);
          try {
            fs.rmdirSync(cachedir + relativedirname);
          } catch (_error) {
            err = _error;
            if (debug) {
              console.log('Directory Not Empty, only clearing up to ' + relativedirname);
            }
            return callback(false);
          }
        }
        return callback(null);
      },
      get: function(url, callback) {
        var self;
        self = this;
        this.info.path = cachedir + '/' + getrelativepath(url);
        this.info.dirname = path.dirname(this.info.path);
        return fs.readFile(this.info.path, function(err, file) {
          if (!err) {
            self.info.loadedfromcache = true;
            return callback(err, file, self.info);
          } else {
            if (debug) {
              console.log('Downloading file: ' + self.info.path);
            }
            return mkdirp(self.info.dirname, function(error) {
              if (error) {
                self.info.error = error;
                if (debug) {
                  console.log('Directory Creation Error: ' + error);
                }
                return callback(error);
              }
              return request(url).pipe(fs.createWriteStream(self.info.path)).on('close', function() {
                return fs.readFile(self.info.path, function(err, file) {
                  return callback(error, file, self.info);
                });
              });
            });
          }
        });
      },
      iscached: function(url) {
        var err, imagepath, stats;
        imagepath = cachedir + '/' + getrelativepath(url);
        try {
          stats = fs.statSync(imagepath);
          return stats.isFile();
        } catch (_error) {
          err = _error;
          if (debug) {
            console.log('iscached? Apparenlty not ' + err);
          }
          return false;
        }
        return false;
      },
      isimage: function(url, callback) {
        return request.head(url, function(err, response) {
          var isimage, rx;
          if (err) {
            callback(err, false);
            return false;
          } else if (!response || !response.headers || !response.headers['content-type']) {
            callback("Error: unexpected response");
            return false;
          } else {
            rx = new RegExp("image", "i");
            isimage = rx.test(response.headers['content-type']);
            callback(null, isimage);
            return isimage;
          }
        });
      }
    };
  };

  module.exports = imgcache;

}).call(this);
