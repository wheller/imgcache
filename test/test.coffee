
cachedir = __dirname + '/testcache'

imgcache = require('../lib/imgcache.js')({ "cachedir": cachedir })
testCase  = require('nodeunit').testCase
assert = require('assert')
fs = require('fs')

#for k,v of imgcache
#  console.log k + " is " + v

exports.testsRunning = (test) ->
  test.equal 2 * 2, 4
  test.done()
  return

exports.imgcacheExists = (test) ->
  test.equal typeof imgcache, 'object'
  test.equal typeof imgcache.get, 'function'
  test.equal typeof imgcache.isimage, 'function'
  test.done()

exports.imgcacheDownloads = (test) ->
  imgcache.get 'https://upload.wikimedia.org/wikipedia/commons/a/ac/Large_format_camera_lens.jpg', (err,image,info) ->
    test.ok(! err,"No error")
    test.ok(image,"Image Returned")
    stats = fs.lstatSync(cachedir);
    test.ok(stats.isDirectory(),"Intended Cache Directory Exists")
    test.ok(info.path,"Check for full path to file")
    stats = fs.lstatSync(info.path)
    test.ok(stats.isFile(),"File exists")
    test.done()
