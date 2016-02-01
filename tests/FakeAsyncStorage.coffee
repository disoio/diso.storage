cbop = require('cbop')

class AsyncStorage
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

  getAllKeys : (callback)->
    cbop(
      value    : Object.keys(@store)
      callback : callback
    )


module.exports = AsyncStorage
