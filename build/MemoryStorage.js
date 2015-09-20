(function() {
  var BaseStorage, MemoryStorage,
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  BaseStorage = require('./BaseStorage');

  MemoryStorage = (function(superClass) {
    extend(MemoryStorage, superClass);

    function MemoryStorage(args) {
      if (args == null) {
        args = {};
      }
      MemoryStorage.__super__.constructor.apply(this, arguments);
      this.data = {};
    }

    MemoryStorage.prototype.set = function(args) {
      var data, key, wrapped;
      data = args.data;
      key = this.buildKey(args);
      wrapped = this.wrap(args);
      return this.data[key] = wrapped;
    };

    MemoryStorage.prototype.get = function(args) {
      var key;
      key = this.buildKey(args);
      if (!(key in this.data)) {
        return null;
      }
      return this.unwrap({
        wrapped: this.data[key],
        key: key
      });
    };

    MemoryStorage.prototype.remove = function(args) {
      var key;
      key = this.buildKey(args);
      return delete this.data[key];
    };

    MemoryStorage.prototype.clear = function() {
      return this.data = {};
    };

    MemoryStorage.prototype.length = function() {
      return Object.keys(this.data).length;
    };

    return MemoryStorage;

  })(BaseStorage);

  module.exports = MemoryStorage;

}).call(this);
