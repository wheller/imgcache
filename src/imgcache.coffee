
'use strict'

imgcache = (opt) ->

  # private data
  fs = require('fs')
  mkdirp = require('mkdirp')
  path = require('path')  
  request = require('request')
  
  # private functions
  getrelativepath = (url) ->
    url = url.replace /^(ht|f)tps?:\/\//i, ''   # remove protocol
    url = url.replace /[^/]+\/\.\.\//g, ''      # parent directories, resolved, evil stuff caught below
    url = url.replace /[^a-z0-9_\.\/-]/gi, '_'  # everything not alphanumeric dot underscore dash
    url.replace /\/./g, '/_'                    # dot files and evil urls foiled /.blah  -> /_blah


  opt = opt or {}
  cachedir = opt.cachedir or __dirname + '/imgcache'
  debug = opt.debug or false

  # public API
  {
    info:
      'path': cachedir
      'dirname': ''
      'loadedfromcache': false

    clear: (url, callback) ->
      relativepath = getrelativepath url
      try
        fs.unlinkSync cachedir + '/' + relativepath
      catch err
        return callback(err)
      limit = 30
      relativedirname = '/' + relativepath
      sep = (if path.sep == '/' then '\\' else '') + path.sep
      rx = new RegExp(sep + '[^' + sep + ']+' + sep + '?$')
      while (relativedirname = relativedirname.replace(rx,'')).length > 0 && (--limit > 0)
        console.log("relativedirname = " + relativedirname);
        try
          fs.rmdirSync cachedir + relativedirname
        catch err
          #this is ok, there might be other files in the directory
          if debug
            console.log 'Directory Not Empty, only clearing up to ' + relativedirname
          return callback(false)
      callback null

    get: (url, callback) ->
      self = this
      @info.path = cachedir + '/' + getrelativepath url
      @info.dirname = path.dirname(@info.path)
      fs.readFile @info.path, (err, file) ->
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
              fs.readFile self.info.path, (err, file) ->
                callback error, file, self.info

    iscached: (url) ->
      imagepath = cachedir + '/' + getrelativepath(url)
      try
        stats = fs.statSync(imagepath)
        return stats.isFile()
      catch err
        if debug
          console.log 'iscached? Apparenlty not ' + err
        return false
      false

    isimage: (url, callback) ->
      request.head url, (err, response) ->
        if err
          callback err, false
          return false
        else if !response or !response.headers or !response.headers['content-type']
          callback "Error: unexpected response"
          return false
        else
          rx = new RegExp "image", "i"
          isimage = rx.test response.headers['content-type']
          callback null, isimage
          return isimage
  }

module.exports = imgcache
