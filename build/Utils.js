(function() {
  module.exports = {
    now: function() {
      return (new Date()).getTime();
    },
    cbop: function(args) {
      var callback, error, value;
      error = args.error, value = args.value, callback = args.callback;
      if (callback) {
        return callback(error, value);
      } else {
        return new Promise(function(reject, resolve) {
          if (error) {
            return reject(error);
          } else {
            return resolve(value);
          }
        });
      }
    }
  };

}).call(this);
