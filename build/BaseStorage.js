(function() {
  var BaseStorage, now;

  now = function() {
    return (new Date()).getTime();
  };

  BaseStorage = (function() {
    function BaseStorage(args) {
      if (args == null) {
        args = {};
      }
      if (!('backend' in args)) {
        throw new Error('Must pass backend to to storage constructor');
      }
      this.backend = args.backend;
      this.ttl = args.ttl;
      if ('namespace' in args) {
        this.namespace = args.namespace;
      }
    }

    BaseStorage.prototype.setNamespace = function(namespace) {
      return this.namespace = namespace;
    };

    BaseStorage.prototype.buildKey = function(args) {
      var key, namespace;
      if (args == null) {
        args = {};
      }
      if (!('key' in args)) {
        throw new Error('Missing key arg');
      }
      key = args.key;
      namespace = this.namespace || '';
      if ('namespace' in args) {
        namespace = args.namespace;
      }
      if (namespace.length > 0) {
        namespace = namespace + ':';
      }
      return "" + namespace + key;
    };

    BaseStorage.prototype.wrap = function(args) {
      var data, ttl;
      if (args == null) {
        args = {};
      }
      if (!('data' in args)) {
        throw new Error('Missing data arg');
      }
      data = args.data, ttl = args.ttl;
      return {
        data: data,
        expires: this._expires(ttl)
      };
    };

    BaseStorage.prototype.unwrap = function(args) {
      var arg, data, expires, i, key, len, ref;
      if (args == null) {
        args = {};
      }
      ref = ['key', 'data'];
      for (i = 0, len = ref.length; i < len; i++) {
        arg = ref[i];
        if (!(arg in args)) {
          throw new Error("Missing arg: " + arg);
        }
      }
      data = args.data, key = args.key;
      expires = data.expires;
      if (expires && (expires <= now())) {
        this.remove(args);
        return null;
      } else {
        return data.data;
      }
    };

    BaseStorage.prototype._expires = function(ttl) {
      if (!(ttl > 0)) {
        ttl = this.ttl;
      }
      if (ttl > 0) {
        return now() + ttl;
      } else {
        return null;
      }
    };

    return BaseStorage;

  })();

  module.exports = BaseStorage;

}).call(this);
