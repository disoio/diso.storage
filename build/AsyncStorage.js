(function() {
  var AsyncStorage, BaseStorage,
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  BaseStorage = require('./BaseStorage');

  AsyncStorage = (function(superClass) {
    extend(AsyncStorage, superClass);

    function AsyncStorage() {
      return AsyncStorage.__super__.constructor.apply(this, arguments);
    }

    AsyncStorage.prototype.set = function(args) {
      var callback, error, json, key, wrapped;
      if (args == null) {
        args = {};
      }
      callback = args.callback;
      try {
        key = this.buildKey(args);
        wrapped = this.wrap(args);
        json = JSON.stringify(wrapped);
      } catch (_error) {
        error = _error;
        if (callback) {
          callback(error, null);
          return;
        } else {
          return new Promise(function(reject, resolve) {
            return reject(error);
          });
        }
      }
      return this.backend.setItem(key, json, callback);
    };

    AsyncStorage.prototype.get = function(args) {
      var callback, key;
      if (args == null) {
        args = {};
      }
      callback = args.callback;
      key = this.buildKey(args);
      if (callback) {
        return this.backend.getItem(key, (function(_this) {
          return function(error, json) {
            var err, value;
            value = null;
            if (!error && json) {
              try {
                value = _this.unwrap({
                  data: JSON.parse(json),
                  key: key
                });
              } catch (_error) {
                err = _error;
                error = err;
              }
            }
            return callback(error, value);
          };
        })(this));
      } else {
        return this.backend.getItem(key).then((function(_this) {
          return function(json) {
            return _this.unwrap({
              wrapped: JSON.parse(json),
              key: key
            }) || null;
          };
        })(this));
      }
    };

    AsyncStorage.prototype.remove = function(args) {
      var callback, key;
      if (args == null) {
        args = {};
      }
      callback = args.callback;
      key = this.buildKey(args);
      return this.backend.removeItem(key, callback);
    };

    AsyncStorage.prototype.clear = function(args) {
      if (args == null) {
        args = {};
      }
      return this.backend.clear(args.callback);
    };

    AsyncStorage.prototype.length = function(args) {
      var callback;
      if (args == null) {
        args = {};
      }
      callback = args.callback;
      if (callback) {
        return this.keys({
          callback: function(error, keys) {
            var value;
            value = !error && keys ? keys.length : null;
            return callback(error, value);
          }
        });
      } else {
        return this.keys().then(function(keys) {
          return keys.length;
        });
      }
    };

    AsyncStorage.prototype.keys = function(args) {
      if (args == null) {
        args = {};
      }
      return this.backend.getAllKeys(args.callback);
    };

    return AsyncStorage;

  })(BaseStorage);

  module.exports = AsyncStorage;

}).call(this);
