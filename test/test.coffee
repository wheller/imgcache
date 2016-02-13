
cachedir = __dirname + '/testcache'
testimage = 'https://upload.wikimedia.org/wikipedia/commons/a/ac/Large_format_camera_lens.jpg'
testimageparentdir = 'https://upload.wikimedia.org/wikipedia/commons/b/../a/ac/Large_format_camera_lens.jpg'
redirectimage = 'http://blh.me/c'
imagewithspaces = 'http://www.billheller.com/imgcache/image with space in name.jpg'
imagewithspacesencoded = 'http://www.billheller.com/imgcache/another%20space%20image.jpg'
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
        test.ok !err, "There should be no error downloading "+desc
        test.ok image, "There should be image data for "+desc
        test.ok info, "There should be an info object populated for "+desc
        if !info or !info.path
          return reject(err)
        else
          stats = fs.statSync(info.path)
          test.ok stats.isFile(), "The file should exist in the cache directory "+desc
          test.ok imgcache.iscached(img), "iscached should indicate the image is now cached "+desc
          if err
            return reject(err)
          imgcache.clear img, (errclear) ->
            test.ok !err, "There should be no error clearing the image "+desc
            test.throws(->
              fs.accessSync img, fs.F_OK
              return
            , Error, "The image should no longer exist "+desc)
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

  # Query to see if the given URL is an image
  imgcache.isimage testimage, (err, isimage) ->
    test.ok !err, "No error on normal image URL"
    test.ok isimage, "Test if image is correctly identified"

    # Test a URL that should indicate it is not an image
    imgcache.isimage notimage, (err, isimage) ->
      test.ok !err, "No error on URL that is not an image"
      test.ok !isimage, "Test if non image URL resolves to false"

      # Test redirected URL that eventually resolves to an image
      imgcache.isimage redirectimage, (err, isimage) ->
        test.ok !err, "No error on redirect to image"
        test.ok isimage, "Test if redirection is identified as image"
        test.done()

exports.imgcacheDownloads = (test) ->
  test.expect 15
  
  #Initial image get test
  imgcache.get testimage, (err,image,info) ->
    test.ok !err, "Should not return an error downloading testimage: #{testimage}"
    test.ok info, "Info should be populated after downloading testimage: #{testimage}"
    test.ok !info.loadedfromcache, "On the initial download, we should not hit the cache for testimage: #{testimage}"
    test.ok image, "Image should be populated for testimage: #{testimage}"
    stats = fs.statSync(cachedir)
    test.ok stats.isDirectory(), "Intended Cache Directory Exists after download of testimage: #{testimage}"
    test.ok info.path, "Path should be populated in info.path after download of testimage: #{testimage}"
    stats = fs.statSync(info.path)
    test.ok stats.isFile(), "File should exist after download of testimage: #{testimage}"
    test.ok imgcache.iscached(testimage), "Image should be cached after initial download of testimage: #{testimage}"

    # Get the same image again, hopefully from cache
    imgcache.get testimage, (err, image, info) ->
      test.ok !err, "Should not return an error downloading CACHED testimage: #{testimage}"
      test.ok info.loadedfromcache, "Info should indicate Loaded from cache for second request for testimage: #{testimage}"

      # Test the same image, with a parent directory reference '../' in the url 
      imgcache.get testimageparentdir, (err, image, infoparent) ->
        test.ok !err, "There shoudl be no error resolving URL with parent ref testimageparentdir: #{testimageparentdir}"
        test.equal info.path, infoparent.path, "URL with ../ in it should resolve to the same file and load from cache testimageparentdir: #{testimageparentdir}"

        # Test clearing the cache for a partidular image
        imgcache.clear testimage, (err) ->
          test.ok(! err, "There should be no errors clearing file cache for testimage: #{testimage}")
          test.throws (->
            fs.accessSync testimage, fs.F_OK
            return
          ), Error, 'Image should no longer exist testimage: #{testimage}'
          test.ok !imgcache.iscached(testimage), "iscached should indicate the image is no longer cached testimage: #{testimage}"
          test.done()

exports.imgcacheEdgeCases = (test) ->
  imageURLs = {
    "Image with spaces in URL":imagewithspaces
#    "image with %20 in URL":imagewithspacesencoded
  }
  imageURLsFail = {
    "Image 404":image_4o4
  }

  expected = testanimagenumassertions() * Object.keys(imageURLs).length
  expected +=  testanimagenumassertions(true) * Object.keys(imageURLsFail).length
  test.expect expected

  images = new Array
  for k,v of imageURLs
    images.push(testanimagecallback test, v, k)
  for k,v of imageURLsFail
    images.push(testanimagecallback test, v, k, true)
 
  Promise.all(images).then ->
    console.log 'promises resolved'
    test.done()
  , ->
    console.log 'promise rejected'
    test.done()
