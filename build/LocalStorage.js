(function() {
  var BaseStorage, LocalStorage,
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  BaseStorage = require('./BaseStorage');

  LocalStorage = (function(superClass) {
    extend(LocalStorage, superClass);

    function LocalStorage(args) {
      if (args == null) {
        args = {};
      }
      this.localStorage = args.localStorage || localStorage;
    }

    LocalStorage.prototype.set = function(args) {
      var data, json, key, wrapped;
      data = args.data;
      key = this.buildKey(args);
      wrapped = this.wrap(args);
      json = JSON.stringify(wrapped);
      return this.localStorage.setItem(key, json);
    };

    LocalStorage.prototype.get = function(args) {
      var json, key;
      key = this.buildKey(args);
      json = this.localStorage.getItem(key);
      if (json) {
        return this.unwrap({
          wrapped: JSON.parse(json),
          key: key
        });
      } else {
        return null;
      }
    };

    LocalStorage.prototype.remove = function(args) {
      var key;
      key = this.buildKey(args);
      return this.localStorage.removeItem(key);
    };

    LocalStorage.prototype.clear = function() {
      return this.localStorage.clear();
    };

    LocalStorage.prototype.length = function() {
      return this.localStorage.length;
    };

    return LocalStorage;

  })(BaseStorage);

  module.exports = LocalStorage;

}).call(this);
