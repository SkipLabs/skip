"""Deterministic human-readable identifiers, independent of export order."""
import hashlib
import json
import re


def digest(key):
    return hashlib.sha256(key.encode()).hexdigest()[:10]


def identifier(text, limit=56):
    text = re.sub(r'[^a-zA-Z0-9_]', '_', text)
    text = re.sub('_+', '_', text).strip('_') or 'value'
    if text[0].isdigit():
        text = 'n_' + text
    return text[:limit]


def module_name(owner):
    return 'L4_' + '_'.join(identifier(p) for p in owner.split('.'))


def function_name(key):
    parts = json.loads(key)
    # Keep the useful trailing names, without repeating long specialization paths.
    words = [str(p) for p in parts if isinstance(p, str) and p not in ('_private', '_at_', '_redArg')]
    return 'f_' + identifier('_'.join(words[-3:])) + '_' + digest(key)


def local_name(hint, index):
    # Leading underscore permits legitimately unused erased arguments.
    return '_' + identifier(hint or 'value', 24) + '_' + str(index)


def adapter_name(key):
    return 'apply_' + function_name(key)
