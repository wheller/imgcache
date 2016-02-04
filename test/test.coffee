imgcache = require '../lib/imgcache.js'
testCase  = require('nodeunit').testCase
assert = require('assert')
console.log imgcache
exports.calculate = (test) ->
  test.equal 2 * 2, 4
  test.done()
  return

exports.imgcacheExists = (test) ->
  test.equal typeof imgcache, 'object'
  test.equal typeof imgcache.get, 'function'
  test.equal typeof imgcache.isImage, 'function'
  test.done()
