{
  any
} = require \prelude-ls
assert = require \assert
deep-equal = require \deep-equal
n-queens = require \../../lib/examples/n-queens

describe \sizes -> ``it``
  .. \1 ->
    problem = n-queens.define 1
    assert.equal 1, problem.variables.length
    assert.equal \column-1, problem.variables[0]
    for constraint in problem.constraints
      assert.deepEqual [[1,1]], constraint.at-most-one
  .. \3 ->
    problem = n-queens.define 3
    assert.deepEqual <[column-1 column-2 column-3]>, problem.variables
    assert.equal 13, problem.constraints.length
    has = (cells) ->
      predicate = (c) ->
        deep-equal(cells, c.at-most-one)
      any predicate, problem.constraints
    assert \row-1, has([[1,1],[1,2],[1,3]])
    assert \row-2, has([[2,1],[2,2],[2,3]])
    assert \row-3, has([[3,1],[3,2],[3,3]])
    assert \forward-diag-2, has([[1,1]])
    assert \forward-diag-3, has([[2,1],[1,2]])
    assert \forward-diag-4, has([[3,1],[2,2],[1,3]])
    assert \forward-diag-5, has([[3,2],[2,3]])
    assert \forward-diag-6, has([[3,3]])
    assert \backward-diag--2, has([[1,3]])
    assert \backward-diag--1, has([[1,2],[2,3]])
    assert \backward-diag-0, has([[1,1],[2,2],[3,3]])
    assert \backward-diag-1, has([[2,1],[3,2]])
    assert \backward-diag-2, has([[3,1]])

describe \satisfaction
