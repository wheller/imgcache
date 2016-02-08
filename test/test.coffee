
cachedir = __dirname + '/testcache'
testimage = 'https://upload.wikimedia.org/wikipedia/commons/a/ac/Large_format_camera_lens.jpg'
notimage = 'http://www.phirephly.com/'

imgcache = require('../lib/imgcache.js')({ "cachedir": cachedir, "debug":true })
testCase  = require('nodeunit').testCase
assert = require('assert')
fs = require('fs')

exports.testsRunning = (test) ->
  test.equal 2 * 2, 4
  test.done()
  return

exports.imgcacheExists = (test) ->
  test.equal typeof imgcache, 'object'
  test.equal typeof imgcache.get, 'function'
  test.equal typeof imgcache.isimage, 'function'
  test.done()

exports.imgcacheIsImage = (test) ->
  imgcache.isimage testimage, (err, isimage) ->
    test.ok(! err,"No error")
    test.ok(isimage, "Test if image is correctly identified")
    imgcache.isimage notimage, (err, isimage) ->
      test.ok(! err,"No error")
      test.ok(!isimage, "Test if non image URL resolves to false")
  test.done()

exports.imgcacheDownloads = (test) ->
  imgcache.get testimage, (err,image,info) ->
    test.ok(! err,"No error")
    test.ok(info,"info returned")
    test.ok(!info.loadedfromcache,"Not loaded from cache")
    test.ok(image,"Image Returned")
    stats = fs.statSync(cachedir)
    test.ok(stats.isDirectory(),"Intended Cache Directory Exists")
    for k,v of info
      console.log k + " is " + v
    test.ok(info.path,"Check for full path to file")
    stats = fs.statSync(info.path)
    test.ok(stats.isFile(),"File exists")
    imgcache.clear testimage, (err) ->
      test.ok(! err, "No error clearing file cache")
#      test.throws(fs.accessSync testimage, fs.F_OK, Error, "file should be gone")
    test.done()
