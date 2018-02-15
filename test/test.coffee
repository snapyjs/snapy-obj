{test, snap:snaphook, ask} = require "snapy"

genState = (val, set, oldVal) =>
  state:
    obj: val
  oldState:
    set: set
    value: oldVal

test (snap) =>
  # old state equals new state
  snap promise: snaphook genState true,true,true
test (snap) =>
  # old state diffs from new state
  snap promise: snaphook genState true,true,false
test (snap) =>
  # should have a proper question
  # and a save state when no oldState is given
  tmp = ask._chain
  ask._chain = []
  snap promise: snaphook(genState(true)).then (o) =>
    ask._chain = tmp
    return o
