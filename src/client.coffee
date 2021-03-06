diff = require "diff"
cycle = require "cycle"
module.exports = client: ({snap,ask,timeout,util}) ->
  snap.hookIn (obj) ->
    if (val = obj.state.obj)?
      delete obj.state.obj
      if val instanceof Error
        val = val.toString()
      else
        val = cycle.decycle(val)
      obj.value = val
      if (oldState = obj.oldState).set
        changes = obj.diff = diff.diffJson(oldState.value, val)
        if changes.length > 1 or (
              changes.length == 1 and (
                (tmp = changes[0]).added or tmp.removed
              )
            )
          throw obj
        else
          obj.success = true
      else
        if util.isString(val)
          obj.question = val
        else
          obj.question = JSON.stringify(val, null, 2)
        ask(obj)