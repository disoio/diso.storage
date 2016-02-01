# Core Dependencies
# =================
Assert = require('assert')

# NPM Dependencies
# ================
#[Async]()
Async = require('async')

Storage = require('../source/index')

FakeLocalStorage = require('./FakeLocalStorage')
FakeAsyncStorage = require('./FakeAsyncStorage')
FakeLocalForage  = require('./FakeLocalForage')

lengthChecker = (storage)->
  (length)->
    (done)->
      storage.length(
        callback : (error, len)->
          Assert.equal(error, null)
          Assert.equal(len, length)
          done()
      )

# set in beforeEach
storages = null

module.exports = {
  "Storage should" : {
    beforeEach : ()->
      storages = [
        {}
        new FakeLocalStorage()
        new FakeLocalForage()
        # new FakeAsyncStorage()
      ].map((backend)->
        Storage.create(
          backend : backend
        )
      )

    "set, get, remove, clear" : (done)->
      setGetRemoveClear = (storage, callback)->
        key  = 'donkey'
        data = {
          zebra : 'zonkey'
          horse : 'honkey'
        }

        keys = ['x', 'y', 'z']

        initialGet = (done)->
          storage.get(
            key      : key
            callback : (error, value)->
              Assert.equal(value, null)
              Assert.equal(error, null)
              done(error)
          )

        set = (done)->
          storage.set(
            key      : key
            data     : data
            callback : (error)->
              Assert.equal(error, null)
              done(error)
          )

        nextGet = (done)->
          storage.get(
            key      : key
            callback : (error, value)->
              Assert.equal(error, null)
              Assert.deepEqual(value, data)
              done(error)
          )

        remove = (done)->
          storage.remove(
            key      : key
            callback : (error)->
              Assert.equal(error, null)
              done(error)
          )

        lastGet = (done)->
          storage.get(
            key      : key
            callback : (error, value)->
              Assert.equal(error, null)
              Assert.equal(error, null)
              done(error)
          )

        setMany = (done)->
          iter = (k, done)->
            storage.set(
              key  : k
              data : k
              callback : (error)->
                Assert.equal(error, null)
                done(error)
            )

          Async.eachSeries(keys, iter, done)

        clear = (done)->
          storage.clear(
            callback : done
          )

        lengthCheck = lengthChecker(storage)

        Async.series([
          initialGet,
          set,
          nextGet,
          remove,
          lastGet,
          setMany,
          lengthCheck(keys.length)
          clear,
          lengthCheck(0)
        ], callback)

      Async.eachSeries(storages, setGetRemoveClear, done)

    "should handle namespacing" : (done)->
      namespacery = (storage, callback)->
        storage.setNamespace('start')

        key = 'wow'

        set1 = (done)->
          storage.set(
            key      : key
            data     : 'omg'
            callback : done
          )

        set2 = (done)->
          storage.setNamespace('next')
          storage.set(
            key      : key
            data     : 'zomg'
            callback : done
          )

        set3 = (done)->
          storage.set(
            namespace : 'other'
            key       : key
            data      : 'woooooa'
            callback  : done
          )

        keys = (done)->
          storage.keys(
            callback : (error, keys)->
              Assert.deepEqual(keys, ['start:wow', 'next:wow', 'other:wow'])
              done(error)
          )

        remove1 = (done)->
          storage.remove(
            key      : key
            callback : done
          )

        remove2 = (done)->
          storage.setNamespace('start')
          storage.remove(
            key      : key
            callback : done
          )

        get = (done)->
          storage.setNamespace(null)
          storage.get(
            key      : 'other:wow'
            callback : (error, value)->
              Assert.equal(error, null)
              Assert.equal(value, 'woooooa')
              done(error)
          )

        lengthCheck = lengthChecker(storage)

        Async.series([
          set1
          lengthCheck(1)
          set2
          set3
          lengthCheck(3)
          keys
          remove1
          lengthCheck(2)
          remove2
          lengthCheck(1)
          get
        ], callback)

      Async.eachSeries(storages, namespacery, done)


    "should handle ttl" : (done)->
      ttlery = (storage, callback)->
        storage.ttl = 100

        key  = 'timingout'
        data = 12345

        getCheck = (expected)->
          (done)->
            storage.get(
              key      : key
              callback : (error, value)->
                Assert.equal(error, null)
                Assert.equal(value, expected)
                done(error)
            )

        wait = (duration)->
          (done)->
            setTimeout(done, duration)

        set1 = (done)->
          storage.set(
            key      : key
            data     : data
            callback : done
          )

        set2 = (done)->
          storage.set(
            key      : key
            data     : data
            ttl      : 30
            callback : done
          )

        Async.series([
          getCheck(null)
          set1
          wait(10)
          getCheck(data)
          wait(100)
          getCheck(null)
          set2
          wait(10)
          getCheck(data)
          wait(30)
          getCheck(null)
        ], done)

      Async.eachSeries(storages, ttlery, done)


    "should work with promises too" : (done)->
      key  = 'donkeys'
      key2 = 'donkeys2'
      data = {
        chonky : 'fonkey'
      }

      promisery = (storage, callback)->
        storage.set(
          key  : key
          data : data
        ).then(()->
          storage.get(
            key : key
          )
        ).then((value)->
          Assert.deepEqual(value, data)
        ).then(()->
          storage.set(
            key  : key2
            data : data
          )
        ).then(()->
          storage.length()
        ).then((length)->
          Assert.equal(length, 2)
        ).then(()->
          storage.keys()
        ).then((keys)->
          Assert.deepEqual(keys, ['donkeys', 'donkeys2'])
        ).then(()->
          storage.remove(
            key : 'donkeys'
          )
        ).then(()->
          storage.length()
        ).then((len)->
          Assert.equal(len, 1)
        ).then(()->
          storage.clear()
        ).then(()->
          storage.keys()
        ).then((keys)->
          Assert.deepEqual(keys, [])
        ).then(callback).catch(callback)

      Async.eachSeries(storages, promisery, done)
  }
}
