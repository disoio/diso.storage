now = ()->
  (new Date()).getTime()

# BaseStorage
# ===========
# Parent class extended by MemoryStorage and LocalStorage
# that provides expiry and namespacing
class BaseStorage
  # constructor
  # -----------
  # *ttl*       : global ttl for items this storage
  # *namespace* : starting namespace for this storage
  constructor : (args = {})->
    @ttl = args.ttl

    if ('namespace' of args)
      @namespace = args.namespace


  # setNamespace
  # ------------
  # **namespace** : new namespace
  setNamespace : (namespace)->
    @namespace = namespace


  # buildKey
  # --------
  # **key**     : suffix key to build off
  # *namespace* : key namespace
  buildKey : (args)->
    key = args.key

    namespace = @namespace || ''
    if ('namespace' of args)
      namespace = args.namespace

    if (namespace.length > 0)
      namespace = namespace + ':'

    "#{namespace}#{key}"


  # _expires
  # -------
  # *ttl* : override global ttl
  _expires : (ttl)->
    unless (ttl > 0)
      ttl = @ttl

    if (ttl > 0)
      now() + ttl
    else
      null


  # wrap
  # ----
  # **data** : data to wrap
  # *ttl*    : override global ttl
  wrap : (args)->
    {data, ttl} = args

    {
      data    : data
      expires : @_expires(ttl)
    }


  # unwrap
  # ------
  # **wrapped** : wrapped data
  # **key**     : key
  unwrap : (args)->
    {wrapped, key} = args
    expires = wrapped.expires
    if (expires and (expires <= now()))
      @remove(args)
      null
    else
      wrapped.data

module.exports = BaseStorage
