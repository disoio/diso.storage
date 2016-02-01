now = ()->
  (new Date()).getTime()

# BaseStorage
# ===========
# Parent class that provides expiry, namespacing, util methods
class BaseStorage
  # constructor
  # -----------
  # *backend*   : backend used by storage engine
  # *ttl*       : global ttl for items this storage
  # *namespace* : starting namespace for this storage
  constructor : (args = {})->
    unless ('backend' of args)
      throw new Error('Must pass backend to to storage constructor')
    @backend = args.backend

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
  buildKey : (args = {})->
    unless ('key' of args)
      throw new Error('Missing key arg')

    key = args.key

    namespace = @namespace || ''
    if ('namespace' of args)
      namespace = args.namespace

    if (namespace.length > 0)
      namespace = namespace + ':'

    "#{namespace}#{key}"


  # wrap
  # ----
  # **data** : data to wrap
  # *ttl*    : override global ttl
  wrap : (args = {})->
    unless ('data' of args)
      throw new Error('Missing data arg')

    {data, ttl} = args

    {
      data    : data
      expires : @_expires(ttl)
    }


  # unwrap
  # ------
  # **data** : wrapped data
  # **key**  : key
  unwrap : (args = {})->
    for arg in ['key', 'data']
      unless (arg of args)
        throw new Error("Missing arg: #{arg}")

    {data, key} = args
    expires = data.expires
    if (expires and (expires <= now()))
      @remove(args)
      null
    else
      data.data


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


module.exports = BaseStorage
