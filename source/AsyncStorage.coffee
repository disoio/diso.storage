# Local dependencies
# ------------------
# [BaseStorage](./BaseStorage.html)
BaseStorage = require('./BaseStorage')


# LocalStorage
# ============
class AsyncStorage extends BaseStorage
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
      wrapped = @wrap(args)
      json = JSON.stringify(wrapped)
    catch error
      if callback
        callback(error, null)
        return
      else
        return new Promise((reject, resolve)->
          reject(error)
        )

    @backend.setItem(key, json, callback)


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
      @backend.getItem(key, (error, json)=>
        value = null
        if (!error and json)
          try
            value = @unwrap(
              data : JSON.parse(json)
              key  : key
            )
          catch err
            error = err

        callback(error, value)
      )
    else
      @backend.getItem(key).then((json)=>
        @unwrap(
          wrapped : JSON.parse(json)
          key     : key
        ) || null
      )


  # remove
  # ------
  # Remove data for key
  #
  # **key** : key to remove
  # **callback**: optional callback
  remove : (args = {})->
    {callback} = args
    key = @buildKey(args)
    @backend.removeItem(key, callback)


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
    {callback} = args

    if callback
      @keys(
        callback : (error, keys)->
          value = if (!error and keys)
            keys.length
          else
            null

          callback(error, value)
      )
    else
      @keys().then((keys)->
        keys.length
      )


  # keys
  # ----
  # return all the keys
  #
  # **callback**: optional callback
  keys : (args = {})->
    @backend.getAllKeys(args.callback)


module.exports = AsyncStorage
