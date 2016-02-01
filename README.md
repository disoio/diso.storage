# diso.storage
Client side storage supporting [AsyncStorage](https://facebook.github.io/react-native/docs/asyncstorage.html),  [LocalForage](http://mozilla.github.io/localForage/),
[LocalStorage](https://developer.mozilla.org/en-US/docs/Web/API/Storage/LocalStorage) as well as an in-memory store.

## API

Methods are named-arg/keyword based. They all accept an optional callback. If the callback is passed, that is used to pass error/value otherwise an [ES6 Promise](https://developer.mozilla.org/docs/Web/JavaScript/Reference/Global_Objects/Promise) is returned.

* **constructor({backend, ttl?, namespace?})**
* **get({key, namespace?, callback?})**
* **set({key, data, ttl?, namespace?, callback?})**
* **remove(key, namespace?, callback?)**
* **clear(callback?)**
* **length(callback?)**
* **keys(callback?)**

## Example
```javascript
var Storage = require('diso.storage');
var LocalForage = require('localforage');
var AsyncStorage = require('react').AsyncStorage;

var memoryStore = Storage.create({
  backend   : {}
  ttl       : 1000 * 60 * 60 * 24, // 24 hour ttl
  namespace : 'mystuff'
});

var forageStore = Storage.create({
  backend : LocalForage
});

var asyncStore = new Storage.create({
  backend : AsyncStorage
});

memoryStorage.set({
  key  : 'wow',
  data : {
    jonk : 'honk'
  }
}).then({
  memoryStorage.get({
    key : 'wow',
    callback : function (error, data) {
      Assert.equal(data.jonk, 'honk');
    }
  })
});

```

## Comparing the underlying APIs
Both AsyncStorage and LocalForage APIs are async and support both callback and promise APIs.

Both have the same 4 core API methods, all with identical signatures: getItem, setItem, removeItem, clear.

These are exposed as: *get*, *set*, *remove*, and *clear*.

Additionally they have *keys* (array of keys) and *length* (number of keys) methods that delegate to the supporting backends.

MemoryStorage and LocalStorage are both sync, but are wrapped as promise/callback apis using [cbop](https://github.com/stephenhandley/cbop) and support the same methods as above.

AsyncStorage has multi functions that operate on arrays of values, but those aren't currently supported.


### LocalForage
* **getItem(key, callback?)**
* **setItem(key, value, callback?)**
* **removeItem(key, callback?)**
* **clear(callback?)**
* _keys(callback?)_
* length(callback?)
* key(keyIndex, callback?)
* iterate(iteratorCallback, successCallback?)

### AsyncStorage
* **getItem(key, callback?)**
* **setItem(key, value, callback?)**
* **removeItem(key, callback?)**
* **clear(callback?)**
* _getAllKeys(callback?)_
* mergeItem(key, value, callback?)
* flushGetRequests()
* multiGet(keys, callback?)
* multiSet(keyValuePairs, callback?)
* multiRemove(keys, callback?)
* multiMerge(keyValuePairs, callback?)

## Notes
https://blog.mozilla.org/tglek/2012/02/22/psa-dom-local-storage-considered-harmful/
