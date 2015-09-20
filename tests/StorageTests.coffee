# Core Dependencies
# =================
Assert = require('assert')

# NPM Dependencies
# ================
#[Sinon]()
Sinon  = require('sinon')

MemoryStorage = require('../build/MemoryStorage')
LocalStorage  = require('../build/LocalStorage')


fakeLocalStorage = ()->
  localStorage = {
    store : {}

    setItem : (key, value)->
      @store[key] = value

    getItem : (key)->
      @store[key]

    removeItem : (key)->
      delete @store[key]

    clear : ()->
      @store = {}
  }

  Object.defineProperty(localStorage, 'length', {
    get : ()->
      Object.keys(@store).length
  })

  localStorage


setGetRemoveClear = (storage)->
  key  = 'donkey'
  data = {
    zebra : 'zonkey'
    horse : 'honkey'
  }

  empty = storage.get(key : key)
  Assert.equal(empty, null)

  storage.set(
    key  : key
    data : data
  )
  full = storage.get(key : key)
  Assert.deepEqual(full, data)

  storage.remove(key : key)
  empty = storage.get(key : key)
  Assert.equal(empty, null)

  keys = ['x', 'y', 'z']
  for k in keys
    storage.set(
      key  : k
      data : k
    )

  Assert.equal(storage.length(), keys.length)
  storage.clear()
  Assert.equal(storage.length(), 0)


module.exports = {
  "Storage should" : {
    "set, get, remove, clear" : ()->
      storage = new MemoryStorage()
      setGetRemoveClear(storage)

      storage = new LocalStorage(
        localStorage : fakeLocalStorage()
      )
      setGetRemoveClear(storage)

    "should handle namespacing" : ()->
      storage = new MemoryStorage(
        namespace : 'start'
      )

      key = 'wow'

      storage.set(
        key  : key
        data : 'omg'
      )
      Assert.equal(storage.length(), 1)

      storage.setNamespace('next')
      storage.set(
        key  : key
        data : 'zomg'
      )

      storage.set(
        namespace : 'other'
        key       : key
        data      : 'woooooa'
      )

      Assert.equal(storage.length(), 3)

      storage.remove(key : key)
      Assert.equal(storage.length(), 2)

      storage.setNamespace('start')
      storage.remove(key : key)
      Assert.equal(storage.length(), 1)

      storage.setNamespace(null)
      woooooa = storage.get(
        key : 'other:wow'
      )
      Assert.equal(woooooa, 'woooooa')

    "should handle ttl" : (done)->
      storage = new MemoryStorage(
        ttl : 100
      )

      key  = 'timingout'
      data = 12345

      checkWaitThenCheckAgain = (args)->
        {callback, timeout} = args

        count = storage.get(
          key : key
        )
        Assert.equal(count, data)

        cb = ()->
          count = storage.get(
            key : key
          )
          Assert.equal(count, null)
          callback()

        setTimeout(cb, timeout)

      storage.set(
        key  : key
        data : data
      )

      checkWaitThenCheckAgain(
        timeout  : 150
        callback : ()->
          storage.set(
            key  : key
            data : data
            ttl  : 30
          )

          checkWaitThenCheckAgain(
            timeout  : 45
            callback : done
          )
      )
  }
}
