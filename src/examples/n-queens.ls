define = (size) ->
  constraints = []
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
  add-row-constraints = (size) ->
    for row from 1 to size
      column-cells = [[row, column] for column from 1 to size]
      constraints.push at-most-one(column-cells)
  add-forward-diagonal-constraints = (size) ->
    for sum from 2 to size * 2
      cells = [[row,sum - row] for row from 1 to size * 2 - 1 when row >= 1 && row <= size && sum - row >=1 && sum - row <= size]
      constraints.push at-most-one(cells)
  add-backward-diagonal-constraints = (size) ->
    for diff from 1 - size to size - 1
      cells = [[row,diff + row] for row from 1 to size * 2 - 1 when row >= 1 && row <= size && diff + row >= 1 && diff + row <= size]
      constraints.push at-most-one(cells)
  variables = [row for row from 1 to size]
  add-row-constraints size
  add-forward-diagonal-constraints size
  add-backward-diagonal-constraints size
  variables = ["column-" + column for column from 1 to size]
  { variables, constraints }

module.exports = {
  define: define
}
