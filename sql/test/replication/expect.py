class Expectations():
  def __init__(self):
    self.checks = []

  def __str__(self):
    return f"expectations"

  def __repr__(self):
    return f"expectations"

  def hasRows(self, *rows, colnames=[]):
    def check(resultSet):
      for row in rows:
        row = {k: v for (k,v)in zip(colnames, row)}
        if row not in resultSet:
          return f"Did not find row {row} in {resultSet}"
      return ""
    self.checks.append(check)

  def verify(self, resultSets):
    for resultSet in resultSets:
      for check in self.checks:
        msg = check(resultSet)
        if msg != "":
          return msg
    return ""

  def check(self, resultSets):
    firstFailure = self.verify(resultSets)
    if firstFailure != "":
      raise AssertionError(firstFailure)
