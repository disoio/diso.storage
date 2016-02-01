(function() {
  var BaseStorage, LocalForage,
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  BaseStorage = require('./BaseStorage');

  LocalForage = (function(superClass) {
    extend(LocalForage, superClass);

    function LocalForage() {
      return LocalForage.__super__.constructor.apply(this, arguments);
    }

    LocalForage.prototype.set = function(args) {
      var callback, error, key, value;
      if (args == null) {
        args = {};
      }
      callback = args.callback;
      try {
        key = this.buildKey(args);
        value = this.wrap(args);
        return this.backend.setItem(key, value, callback);
      } catch (_error) {
        error = _error;
        if (callback) {
          return callback(error, null);
        } else {
          return new Promise(function(reject, resolve) {
            return reject(error);
          });
        }
      }
    };

    LocalForage.prototype.get = function(args) {
      var callback, key;
      if (args == null) {
        args = {};
      }
      callback = args.callback;
      key = this.buildKey(args);
      if (callback) {
        return this.backend.getItem(key, (function(_this) {
          return function(error, value) {
            var err;
            if (value && !error) {
              try {
                value = _this.unwrap({
                  data: value,
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
          return function(value) {
            return _this.unwrap({
              data: value,
              key: key
            }) || null;
          };
        })(this));
      }
    };

    LocalForage.prototype.remove = function(args) {
      var key;
      if (args == null) {
        args = {};
      }
      key = this.buildKey(args);
      return this.backend.removeItem(key, args.callback);
    };

    LocalForage.prototype.clear = function(args) {
      if (args == null) {
        args = {};
      }
      return this.backend.clear(args.callback);
    };

    LocalForage.prototype.length = function(args) {
      if (args == null) {
        args = {};
      }
      return this.backend.length(args.callback);
    };

    LocalForage.prototype.keys = function(args) {
      if (args == null) {
        args = {};
      }
      return this.backend.keys(args.callback);
    };

    return LocalForage;

  })(BaseStorage);

  module.exports = LocalForage;

}).call(this);
