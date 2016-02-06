
'use strict'

imgcache = (opt) ->

  # private data
  fs = require('fs')
  mkdirp = require('mkdirp')
  path = require('path')  
  request = require('request')
  
  # private functions
  parse = ->

  opt = opt or {}
  cachedir = opt.cachedir or __dirname + '/imgcache'
  debug = opt.debug or false

  # public API
  {
    info:
      'path': cachedir
      'dirname': ''
      'loadedfromcache': false
    get: (url, callback) ->
      self = this
      @info.path += '/' + url.replace(/^(ht|f)tps?:\/\//i, '').replace(/[^a-z0-9_\.\/-]/gi, '_')
      @info.dirname = path.dirname(@info.path)
      fs.readFile @info.path, (err, file, info) ->
        if !err
          self.info.loadedfromcache = true
          callback err, file, self.info
        else
          if debug
            console.log 'Downloading file: ' + self.info.path
          mkdirp self.info.dirname, (error) ->
            if error
              self.info.error = error
              if debug
                console.log 'Directory Creation Error: ' + error
              return callback(error)
            request(url).pipe(fs.createWriteStream(self.info.path)).on 'close', ->
              fs.readFile info.path, (err, file) ->
                callback error, file, self.info
    isimage: (url, callback) ->
      callback null, url.match(/\.(gif|jpe?g|png)$/)

  }

module.exports = imgcache
