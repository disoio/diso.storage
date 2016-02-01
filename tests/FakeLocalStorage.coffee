class LocalStorage
  constructor : ()->
    @store = {}

  setItem : (key, value)->
    @store[key] = value

  getItem : (key)->
    @store[key]

  removeItem : (key)->
    delete @store[key]

  clear : ()->
    @store = {}

  key : (i)->
    Object.keys(@store)[i]

Object.defineProperty(LocalStorage.prototype, 'length', {
  get : ()->
    Object.keys(@store).length
})

module.exports = LocalStorage
