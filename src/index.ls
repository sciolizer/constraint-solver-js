{
  all,
  filter
} = require 'prelude-ls'

/*
solve :: Solver -> IO { assignments: { ... } }* -- returns all solutions as a generator
*/
class Solver
  ->
    @variables = {}
    @constraints = []
    @assignments = {}
  add-variable: (name, values) ->
    if values?.constructor != Array
      throw new Error('values must be a list')
    @variables[name] = values
  add-constraint: (constraint) ->
    @constraints.push constraint
  get-variable: (name) -> @assignments[name]
  solve: ->
    solve(@)

solve = (self) ->
  if Object.keys(self.variables).length == 0
    return true
  variable = random-key(self.variables)
  candidates = self.variables[variable]
  delete self.variables[variable]
  candidates-copy = candidates.slice(0)
  #shuffle-in-place(candidates-copy)
  for candidate in candidates-copy
    self.assignments[variable] = candidate
    constraint-test = (constraint) ->
      satisfaction = constraint.satisfied(self.assignments)
      satisfaction != false # void and true both mean continue
    acceptable = all constraint-test, self.constraints
    if acceptable
      ret = solve(self)
      if ret
        return true
    delete self.assignments[variable]
  self.variables[variable] = candidates # restore candidates
  false

random-key = (obj) ->
  keys = Object.keys obj
  keys[keys.length * Math.random() .<<. 0]

shuffle-in-place = (o) ->
    i = o.length
    while i
      j = Math.floor(Math.random() * i)
      i = i - 1
      x = o[i]
      o[i] = o[j]
      o[j] = x
    o

module.exports = { random-key, shuffle-in-place, Solver }
