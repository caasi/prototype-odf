utils =
  namespace: ->
    r = it.toLowerCase!split(':')reverse!
    namespace: r.1
    name:      r.0
module.exports = utils
