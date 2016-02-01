(function() {
  var BaseStorage, MemoryStorage, cbop,
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  cbop = require('cbop');

  BaseStorage = require('./BaseStorage');

  MemoryStorage = (function(superClass) {
    extend(MemoryStorage, superClass);

    function MemoryStorage() {
      return MemoryStorage.__super__.constructor.apply(this, arguments);
    }

    MemoryStorage.prototype.set = function(args) {
      var data, key, wrapped;
      if (args == null) {
        args = {};
      }
      data = args.data;
      key = this.buildKey(args);
      wrapped = this.wrap(args);
      this.backend[key] = wrapped;
      return cbop({
        error: null,
        callback: args.callback
      });
    };

    MemoryStorage.prototype.get = function(args) {
      var key, value;
      if (args == null) {
        args = {};
      }
      key = this.buildKey(args);
      value = key in this.backend ? this.unwrap({
        data: this.backend[key],
        key: key
      }) : null;
      return cbop({
        error: null,
        value: value,
        callback: args.callback
      });
    };

    MemoryStorage.prototype.remove = function(args) {
      var key;
      if (args == null) {
        args = {};
      }
      key = this.buildKey(args);
      delete this.backend[key];
      return cbop({
        error: null,
        callback: args.callback
      });
    };

    MemoryStorage.prototype.clear = function(args) {
      if (args == null) {
        args = {};
      }
      this.backend = {};
      return cbop({
        error: null,
        callback: args.callback
      });
    };

    MemoryStorage.prototype.length = function(args) {
      var value;
      if (args == null) {
        args = {};
      }
      value = Object.keys(this.backend).length;
      return cbop({
        error: null,
        value: value,
        callback: args.callback
      });
    };

    MemoryStorage.prototype.keys = function(args) {
      var keys;
      if (args == null) {
        args = {};
      }
      keys = Object.keys(this.backend);
      return cbop({
        error: null,
        value: keys,
        callback: args.callback
      });
    };

    return MemoryStorage;

  })(BaseStorage);

  module.exports = MemoryStorage;

}).call(this);
