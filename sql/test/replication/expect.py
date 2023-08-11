class MatchCheck():
  def __init__(self, colnames):
    self.clauses = []
    self.colnames = colnames

  def clause(self, schedPred, rows):
    self.clauses.append((schedPred, rows))
    return self

  def elze(self, rows):
    return self.clause(lambda _: True, rows)

  def __call__(self, resultSet, schedule):
    for pred, rows in self.clauses:
      if pred(schedule):
        match = list({k: v for (k,v) in zip(self.colnames, row)} for row in rows)
        if resultSet != match:
            return f"{resultSet} did not match expected: {match}"
        return ""
    return "no clauses matched schedule"

class Expectations():
  def __init__(self):
    self.checks = []

  def __str__(self):
    return f"expectations"

  def __repr__(self):
    return f"expectations"

  def equals(self, *rows, colnames=[]):
    match = list({k: v for (k,v) in zip(colnames, row)} for row in rows)
    def check(resultSet, _schedule):
      if resultSet != match:
        return f"{resultSet} did not match expected: {match}"
      return ""
    self.checks.append(check)

  def match(self, colnames=[]):
    check = MatchCheck(colnames)
    self.checks.append(check)
    return check

  def verifyChecks(self, peerResultMap, schedule):
    for peer, resultSet in peerResultMap.items():
      for check in self.checks:
        msg = check(resultSet, schedule)
        if msg != "":
          return f"{peer}: {msg}"
    return ""

  def verifyConvergence(self, peerResultMap):
    it = iter(peerResultMap.items())
    firstPeer, firstResultSet = next(it)        # do not catch, there should be one result
    for peer, resultSet in it:
      if resultSet != firstResultSet:
        return f"{firstPeer}: {firstResultSet} != {resultSet} from {peer}"
    return ""

  def check(self, peerResultMap, schedule):
    firstFailure = self.verifyConvergence(peerResultMap)
    if firstFailure != "":
      raise AssertionError(firstFailure)
    firstFailure = self.verifyChecks(peerResultMap, schedule)
    if firstFailure != "":
      raise AssertionError(firstFailure)
