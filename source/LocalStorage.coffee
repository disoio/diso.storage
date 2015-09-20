# Local dependencies
# ------------------
# [BaseStorage](./BaseStorage.html)
BaseStorage = require('./BaseStorage')


# LocalStorage
# ============
class LocalStorage extends BaseStorage
  constructor : (args = {})->
    @localStorage = args.localStorage || localStorage


  # set
  # ---
  # Set data for key
  #
  # **key** : key to set
  # **data** : data to set
  set : (args)->
    data = args.data
    key  = @buildKey(args)

    wrapped = @wrap(args)
    json = JSON.stringify(wrapped)
    @localStorage.setItem(key, json)


  # get
  # ---
  # Get data for key
  #
  # **key** : key to get
  get : (args)->
    key  = @buildKey(args)
    json = @localStorage.getItem(key)

    if json
      @unwrap(
        wrapped : JSON.parse(json)
        key     : key
      )
    else
      null


  # remove
  # ------
  # Remove data for key
  #
  # **key** : key to remove
  remove : (args)->
    key = @buildKey(args)
    @localStorage.removeItem(key)


  # clear
  # ------
  # clear all the data
  #
  # **key** : key to remove
  clear : ()->
    @localStorage.clear()


  # length
  # ------
  # count of the number of entries
  length : ()->
    @localStorage.length

module.exports = LocalStorage
