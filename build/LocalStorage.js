(function() {
  var BaseStorage, LocalStorage, cbop,
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  cbop = require('cbop');

  BaseStorage = require('./BaseStorage');

  LocalStorage = (function(superClass) {
    extend(LocalStorage, superClass);

    function LocalStorage() {
      return LocalStorage.__super__.constructor.apply(this, arguments);
    }

    LocalStorage.prototype.set = function(args) {
      var err, error, json, key, wrapped;
      if (args == null) {
        args = {};
      }
      error = (function() {
        try {
          key = this.buildKey(args);
          wrapped = this.wrap(args);
          json = JSON.stringify(wrapped);
          this.backend.setItem(key, json);
          return null;
        } catch (_error) {
          err = _error;
          return err;
        }
      }).call(this);
      return cbop({
        error: error,
        callback: args.callback
      });
    };

    LocalStorage.prototype.get = function(args) {
      var err, error, json, key, ref, value;
      if (args == null) {
        args = {};
      }
      ref = (function() {
        try {
          key = this.buildKey(args);
          json = this.backend.getItem(key);
          value = json ? this.unwrap({
            data: JSON.parse(json),
            key: key
          }) : null;
          return [null, value];
        } catch (_error) {
          err = _error;
          return [err, null];
        }
      }).call(this), error = ref[0], value = ref[1];
      return cbop({
        error: error,
        value: value,
        callback: args.callback
      });
    };

    LocalStorage.prototype.remove = function(args) {
      var err, error, key;
      if (args == null) {
        args = {};
      }
      error = (function() {
        try {
          key = this.buildKey(args);
          this.backend.removeItem(key);
          return null;
        } catch (_error) {
          err = _error;
          return err;
        }
      }).call(this);
      return cbop({
        error: error,
        callback: args.callback
      });
    };

    LocalStorage.prototype.clear = function(args) {
      var err, error;
      if (args == null) {
        args = {};
      }
      error = (function() {
        try {
          this.backend.clear();
          return null;
        } catch (_error) {
          err = _error;
          return err;
        }
      }).call(this);
      return cbop({
        error: error,
        callback: args.callback
      });
    };

    LocalStorage.prototype.length = function(args) {
      var err, error, ref, value;
      if (args == null) {
        args = {};
      }
      ref = (function() {
        try {
          return [null, this.backend.length];
        } catch (_error) {
          err = _error;
          return [err, null];
        }
      }).call(this), error = ref[0], value = ref[1];
      return cbop({
        error: error,
        value: value,
        callback: args.callback
      });
    };

    LocalStorage.prototype.keys = function(args) {
      var err, error, i, keys, ref;
      if (args == null) {
        args = {};
      }
      ref = (function() {
        try {
          keys = (function() {
            var j, ref, results;
            results = [];
            for (i = j = 0, ref = this.backend.length; 0 <= ref ? j < ref : j > ref; i = 0 <= ref ? ++j : --j) {
              results.push(this.backend.key(i));
            }
            return results;
          }).call(this);
          return [null, keys];
        } catch (_error) {
          err = _error;
          return [err, null];
        }
      }).call(this), error = ref[0], keys = ref[1];
      return cbop({
        error: error,
        value: keys,
        callback: args.callback
      });
    };

    return LocalStorage;

  })(BaseStorage);

  module.exports = LocalStorage;

}).call(this);
