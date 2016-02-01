cbop = require('cbop');

# Local dependencies
# ------------------
# [BaseStorage](./BaseStorage.html)
BaseStorage = require('./BaseStorage')

# LocalStorage
# ============
class LocalStorage extends BaseStorage
  # set
  # ---
  # Set data for key
  #
  # **key** : key to set
  # **data** : data to set
  # **callback** : optional callback
  set : (args = {})->
    error = try
      key = @buildKey(args)
      wrapped = @wrap(args)
      json = JSON.stringify(wrapped)
      @backend.setItem(key, json)
      null
    catch err
      err

    cbop(
      error    : error
      callback : args.callback
    )


  # get
  # ---
  # Get data for key
  #
  # **key**: key to get
  # **callback**: optional callback
  get : (args = {})->
    [error, value] = try
      key  = @buildKey(args)
      json = @backend.getItem(key)

      value = if json
        @unwrap(
          data : JSON.parse(json)
          key  : key
        )
      else
        null

      [null, value]
    catch err
      [err, null]

    cbop(
      error    : error
      value    : value
      callback : args.callback
    )


  # remove
  # ------
  # Remove data for key
  #
  # **key** : key to remove
  remove : (args = {})->
    error = try
      key = @buildKey(args)
      @backend.removeItem(key)
      null
    catch err
      err

    cbop(
      error    : error
      callback : args.callback
    )


  # clear
  # ------
  # clear all the data
  #
  # **callback**: optional callback
  clear : (args = {})->
    error = try
      @backend.clear()
      null
    catch err
      err

    cbop(
      error    : error
      callback : args.callback
    )


  # length
  # ------
  # count of the number of entries
  #
  # **callback**: optional callback
  length : (args = {})->
    [error, value] = try
      [null, @backend.length]
    catch err
      [err, null]

    cbop(
      error    : error
      value    : value
      callback : args.callback
    )


  # keys
  # ----
  # return all the keys
  #
  # **callback**: optional callback
  keys : (args = {})->
    [error, keys] = try
      keys = (@backend.key(i) for i in [0 ... @backend.length])
      [null, keys]
    catch err
      [err, null]

    cbop(
      error    : error
      value    : keys
      callback : args.callback
    )


module.exports = LocalStorage
