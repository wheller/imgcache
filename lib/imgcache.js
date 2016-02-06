(function() {
  'use strict';
  var imgcache;

  imgcache = function(opt) {
    var cachedir, debug, fs, mkdirp, parse, path, request;
    fs = require('fs');
    mkdirp = require('mkdirp');
    path = require('path');
    request = require('request');
    parse = function() {};
    opt = opt || {};
    cachedir = opt.cachedir || __dirname + '/imgcache';
    debug = opt.debug || false;
    return {
      info: {
        'path': cachedir,
        'dirname': '',
        'loadedfromcache': false
      },
      get: function(url, callback) {
        var self;
        self = this;
        this.info.path += '/' + url.replace(/^(ht|f)tps?:\/\//i, '').replace(/[^a-z0-9_\.\/-]/gi, '_');
        this.info.dirname = path.dirname(this.info.path);
        return fs.readFile(this.info.path, function(err, file, info) {
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
                return fs.readFile(info.path, function(err, file) {
                  return callback(error, file, self.info);
                });
              });
            });
          }
        });
      },
      isimage: function(url, callback) {
        return callback(null, url.match(/\.(gif|jpe?g|png)$/));
      }
    };
  };

  module.exports = imgcache;

}).call(this);
