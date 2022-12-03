import functools


def apply(target, composed_functions):
    return composed_functions(target)


def compose(*fns):
    return functools.reduce(lambda f, g: lambda x: f(g(x)), reversed(fns))


def map_to(map_fn):
    return lambda iterable: map(map_fn, iterable)


def make_filter(filter_fn):
    return lambda iterable: (it for it in iterable if filter_fn(it))