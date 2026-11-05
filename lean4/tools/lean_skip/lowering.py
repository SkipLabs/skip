"""Conservative control-flow recovery; cyclic/general joins retain a loop."""
from .ir import walk


def expression_join(body):
    """One acyclic join, reached by every continuation leaf: a match expression."""
    joins = [i for i in walk(body) if i['op'] == 'join']
    if len(joins) != 1 or joins[0] not in body:
        return None
    join = joins[0]
    if any(i['op'] == 'jump' for i in walk(join['body'])):
        return None
    tail = body[body.index(join) + 1:]
    leaves = [i for i in walk(tail) if i['op'] in ('return', 'jump', 'unreachable')]
    if not leaves or any(i['op'] != 'jump' or i['id'] != join['id'] for i in leaves):
        return None
    return join
