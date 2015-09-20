# Local dependencies
# ------------------
# [MemoryStorage](./MemoryStorage.html)
# [LocalStorage](./LocalStorage.html)
MemoryStorage = require('./MemoryStorage')
LocalStorage  = require('./LocalStorage')

module.exports = {
  Memory : MemoryStorage
  Local  : LocalStorage
}
