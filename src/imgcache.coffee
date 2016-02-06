imgcache = (opt) ->

  # private data
  fs = require('fs')
  mkdirp = require('mkdirp')
  path = require('path')
  
  # private functions
  parse = ->

  opt = opt or {}
  cachedir = opt.cachedir or __dirname + '/imgcache'
  debug = opt.debug or false

  # public API
  {
    get: (url, callback) ->
      dirname = undefined
      self = undefined
      info = 
        'path': cachedir
        'dirname': ''
      info.path += '/' + url.replace(/^(ht|f)tps?:\/\//i, '').replace(/[^a-z0-9_\.\/-]/gi, '_')
      info.dirname = path.dirname(info.path)
      self = this
      fs.readFile info.path, (err, file) ->
        if !err
          @info.loadedFromCache = true
          callback err, file
        else
          @info.loadedFromCache = false
          if @options.debug
            console.log 'Downloading file: ' + info.path
          mkdirp info.dirname, (error) ->
            if error
              @info.error = error
              if @options.debug
                console.log 'Directory Creation Error: ' + error
              return callback(error)
            request(url).pipe(fs.createWriteStream(info.path)).on 'close', ->
              fs.readFile info.path, (err, file) ->
                callback error, file, info
    isimage: (url, callback) ->

  }

module.exports = imgcache
