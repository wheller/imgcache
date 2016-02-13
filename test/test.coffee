
cachedir = __dirname + '/testcache'
testimage = 'https://upload.wikimedia.org/wikipedia/commons/a/ac/Large_format_camera_lens.jpg'
testimageparentdir = 'https://upload.wikimedia.org/wikipedia/commons/b/../a/ac/Large_format_camera_lens.jpg'
redirectimage = 'http://blh.me/c'
imagewithspaces = 'http://img.photobucket.com/albums/v37/hraea/Flying%20Squirrels/Flyer%20Calendar/A_-_CoverBack.jpg'
notimage = 'http://www.phirephly.com/'
image_4o4 = 'http://www.phirephly.com/npm/imgcache/unittest404'

imgcache = require('../lib/imgcache.js')({ "cachedir": cachedir, "debug":true })
testCase  = require('nodeunit').testCase
assert = require('assert')
should = require('should')
fs = require('fs')

#require 'coffee-script/register'
#require 'coffee-coverage/register-istanbul'

exports.testsRunning = (test) ->
  test.expect 1
  test.equal 2 * 2, 4
  test.done()
  return

testanimagenumassertions = (expectfailure) ->
  if expectfailure
    return 2
  return 7

testanimagecallback = (test, img, desc, expectfailure) ->
  return new Promise((resolve, reject) ->
    imgcache.get img, (err, image, info) ->
      if expectfailure
        test.ok err, "Expected Error: "+desc
        test.ok !image, "Expected no image: "+desc
        resolve (
          'err'  :err
          'image':image
          'info' :info
        )
      else
        test.ok !err, "No error for: "+desc
        test.ok image, "Image Returned: "+desc
        test.ok info, "Info returned: "+desc
        if !info or !info.path
          return reject(err)
        else
          stats = fs.statSync(info.path)
          test.ok stats.isFile(), "File Exists: "+desc
          test.ok imgcache.iscached(img), "Is Cached? "+desc
          if err
            return reject(err)
          imgcache.clear img, (errclear) ->
            test.ok !err, "No error clearing image: "+desc
            test.throws(->
              fs.accessSync img, fs.F_OK
              return
            , Error, "Image should no longer exist "+desc)
            if errclear
              return reject(errclear)
            resolve (
              'err'  :err
              'image':image
              'info' :info
            )
  )
    


exports.imgcacheExists = (test) ->
  test.equal typeof imgcache, 'object'
  test.equal typeof imgcache.get, 'function'
  test.equal typeof imgcache.isimage, 'function'
  test.done()

exports.imgcacheIsImage = (test) ->
  test.expect 6
  imgcache.isimage testimage, (err, isimage) ->
    test.ok !err, "No error on normal image URL"
    test.ok isimage, "Test if image is correctly identified"
    imgcache.isimage notimage, (err, isimage) ->
      test.ok !err, "No error on URL that is not an image"
      test.ok !isimage, "Test if non image URL resolves to false"
      imgcache.isimage redirectimage, (err, isimage) ->
        test.ok !err, "No error on redirect to image"
        test.ok isimage, "Test if redirection is identified as image"
        test.done()

exports.imgcacheDownloads = (test) ->
  test.expect 15
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
      imgcache.get testimageparentdir, (err, image, infoparent) ->
        test.ok !err, "No error resolving URL with parent ref"
        test.equal info.path, infoparent.path, "Does URL with ../ in it resolve to the same file?"
        imgcache.clear testimage, (err) ->
          test.ok(! err, "No error clearing file cache")
          test.throws (->
            fs.accessSync testimage, fs.F_OK
            return
          ), Error, 'Image should no longer exist'
          test.ok !imgcache.iscached(testimage), "Is Not Cached?"
          test.done()

exports.imgcacheEdgeCases = (test) ->
  imageURLs = {
#    "Image with %20 in URL":imagewithspaces
  }
  imageURLsFail = {
    "Image 404":image_4o4
  }
  console.log 'imageURLs length ',Object.keys(imageURLs).length
  console.log 'imageURLsFail length ',Object.keys(imageURLsFail).length
  console.log 'testanimagenumassertions(true) ',testanimagenumassertions(true)
  expected = testanimagenumassertions() * Object.keys(imageURLs).length
  expected +=  testanimagenumassertions(true) * Object.keys(imageURLsFail).length
  test.expect expected
  images = new Array
  for k,v of imageURLs
    images.push(testanimagecallback test, v, k)
  for k,v of imageURLsFail
    images.push(testanimagecallback test, v, k, true)
 
  Promise.all(images).then ->
    console.log 'promise resolved'
    test.done()
