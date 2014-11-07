---
title: Thirty days into Haskell
categories: "haskell"
order: 1
abstract: A perspective after 30 days learning Haskell.
---
One of the questions, after 
[fourteen days](/articles/2014-10-04/fourteen-days-into-haskell.html)
programming in Haskell was: How and when to use type classes?

The research on the topic comes mostly from reading again the
[Typeclassopedia](http://www.haskell.org/haskellwiki/Typeclassopedia) and the
haskell [Wiki](https://www.haskell.org/haskellwiki/Haskell)


My current view is that type classes group types that can be passed as arguments
to a collection of operators that have defined properties.

For example the [`Functor`](https://www.haskell.org/haskellwiki/Functor) class
is defined like:

~~~
Main> :info Functor
class Functor (f :: * -> *) where
  fmap :: (a -> b) -> f a -> f b
  (<$) :: a -> f b -> f a
		-- Defined in ‘GHC.Base’*
~~~

where `fmap` follows the laws:

~~~
fmap id = id
fmap (g . h) = (fmap g) . (fmap h)
~~~

So if there is a type `T`, and it's possible and necessary to define a function
with the same type signature of `fmap` that obeys the same laws, then that function
should be called `fmap` and `T` should be an instance of `Functor`.

More over, if you write a function that takes a list argument `[a]`:

~~~haskell
f :: [a] -> b
f x = ... map g x ...
~~~

and only use the the argument in a `map` function, exchanging `map` for `fmap`
and changing the type signature for:

~~~haskell
f :: Functor a => f a -> b
~~~

would make that function able to operate not only on lists but in the entire
`Functor` class.


**Experience**

The [Typeclassopedia](http://www.haskell.org/haskellwiki/Typeclassopedia) says
(emphasis added):

> There are two keys to an expert Haskell hacker’s wisdom:
>
> 1. **Understand the types.**
>
> 2. Gain a deep intuition for each type class and its relationship to other
> type classes, backed up by familiarity with many examples. 

Later, it suggests that "understand the types" can be attained by studying the 
*type signatures*. The `:t` command in `GHCi` will show you the type of an
expression.

The second point, says the Typeclassopedia, is gained by experience using the
actual class,

Regarding the first point, I have had the doubt if I could dispense the use of
`>>=` when printing some result. As I couldn't find a way, I asked in `#haskell`: 

~~~
17:24 <Fuuzetsu > Applicative doesn't let you inspect the values and decide what to run (in this case print)
17:25 < argent0 > Fuuzetsu: Ok, Thanks!
17:25 <Fuuzetsu > argent0: if you simply think about the types you need, you'll understand it quickly
~~~

Here is the key insight:

> **if you simply think about the types you need, you'll understand it quickly**

So how could I had understood the type?. This is what the `:info` GHCi's command
is for. So, I could have seen the definition of `Applicative`:

~~~
Main> :info Applicative
class Functor f => Applicative (f :: * -> *) where
	pure :: a -> f a
	(<*>) :: f (a -> b) -> f a -> f b
	(*>) :: f a -> f b -> f b
	(<*) :: f a -> f b -> f a
				-- Defined in ‘Control.Applicative’
~~~

Of course I had already seen that. But understanding the types means looking at
the type signatures. And after careful inspection, it's clear that: "Applicative
doesn't let you inspect the values and decide what to run."

Regarding the second point of expert Haskell wisdom.  One of the type classes
that I've read about is
[Applicative Functor](https://www.haskell.org/haskellwiki/Applicative_functor#How_to_switch_from_monads)
. This type class has more structure than a functor and less than a monad. This
means that code using `Applicative` is more general. In other words, when
`Applicative` is enough, use it.

Besides, according to the wiki, programming using *Applicative Funtor*:

> has a more applicative/functional feel. Especially for newbies, it may encourage
> functional style even when programming with effects. Monad programming with do
> notation encourages a more sequential & imperative style. 

To see how this "encourages functional style even when programming with
effects", here is an excerpt of my original monad code:

~~~haskell
-- Counts inversions from a list of numbers passed in stdin
main :: IO ()
main =
   getContents >>= \c ->
   (mapM r Control.Monad.>=> print . snd . countInversions') (lines c)
   where r cc = return $ read cc :: Integer
~~~

I've deliberately avoided the [`do` notation](https://www.haskell.org/haskellwiki/Do_notation_considered_harmful)
to understand the functional style behind it.

What happens when I write the same using Applicative functor?  After
extensive use of the `:t` command in `ghci`, the code becomes:

~~~haskell
main =
   (snd <$> countInversions <$> fmap r <$> lines <$> getContents) >>=
   print
   where r cc = read cc :: Integer
~~~

I'm also using `fmap r` instead of `map r`. The reasoning behind the preference
for `fmap` is that `fmap r` can be applied to any instance of `Functor` (for
example `[]`) while `map r` can only be applied to lists. In fact
`countInversions` needs its input to be an instance of `Foldable`, so I should
use `foldMap` if I wanted to abstract the `snd <$> countInversions <$> fmap r`
part of the code.

As promised, Applicative Functor, has exposed a *functional style* of writing
the code. This shows in how the functions are combined with the `<$>` operator.
And there is more, as you still need to unpack the left side of `(>>=)`, why
not just unpacking the value of `getContents` at the begging. This way you don't
need to use `Applicative`:

~~~haskell
main =
   getContents >>= print . snd . countInversions . (fmap r) . lines
   where r cc = read cc :: Integer
~~~

This works with the minimum necessary unpacking of `IO String` coming from
`getContents` and does the rest on the work with a combination  of functions
written in  *point free* style. It is also, to my appreciation, more clear that
the original version.

The only place where I'm still using `Applicative` is when avoiding list
comprehension. For exmple in:

~~~haskell
---True if x is in visited
justVisited x = or $ (==x) <$> visited
~~~

I've had more clarifying experiences that I've written about when [counting
permutations in a
list](/articles/2014-10-21/counting_permutations_with_a_tree.html).


**Tools**

[**HLint**](http://community.haskell.org/~ndm/hlint/) reads Haskell programs and
suggests changes that hopefully make them easier to read. It useful to learn
operators precedence. It even suggests simpler ways of writing some pieces of
code.

[**Hoogle**](https://www.haskell.org/hoogle/) is a Haskell API search engine. It
enables you to search by approximate type signature or by function name. It can
be installed locally to work as CLI tool. When you start thinking about the type
signature, *Hoogle* is useful to search for a function that already has the
signature you are looking for.

**Next**

I would like to write some examples using the `Arrow` class.
I've written some code with [Fun with
types](http://en.wikibooks.org/wiki/Haskell/Polymorphism). In particular
	natural numbers modulo eight.

<!--

Readings

Typeclassopedia
Programming tips
Haskell wikibook
GHC users guide.

Applicative
Functor
	> Trees, Drawing trees.

Typeclasses
Group types by operations which behave according to certain laws.

State Monad.

Kind
Language Extensions

# Tools
Hoogle
ghc_mod
hlint

Questions:

Difference between Container and computation

-->
