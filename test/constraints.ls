require! assert

require! \../lib/constraints

class Assignments
  (@assignments) ->
    @reads = {}
  hasAssignment: (variable, value) ->
    if not @reads[variable]
      @reads[variable] = []
    @reads[variable].push value
    @assignments[variable] == value

describe \at-most-one -> ``it``
  assert-reads = (assignments, expected) ->
    expanded-expected = {}
    for k,v of expected
      expanded-expected[k] = [v]
    assert.deepEqual assignments.reads, expanded-expected
  .. 'should return true for an empty collection of variables, without checking values' ->
    rule = constraints.at-most-one([])
    assert rule.satisfied(void), \satisfied
  .. 'should return true for a singleton collection, without checking values' ->
    rule = constraints.at-most-one(<[variable]>)
    assert rule.satisfied(void), \satisfied
  .. 'should return true for an empty assignment, reading all but one variable' ->
    rule = constraints.at-most-one(<[one two]>)
    assignments = new Assignments({})
    assert rule.satisfied(assignments), \satisfied
    assert-reads assignments, {one: 1}
  .. 'should return true when one variable is true, reading the second variable' ->
    rule = constraints.at-most-one(<[one two]>)
    assignments = new Assignments({one: 1})
    assert rule.satisfied(assignments), \satisfied
    assert-reads assignments, {one: 1, two: 1}
  .. 'should return true when one variable is false, skipping the last variable' ->
    rule = constraints.at-most-one(<[one two]>)
    assignments = new Assignments({one: 0})
    assert rule.satisfied(assignments), \satisfied
    assert-reads assignments, {one: 1}
  .. 'should return false when two variables are true' ->
    rule = constraints.at-most-one(<[one two]>)
    assignments = new Assignments({one: 1, two: 1})
    assert.equal rule.satisfied(assignments), false
    assert-reads assignments, {one: 1, two: 1}
  .. 'should return false when two variables are true, skipping the remaining variables' ->
    rule = constraints.at-most-one(<[one two three four]>)
    assignments = new Assignments({one: 1, two: 1})
    assert.equal rule.satisfied(assignments), false
    assert-reads assignments, {one: 1, two: 1}
  .. 'should return false when the last two variables are true' ->
    rule = constraints.at-most-one(<[one two three four]>)
    assignments = new Assignments({three: 1, four: 1})
    assert.equal rule.satisfied(assignments), false
    assert-reads assignments, {one: 1, two: 1, three: 1, four: 1}

describe \exactly-one -> ``it``
  .. 'should return false with zero variables' ->
    rule = constraints.exactly-one([])
    assert not rule.satisfied(void), \not-satisfied
  .. 'should return true with one true variable' ->
    rule = constraints.exactly-one(<[one]>)
    assignments = new Assignments({one: 1})
    assert rule.satisfied(assignments), \satisfied
    assert.deepEqual assignments.reads, {one: [1]}
  .. 'should return false with one false variable' ->
    rule = constraints.exactly-one(<[one]>)
    assignments = new Assignments({one: 0})
    assert not rule.satisfied(assignments), \not-satisfied
    assert.deepEqual assignments.reads, {one: [1,0]}
  .. 'should return true with one unknown variable' ->
    rule = constraints.exactly-one(<[one]>)
    assignments = new Assignments({})
    assert rule.satisfied(assignments), \satisfied
    assert.deepEqual assignments.reads, {one: [1,0]}
  .. 'should return false with two true variables' ->
    rule = constraints.exactly-one(<[one two]>)
    assignments = new Assignments({one: 1, two: 1})
    assert not rule.satisfied(assignments), \not-satisfied
    assert.deepEqual assignments.reads, {one: [1], two: [1]}
  .. 'should return true with one true and one false variable' ->
    rule = constraints.exactly-one(<[one two]>)
    assignments = new Assignments({one: 1, two: 0})
    assert rule.satisfied(assignments), \satisfied
    assert.deepEqual assignments.reads, {one: [1], two: [1,0]}
  .. 'should return true with one true and one unknown variable' ->
    rule = constraints.exactly-one(<[one two]>)
    assignments = new Assignments({one: 1})
    assert rule.satisfied(assignments), \satisfied
    assert.deepEqual assignments.reads, {one: [1], two: [1,0]}
  .. 'should return false with two false variables' ->
    rule = constraints.exactly-one(<[one two]>)
    assignments = new Assignments({one: 0, two: 0})
    assert not rule.satisfied(assignments), \not-satisfied
    assert.deepEqual assignments.reads, {one: [1,0], two: [1,0]}
  .. 'should return true with one false and one unknown variable' ->
    rule = constraints.exactly-one(<[one two]>)
    assignments = new Assignments({one: 0})
    assert rule.satisfied(assignments), \satisfied
    assert.deepEqual assignments.reads, {one: [1,0], two: [1,0]}
  .. 'should return true with two unknown variables' ->
    rule = constraints.exactly-one(<[one two]>)
    assignments = new Assignments({})
    assert rule.satisfied(assignments), \satisfied
    assert.deepEqual assignments.reads, {one: [1,0], two: [1]}
  .. 'should return true with the last one true' ->
    rule = constraints.exactly-one(<[one two three four five]>)
    assignments = new Assignments({two: 0, five: 1})
    assert rule.satisfied(assignments), \satisfied
    assert.deepEqual assignments.reads, {one: [1,0], two: [1], three: [1], four: [1], five: [1]}
  .. 'should return false with the ends true' ->
    rule = constraints.exactly-one(<[one two three four five]>)
    assignments = new Assignments({one: 1, five: 1})
    assert not rule.satisfied(assignments), \not-satisfied
    assert.deepEqual assignments.reads, {one: [1], two: [1,0], three: [1], four: [1], five: [1]}
  .. 'should skip non-trues once it sees at least one unknown' ->
    rule = constraints.exactly-one(<[one two three four five]>)
    assignments = new Assignments({one: 1})
    assert rule.satisfied(assignments), \satisfied
    assert.deepEqual assignments.reads, {one: [1], two: [1,0], three: [1], four: [1], five: [1]}

