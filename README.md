# Implementations of Okasaki's 'Purely Functional Data Structures' in Elixir

## Goals

The goal of this project is to implement all of the data structures introduced in Chris Okasaki's _Purely Functional Data Structures_ book.
The source code in the book itself is written in Standard ML with an appendix that has Haskell solutions. Just doing a brief
search for other implementations brings up a few attempts to solve the exercises in the book in F Sharp, Scala, and a few
smaller examples in Elm.

Attempting to solve the coding exercises from the book in Elixir should be an enlightening experience since it differs semantically and syntactically quite a bit from the ML-family languages that most of solutions have been written in thus far. 

## `deflazy` vs `fun lazy`

Okasaki introduces a `$` notation for suspended (unevaluated/lazy) functions in Standard ML in the book. In Standard ML, pattern matching on `$` expressions forces the suspended function to be evaluated. The semantics of this have not been exactly replicated in this Elixir implementation.

Rather than `$`, we have introduced a `Suspension` struct that holds a `fun: ` key storing an anonymous function. To evaluate the function, use `Suspension.force/1`. To replicate the idea of lazy evaluation _with_ memoization, which is a key part of the book and critical to achieving good amortized bounds with persistent data structures, there is a primitive caching mechanism with `Suspension` functions defined using the `Suspension.create(mod, func, args)` function.

I have tried to replicate as closely as possible the `fun lazy` function definition notation introduced by Okasaki in the book. The `Lazy` module contains a `deflazy/2` macro that allows users to define a function inside of a module as normal, replacing the `def` keyword with `deflazy`. `deflazy` will automatically return a `Suspension` struct and will memoize the results of forcing the functions. The `Lazy` module also exposes a `Lazy.eval/1` function that acts as a pass through to `Suspension.force/1` to evaluate the function contained by the `Suspension` returned by calls to functions defined with `deflazy`.

`deflazy` will also evaluate any `Suspension`s passed in as parameters when needed; if the `Suspension` returned as the result of a call to `deflazy` is never forced, then any `Suspension`s passed in as parameters will also not be evaluated. 
