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

    BaseStorage.prototype.wrap = function(args) {
      var data, ttl;
      data = args.data, ttl = args.ttl;
      return {
        data: data,
        expires: this._expires(ttl)
      };
    };

    BaseStorage.prototype.unwrap = function(args) {
      var expires, key, wrapped;
      wrapped = args.wrapped, key = args.key;
      expires = wrapped.expires;
      if (expires && (expires <= now())) {
        this.remove(args);
        return null;
      } else {
        return wrapped.data;
      }
    };

    return BaseStorage;

  })();

  module.exports = BaseStorage;

}).call(this);
