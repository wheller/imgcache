path = require('path')
fs = require('fs')

merge = (obj, defaults) ->
  for k of defaults
    if defaults.hasOwnProperty(k)
      if !obj.hasOwnProperty(k)
        obj[k] = defaults[k]
  obj

exports.imgcache = do ->

  imgcache = (options) ->
    @options = merge(options,
      'cacheDir': __dirname + '/imgcache'
      'debug': false)
    return

  imgcache::mkDirP = (filepath, callback) ->
    if @options.debug
      console.log 'Making dir ' + filepath
    self = this
    mode = parseInt('0755', 8)
    fs.mkdir filepath, (err) ->
      if err
        if err.code == 'EEXIST'
          callback null
        else if err.code == 'ENOENT'
          if @options.debug
            console.log 'ERROR Making dir err.code= ' + err.code
          self.mkDirP path.dirname(filepath), (err) ->
            if err
              callback err
            else
              fs.mkdir filepath, (err) ->
                callback err
        else
          if @options.debug
            console.log 'ERROR Making dir err.code= ' + err.code
          callback err
      else
        callback null
      return

  imgcache::get = (url, callback) ->
    dirName = undefined
    filePath = undefined
    self = undefined
    dirName = undefined
    filePath = undefined
    self = undefined
    filePath = @options.cacheDir
    if process.env.IMGCACHE_DOWNLOAD_CACHE_DIR
      filePath = process.env.IMGCACHE_DOWNLOAD_CACHE_DIR
    filePath += '/' + url.replace(/^(ht|f)tps?:\/\//i, '').replace(/[^a-z0-9_\.\/-]/gi, '_')
    @info.dirName = path.dirname(filePath)
    self = this
    fs.readFile filePath, (err, file) ->
      if !err
        @info.loadedFromCache = true
        callback file, err
      else
        @info.loadedFromCache = false
        if @options.debug
          console.log 'Downloading file: ' + filePath
        self.mkDirP @info.dirName, (error) ->
          if error
            @info.error = error
            if @options.debug
              console.log 'Directory Creation Error: ' + error
          request(url).pipe(fs.createWriteStream(filePath)).on 'close', ->
            fs.readFile filePath, (err, file) ->
              callback filePath, file, error

  imgcache
