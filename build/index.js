(function() {
  var LocalStorage, MemoryStorage;

  MemoryStorage = require('./MemoryStorage');

  LocalStorage = require('./LocalStorage');

  module.exports = {
    Memory: MemoryStorage,
    Local: LocalStorage
  };

}).call(this);
