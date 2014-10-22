---
title: "Fourteen days into Haskell"
categories: "article"
abstract: "A perspective after 14 days programming only in Haskell."
order: 1
---

It's now fourteen days since I've started to learn Haskell.That is approximately
two times the experience I had when writing ["Five days into
Haskell"](/articles/2014-09-26/five-days-into-haskell.html). In this article I
review the road so far.

I'm going to start with what I've been reading. The starting question has been:
"What are monads?". I've previously read that IO is a monad. The IO monad is
Haskell primary way to get input from the user and to display the output of a
program. What that means to me is that at the end of your program you will have to
make calculations inside a *monad*. (Note the metaphor *Mondas are containers*)

Removing the metaphor that is: pass a *monadic value* to a function and using the
resulting, also monadic, value for the next function. 

Originally, the function, didn't accepted monadic values not returned them. But
using the right operators you can pass a monadic value to any function and make
any value a monadic value.

A monadic value has a *monadic type*, and a monadic type is an instance of the
Monda type class.

That looks like a lot of jargon to me, and I haven't tried to explain monads
here.

The point is that: as I want to write Haskell code that gets input and produces
output (outside ghci), I need to use the IO monad. So "what is a monad?" and
"What does it means to use a monad?" where the starting questions I wanted to
answer. Behind those questions I've found a lot of jargon, other type
classes, more than one name for the same entity and multiple ways to define the
same entity, among other things.

So, What I've been reading? And how I've got there. Many things. I've read "Real
World Haskell" Chapter 14 about Monads and then I've sorted the posts on the
[Haskell-Subreddit](http://www.reddit.com/r/haskell/top/?sort=top&t=all) by
points.

At position five, with 210 points is a link to ["What I Wish I Knew When
Learning Haskell 2.1"](http://dev.stephendiehl.com/hask/) by Stephen Diehl.
I've found there the ghci command `:info` along with sample usage. That command
is very useful when researching about type classes. It also mentions using *holes* to
help writing your code. Then it mentions monads under the caption
[Eightfold Path to Monad Satori](http://dev.stephendiehl.com/hask/#eightfold-path-to-monad-satori).
Also at position five, but now representing the fifth path to monad Satori, the
[Typeclassopedia](http://www.haskell.org/haskellwiki/Typeclassopedia)
is mentioned and that's where I continued reading. I've read the examples and
definitions provided next to the eightfold path. Up to this point, I've seen a
consistent incentive to don't try to describe monads with metaphors.

The Typeclassopedia by  Brent Yorgey, and converted to wiki syntax by
User:Geheimdienst, describes its objective as providing a way to gain
"a firm grasp of [Haskell's] standard type classes". So it's no longer only
about monads, now it's about type classes; monads are a standard type class
but they are not the only standard type class. 

Finding type classes again, as they are generally introduced before monads in
the literature, made me question what are they for; my current answer is:

> Use Type classes to group types and operators with *relevant* properties.

By *relevant* I mean pertinent to the objective of the code you are writing.

The Typeclassopedia gives the definition and *laws* of the standard type
classes. That's how a monad is defined: a set of operations and a set of *laws*
that those operations should follow. It then mentions various instances of the
classes. It continues saying that once you have a notion of how the type classes
are defined you should use and read the source code of the instances to finally
"grasp" the concept.

Following the last advice, the Typeclassopedia, mentions [You Could Have
Invented Monads! (And Maybe You Already Have.)
](http://blog.sigfpe.com/2006/08/you-could-have-invented-monads-and.html) 
by Dan Piponi. The article presents the reader with the problem monads are
trying to solve first to finally show how monads are a solution to the problem.

So the next steps would be to read the source code and use the monads. First
trying to experience the problem they are supposed to solve and finally how they
fit in the solution. The general advice seems to be be "write more code" keeping
the Typeclassopedia handy for reference.

### Coding Experience

I've also written my own code. It's about drawing lines pixel by pixel on a
screen and animating them. Here is the Point type:

~~~ haskell
data Point = Point Double Double deriving Show

instance  Eq Point where
	(Point x y) == (Point xx yy) = (x == xx) && (y == yy)

instance Ord Point where
	compare (Point x y) (Point xx yy)
		| (yy ==  y) = (x `compare` xx)
		| otherwise = (y `compare` yy)
~~~

Instancing both `Ord`, `Eq` here could have been done automatically by the
compiler:

~~~ haskell
data Point = Point Double Double deriving (Eq, Ord, Show)
~~~

The code uses an implementation of [Bresenham's line algorithm](http://en.wikipedia.org/wiki/Bresenham%27s_line_algorithm)
.

~~~ haskell
line_from :: Point -> Point -> [Point]
line_from p q =
	map (fromZeroOctantTo o) $ takeWhile (<=max_p) $ map dropError $ helper (0, min_p)
	where 
		helper (e,p) =
			[(e, p)] ++ (helper (next_point (e, p)))
		next_point (e, (Point x y))
			| (e + s) > 0.5 =  ((e+s-1), (Point (x + 1) (y + 1)))
			| otherwise = ((e+s), (Point (x + 1) y ))
		dropError (_, p) = p
		o = octant p q
		min_p = min (toZeroOctantFrom o $ p) (toZeroOctantFrom o $ q)
		max_p = max (toZeroOctantFrom o $ p) (toZeroOctantFrom o $ q)
		s = slope min_p max_p
~~~

It only draws lines with slopes less than one and uses symmetry to draw other
slopes. The implementation uses *tail recursion* in the function helper. "Real
World Haskell" suggest avoiding tail recursion due to it's generality.

The animation is a loop where the next frame follows from the previous.

~~~ haskell
advanceAnimation :: AnimationState -> AnimationState
~~~

Finally the animation is generated with tail recursive code. But this time
inside a monad.

~~~ haskell

update :: AnimationState -> IO ()
update frame = do
   clear_screen
   drawFrame frame
   update (advanceAnimation frame)))

main :: IO ()
main = do
   update initialAnimationState

~~~

I'm showing here a simplified version of the actual code, since the actual code
was written so it can run in a web browser with haste.

### Haste

From its site:

> [Haste](http://haste-lang.org/) is a dialect of the Haskell programming language
> geared towards web applications. Haste supports the full Haskell language,
> including most GHC extensions.

So you type Haskell code and it generates javascript. Haste also provides a
[Foreign function interface](http://en.wikipedia.org/wiki/Foreign_function_interface),
so I've been able to reuse old code to draw on the canvas.

Finally. I've also used cabal to configure and install the dependencies of the
little animation program.

This is how I've been writing my first Haskell code those days. 

### Doubts

When writing my own code, when or how should I use type classes, when should I
use the standard type classes, and which standard type class should I use?

### Rants

About the name of things I've found how sometimes in mathematics or physics one
uses only one symbol to identify an entity. There are name conventions to ease
readability, but I think there is need for improvement in that aspect. "More
expressive writing".

<!--
[Typeclassopedia](http://www.haskell.org/haskellwiki/Typeclassopedia)
[Haskellforall](http://www.haskellforall.com/) by Gabriel Gonzale  
[Introductions to advanced Haskell topics](http://www.haskellforall.com/2014/03/introductions-to-advanced-haskell-topics.html)
[ You Could Have Invented Monads! (And Maybe You Already Have.)](http://blog.sigfpe.com/2006/08/you-could-have-invented-monads-and.html)
by Dan Piponi 
[What I Wish I Knew When Learning Haskell 2.1](http://dev.stephendiehl.com/hask/)
[Haskell-Subreddit](http://www.reddit.com/r/haskell/top/?sort=top&t=all)
[Bresenham's line algorithm](http://en.wikipedia.org/wiki/Bresenham%27s_line_algorithm)
* I would like to retake "Write your self a scheme..." given that I'm now more
  familiar with monads and the language in general.

? Should I write my own type classes.
* Real world Haskell hits that writing readable code is writing ideomatic code
  If possible don't write your own tail recursion.

* Type classes Functors, Applicative, Monads, Foldable, Arrow, Semigroup,
  Category, etc... Typeclassopedia.
- Followed the tutorial "you could have invented monads".

- Haste, little browser program.

- Syntax sugar: There is an article in the Haskellwiki considering the do
  notation harmful. I think I recommends not using it until you master the
  cumbersome one.

- Writing code: I've read about people that writes code without testing it or
  running it.

- The book of real world Haskell recommends using type definitions. Just in case
  you don't get the type that you expect from the compiler.

  It stills takes me a few iterations to get the correct type of expressions.
  But I can note improvements.

  Coding experience: emscripten, haste-lang, ghcjs. Compiling to js. FFI

- Sorting the posts of reddig haskell I've found the book about what i wish i
  knew when learning haskell.

- Reading what I wish I new when learning haskell I arrived to the
  typeclassopedia.

- Tips inspecting the types
-	the :info function of ghci. (from "What i whish i knew")

- Cabal: cabal sandbox
-->
