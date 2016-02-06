imgcache = require('../lib/imgcache.js')({ "cachedir": __dirname + '/testcache' })
testCase  = require('nodeunit').testCase
assert = require('assert')

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
