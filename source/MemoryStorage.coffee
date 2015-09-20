# Local dependencies
# ------------------
# [BaseStorage](./BaseStorage.html)
BaseStorage = require('./BaseStorage')


# MemoryStorage
# =============
# naive in memory storage

class MemoryStorage extends BaseStorage
  constructor : (args = {})->
    super
    @data = {}


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
    @data[key] = wrapped


  # get
  # ---
  # Get data for key
  #
  # **key** : key to get
  get : (args)->
    key = @buildKey(args)

    unless (key of @data)
      return null

    @unwrap(
      wrapped : @data[key]
      key     : key
    )


  # remove
  # ------
  # Remove data for key
  #
  # **key** : key to remove
  remove : (args)->
    key = @buildKey(args)
    delete @data[key]


  # clear
  # ------
  # clear all the data
  #
  # **key** : key to remove
  clear : ()->
    @data = {}


  # length
  # ------
  # count of the number of entries
  length : ()->
    Object.keys(@data).length

module.exports = MemoryStorage
