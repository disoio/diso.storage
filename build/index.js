(function() {
  var AsyncStorage, LocalForage, LocalStorage, MemoryStorage, backends, create;

  MemoryStorage = require('./MemoryStorage');

  LocalStorage = require('./LocalStorage');

  LocalForage = require('./LocalForage');

  AsyncStorage = require('./AsyncStorage');

  backends = [
    {
      props: ['getItem', 'setItem', 'removeItem', 'clear', 'keys', 'length', 'iterate'],
      backend: LocalForage
    }, {
      props: ['getItem', 'setItem', 'removeItem', 'clear', 'getAllKeys'],
      backend: AsyncStorage
    }, {
      props: ['getItem', 'setItem', 'removeItem', 'clear', 'key', 'length'],
      backend: LocalStorage
    }
  ];

  create = function(args) {
    var b, backend, has_all_props, i, len;
    backend = args.backend;
    if (!backend) {
      throw new Error('missing backend arg');
    }
    for (i = 0, len = backends.length; i < len; i++) {
      b = backends[i];
      has_all_props = b.props.every(function(p) {
        return p in backend;
      });
      if (has_all_props) {
        return new b.backend({
          backend: backend
        });
      }
    }
    return new MemoryStorage({
      backend: backend
    });
  };

  module.exports = {
    MemoryStorage: MemoryStorage,
    LocalStorage: LocalStorage,
    LocalForage: LocalForage,
    AsyncStorage: AsyncStorage,
    create: create
  };

}).call(this);
