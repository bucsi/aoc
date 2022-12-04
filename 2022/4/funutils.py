import functools


def compose(*fns):
    return functools.reduce(lambda f, g: lambda x: f(g(x)), reversed(fns))


def map_to(map_fn):
    return lambda iterable: map(map_fn, iterable)


def filter_with(filter_fn):
    return lambda iterable: (it for it in iterable if filter_fn(it))