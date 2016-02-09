
cachedir = __dirname + '/testcache'
testimage = 'https://upload.wikimedia.org/wikipedia/commons/a/ac/Large_format_camera_lens.jpg'
notimage = 'http://www.phirephly.com/'

imgcache = require('../lib/imgcache.js')({ "cachedir": cachedir, "debug":true })
testCase  = require('nodeunit').testCase
assert = require('assert')
should = require('should')
fs = require('fs')

exports.testsRunning = (test) ->
  test.expect 1
  test.equal 2 * 2, 4
  test.done()
  return

exports.imgcacheExists = (test) ->
  test.equal typeof imgcache, 'object'
  test.equal typeof imgcache.get, 'function'
  test.equal typeof imgcache.isimage, 'function'
  test.done()

exports.imgcacheIsImage = (test) ->
  test.expect 4
  imgcache.isimage testimage, (err, isimage) ->
    test.ok !err, "No error"
    test.ok isimage, "Test if image is correctly identified"
    imgcache.isimage notimage, (err, isimage) ->
      test.ok !err, "No error"
      test.ok !isimage, "Test if non image URL resolves to false"
  test.done()

exports.imgcacheDownloads = (test) ->
  test.expect 13
  imgcache.get testimage, (err,image,info) ->
    test.ok !err, "No error"
    test.ok info, "info returned"
    test.ok !info.loadedfromcache, "Not loaded from cache"
    test.ok image, "Image Returned"
    stats = fs.statSync(cachedir)
    test.ok stats.isDirectory(), "Intended Cache Directory Exists"
    test.ok info.path,"Check for full path to file"
    stats = fs.statSync(info.path)
    test.ok stats.isFile(), "File exists"
    test.ok imgcache.iscached(testimage), "Is Cached?"
    imgcache.get testimage, (err, image, info) ->
      test.ok !err, "No error"
      test.ok info.loadedfromcache, "Loaded from cache"
      imgcache.clear testimage, (err) ->
        test.ok(! err, "No error clearing file cache")
        test.throws (->
          fs.accessSync testimage, fs.F_OK
          return
        ), Error, 'Image should no longer exist'
        test.ok !imgcache.iscached(testimage), "Is Not Cached?"
      test.done()
