cbop = require('cbop')

class LocalForage
  constructor : ()->
    @store = {}

  setItem : (key, value, callback)->
    @store[key] = value
    cbop(
      callback : callback
    )

  getItem : (key, callback)->
    cbop(
      value    : @store[key]
      callback : callback
    )

  removeItem : (key, callback)->
    delete @store[key]
    cbop(
      callback : callback
    )

  clear : (callback)->
    @store = {}
    cbop(
      callback : callback
    )

  keys : (callback)->
    cbop(
      value    : Object.keys(@store)
      callback : callback
    )

  length : (callback)->
    cbop(
      value    : Object.keys(@store).length
      callback : callback
    )

  iterate : ()->
    # this is just for matching .create
    'derp'


module.exports = LocalForage
