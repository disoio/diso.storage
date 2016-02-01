# Local dependencies
# ------------------
# [MemoryStorage](./MemoryStorage.html)
# [LocalStorage](./LocalStorage.html)
# [LocalForage](./LocalForage.html)
# [AsyncStorage](./AsyncStorage.html)
MemoryStorage = require('./MemoryStorage')
LocalStorage  = require('./LocalStorage')
LocalForage   = require('./LocalForage')
AsyncStorage  = require('./AsyncStorage')

backends = [
  {
    props   : ['getItem', 'setItem', 'removeItem', 'clear', 'keys', 'length', 'iterate']
    backend : LocalForage
  }
  {
    props   : ['getItem', 'setItem', 'removeItem', 'clear', 'getAllKeys']
    backend : AsyncStorage
  }
  {
    props   : ['getItem', 'setItem', 'removeItem', 'clear', 'key', 'length']
    backend : LocalStorage
  }
]

create = (args)->
  {backend} = args

  unless backend
    throw new Error('missing backend arg')

  for b in backends
    has_all_props = b.props.every((p)->
      (p of backend)
    )

    if has_all_props
      return new b.backend(
        backend : backend
      )

  new MemoryStorage(
    backend : backend
  )

module.exports = {
  MemoryStorage : MemoryStorage
  LocalStorage  : LocalStorage
  LocalForage   : LocalForage
  AsyncStorage  : AsyncStorage
  create        : create
}
