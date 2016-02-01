cbop = require('cbop');

# Local dependencies
# ------------------
# [BaseStorage](./BaseStorage.html)
BaseStorage = require('./BaseStorage')

# MemoryStorage
# =============
# naive in memory storage

class MemoryStorage extends BaseStorage
  # set
  # ---
  # Set data for key
  #
  # **key** : key to set
  # **data** : data to set
  set : (args = {})->
    data = args.data
    key  = @buildKey(args)

    wrapped = @wrap(args)
    @backend[key] = wrapped

    cbop(
      error    : null
      callback : args.callback
    )


  # get
  # ---
  # Get data for key
  #
  # **key**: key to get
  # **callback**: optional callback
  get : (args = {})->
    key = @buildKey(args)

    value = if (key of @backend)
      @unwrap(
        data : @backend[key]
        key  : key
      )
    else
      null

    cbop(
      error    : null
      value    : value
      callback : args.callback
    )


  # remove
  # ------
  # Remove data for key
  #
  # **key** : key to remove
  remove : (args = {})->
    key = @buildKey(args)
    delete @backend[key]

    cbop(
      error    : null
      callback : args.callback
    )


  # clear
  # ------
  # clear all the data
  #
  # **key** : key to remove
  clear : (args = {})->
    @backend = {}

    cbop(
      error    : null
      callback : args.callback
    )


  # length
  # ------
  # count of the number of entries
  length : (args = {})->
    value = Object.keys(@backend).length

    cbop(
      error    : null
      value    : value
      callback : args.callback
    )


  # keys
  # ----
  # callback
  keys : (args = {})->
    keys = Object.keys(@backend)

    cbop(
      error    : null
      value    : keys
      callback : args.callback
    )

module.exports = MemoryStorage
