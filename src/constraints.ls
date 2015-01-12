/*
constraint.satisfied takes a partial assignment of variables to values
and returns true, false, or void.

It should return false whenever sufficient variables
have been assigned values to make the constraint false.

It should return true if it is already satisfied or if there
remains the possibility of it being satisfied under
future assignments.

Currently a constraint can only ask, "Does this variable have
this value?". Support for "Which values does this variable
have?" will be added later, but should be used sparingly,
since the solver can do propogation faster if it knows
what values will require re-evaluation of the constraint.

In the future, the assignments variable will have a propagate function,
which the constraint should call whenever the partial assignment
constrains the values of one of the remaining unassigned variables.
It can be called multiple times for multiple variables.
Generally, each variable will be passed to either
has-assignment, propagate, or neither, but not both.
The constraint solver will automatically detect when a propagation
of a variable narrows its possible values to the empty set.
*/
at-most-one = (variables) ->
  satisfied: (assignments) ->
    at-least-one = false
    for variable in variables.slice(0, -1)
      if assignments.has-assignment(variable, 1)
        if at-least-one
          return false
        at-least-one = true
    if not at-least-one
      return true
    return not assignments.has-assignment(variables.slice(-1)[0], 1)
  at-most-one: variables

exactly-one = (variables) ->
  satisfied: (assignments) ->
    at-least-one = false
    all-known = true
    for variable in variables
      if assignments.has-assignment(variable, 1)
        if at-least-one
          return false
        at-least-one = true
      else if all-known && not assignments.has-assignment(variable, 0)
        all-known = false
    return not all-known || at-least-one
  exactly-one: variables

module.exports = do
  atMostOne: at-most-one
  exactlyOne: exactly-one
