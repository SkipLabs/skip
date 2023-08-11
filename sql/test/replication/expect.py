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

  def isOneOf(self, *rows, colnames=[], allowEmpty=False):
    def check(resultSet):
      if len(resultSet) < 1:
        msg = "" if allowEmpty else "Unexpected empty result set"
        return msg
      if len(resultSet) > 1:
        return f"Multiple results in {resultSet}"
      for row in rows:
        row = {k: v for (k,v) in zip(colnames, row)}
        if row == resultSet[0]:
          return ""
      return f"Did not find any of {rows} in {resultSet}"
    self.checks.append(check)

  def verifyChecks(self, peerResultMap):
    for peer, resultSet in peerResultMap.items():
      for check in self.checks:
        msg = check(resultSet)
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

  def check(self, peerResultMap):
    firstFailure = self.verifyConvergence(peerResultMap)
    if firstFailure != "":
      raise AssertionError(firstFailure)
    firstFailure = self.verifyChecks(peerResultMap)
    if firstFailure != "":
      raise AssertionError(firstFailure)
