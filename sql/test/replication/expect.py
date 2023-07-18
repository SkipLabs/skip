class Expectations():
  def __init__(self):
    self.checks = []

  def __str__(self):
    return f"expectations"

  def __repr__(self):
    return f"expectations"

  def equals(self, *rows, colnames=[]):
    match = list({k: v for (k,v) in zip(colnames, row)} for row in rows)
    def check(resultSet):
      if resultSet != match:
        return f"{resultSet} did not match {match}"
      return ""
    self.checks.append(check)

  def hasAllRows(self, *rows, colnames=[]):
    def check(resultSet):
      for row in rows:
        row = {k: v for (k,v) in zip(colnames, row)}
        if row not in resultSet:
          return f"Did not find row {row} in {resultSet}"
      return ""
    self.checks.append(check)

  def hasAnyRows(self, *rows, colnames=[]):
    def check(resultSet):
      for row in rows:
        row = {k: v for (k,v) in zip(colnames, row)}
        if row in resultSet:
          return ""
      return f"Did not find any of {rows} in {resultSet}"
    self.checks.append(check)

  def isOneOf(self, *rows, colnames=[]):
    def check(resultSet):
      if len(resultSet) != 1:
        return f"Multiple results in {resultSet}"
      for row in rows:
        row = {k: v for (k,v) in zip(colnames, row)}
        if row == resultSet[0]:
          return ""
      return f"Did not find any of {rows} in {resultSet}"
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
