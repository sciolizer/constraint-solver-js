assert = require \assert

cs = require '..'

describe \random-key -> ``it``
  .. 'should give me the only key on a singleton object' ->
    assert.equal \a, cs.random-key({a: \a})

describe \shuffle-in-place -> ``it``
  .. 'should change the empty list to the empty list' ->
    list = []
    cs.shuffle-in-place list
    assert.deepEqual list, []
  .. 'should keep a singleton list as a singleton list' ->
    list = [1]
    cs.shuffle-in-place list
    assert.deepEqual list, [1]
  .. 'should create all permutations of a double list' ->
    list = [1,2]
    cs.shuffle-in-place list
    while list[0] == 1
      cs.shuffle-in-place list
    assert.deepEqual [2,1], list
    while list[0] == 2
      cs.shuffle-in-place list
    assert.deepEqual [1,2], list

describe \solve -> ``it``
  .. 'should throw error if argument to add-variable is not a list' ->
    solver = new cs.Solver()
    try
      solver.add-variable \x, 3
      throw new Error("add-variable completed successfully when it shouldn't have")
    catch e
      assert.equal e.message, 'values must be a list'
  .. 'should make an assignment for a single variable' ->
    solver = new cs.Solver()
    solver.add-variable(\x, [3])
    assert.equal solver.solve(), true
    x = solver.get-variable(\x)
    assert.equal 3, x
  .. 'should fail if unsatisfiable' ->
    solver = new cs.Solver()
    solver.add-variable \x, [3]
    solver.add-constraint do
      satisfied: (.x != 3)
    assert.equal solver.solve(), false
  .. 'should pick the only satisfiable value' ->
    solver = new cs.Solver()
    solver.add-variable \x, [3, 4]
    solver.add-constraint do
      satisfied: (.x != 3)
    assert.equal solver.solve(), true
    assert.equal solver.get-variable(\x), 4
  .. 'should pick the only pair that works' ->
    solver = new cs.Solver()
    solver.add-variable \x [3, 4]
    solver.add-variable \y [5, 9]
    solver.add-constraint do
      satisfied: (assignments) ->
        if assignments.x == void || assignments.y == void
          void
        else
          assignments.x + assignments.y == 9
    assert.equal solver.solve(), true
    assert.equal solver.get-variable(\x), 4
    assert.equal solver.get-variable(\y), 5

describe \solve-queens -> ``it``
  solver = new cs.Solver()
  at-most-one = (row-col-pairs) ->
    satisfied: (assignments) ->
      is-void = false
      at-least-one = false
      for pair in row-col-pairs
        cell-value = assignments["column-" + pair[1]]
        if cell-value == void
          is-void = true
          continue
        else if cell-value == pair[0]
          if at-least-one
            return false
          else
            at-least-one = true
      if is-void then void else true
    at-most-one: row-col-pairs
  add-variables = (size) ->
    for column from 1 to size
      name = "column-" + column
      values = [row for row from 1 to size]
      solver.add-variable name, values
  add-row-constraints = (size) ->
    for row from 1 to size
      column-cells = [[row, column] for column from 1 to size]
      solver.add-constraint at-most-one(column-cells)
  add-forward-diagonal-constraints = (size) ->
    for sum from 2 to size * 2
      cells = [[row,sum - row] for row from 1 to size * 2 - 1 when row >= 1 && row <= size && sum - row >=1 && sum - row <= size]
      solver.add-constraint at-most-one(cells)
    #solver.add-constraint at-most-one([[1,1]])
    #solver.add-constraint at-most-one([[2,1],[1,2]])
    #solver.add-constraint at-most-one([[3,1],[2,2],[1,3]])
    #solver.add-constraint at-most-one([[3,2],[2,3]])
    #solver.add-constraint at-most-one([[3,3]])
  #add-forward-diagonal-constraint = (size) ->
    #solver.add-constraint at-most-one([[x,x] for x from 1 to size])
  #add-backward-diagonal-constraint = (size) ->
    #solver.add-constraint at-most-one([[x,size - x + 1] for x from 1 to size])
  setup = (size) ->
    add-variables size
    add-row-constraints size
    add-forward-diagonal-constraints size
  .. '1' ->
    add-variables 1
    solver.add-variable \column-1, [1]
    assert.equal true, solver.solve()
    assert.equal solver.get-variable(\column-1), 1
  /*
  .. '3' ->
    #solver.add-variable \column-1, [1, 2, 3]
    #solver.add-variable \column-2, [1, 2, 3]
    #solver.add-variable \column-3, [1, 2, 3]
      #for row from 1 to 3
      #solver.add-constraint at-most-one([[row, column] for column from 1 to 3])
    #solver.add-constraint at-most-one([[1,1],[2,2],[3,3]])
    #solver.add-constraint at-most-one([[3,1],[2,2],[1,1]])
    setup 3
    assert.equal true, solver.solve()
    assert.equal 1, solver.get-variable(\column-1)
    assert.equal 3, solver.get-variable(\column-2)
    assert.equal 2, solver.get-variable(\column-3)

*/
# duplicate variable name
