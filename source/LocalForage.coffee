# Local dependencies
# ------------------
# [BaseStorage](./BaseStorage.html)
BaseStorage = require('./BaseStorage')


# LocalForage
# ============
class LocalForage extends BaseStorage
  # set
  # ---
  # Set data for key
  #
  # **key** : key to set
  # **data** : data to set
  # **callback** : optional callback
  set : (args = {})->
    {callback} = args

    try
      key = @buildKey(args)
      value = @wrap(args)
      @backend.setItem(key, value, callback)
    catch error
      if callback
        callback(error, null)
      else
        new Promise((reject, resolve)->
          reject(error)
        )


  # get
  # ---
  # Get data for key
  #
  # **key**: key to get
  # **callback**: optional callback
  get : (args = {})->
    {callback} = args

    key = @buildKey(args)

    if callback
      @backend.getItem(key, (error, value)=>
        if (value and !error)
          try
            value = @unwrap(
              data : value
              key  : key
            )
          catch err
            error = err

        callback(error, value)
      )
    else
      @backend.getItem(key).then((value)=>
        @unwrap(
          data : value
          key  : key
        ) || null
      )


  # remove
  # ------
  # Remove data for key
  #
  # **key** : key to remove
  # **callback**: optional callback
  remove : (args = {})->
    key = @buildKey(args)
    @backend.removeItem(key, args.callback)


  # clear
  # ------
  # clear all the data
  #
  # **callback**: optional callback
  clear : (args = {})->
    @backend.clear(args.callback)


  # length
  # ------
  # count of the number of entries
  #
  # **callback**: optional callback
  length : (args = {})->
    @backend.length(args.callback)


  # keys
  # ----
  # return all the keys
  #
  # **callback**: optional callback
  keys : (args = {})->
    @backend.keys(args.callback)


module.exports = LocalForage
