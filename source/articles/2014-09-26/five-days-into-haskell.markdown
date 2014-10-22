---
title: "Five days into Haskell"
categories: "article"
abstract: "A perspective after five days prgramming only in Haskell"
order: 1
---

I've been learning Haskell for the five previous days.

I've been interested in the language since I found about it. There is a book
called "Higher-order Perl - Transforming programs with programs" by Mark Jason
Dominus. The book shows functional programming (FP) concepts in Perl. It's both,
a good way to learn Perl and a good introduction to the concepts of functional
programing. That is my first memory about FP and it is probably around that time
that I found Haskell. [Here is a repository](https://github.com/argent0/Higher-Order-Perl)
with some code from the book.

Although I have studied some Haskell before, what makes this time different is
that I have only coded Haskell this week. I have followed [this
advice](http://www.haskell.org/haskellwiki/Koans) of starting with a beginner's
mind and only think Haskell. I also want to follow the advice John Carmack gives in his
[keynote](https://www.youtube.com/watch?v=Uooh0Y9fC_M) about writing a medium size project to ground Haskell
and FP concepts in my mind so that I don't have to go over the tutorials
again. I've thought about writing a pong game.

I've read ["Write Yourself a Scheme in 48 Hours - An Introduction to Haskell
through
Example"](http://en.wikibooks.org/wiki/Write_Yourself_a_Scheme_in_48_Hours)
by Wikibooks contributors, up to chapter five. Lisp is also
a language I've read interesting things about(and studied a bit), so it is an
attractive medium size project lo start with.

I've stop with the book the moment I've felt like just typing characters into
an editor. That is when I felt there were too many unknowns to go on.  After
reading those chapters I think I have an overview of Haskell Syntax, a
presentation of the concept of monads (which still requires further inquiries)
and to type classes. I'm thinking in coming back to the book once I have a better
understanding of monads. Maybe, after better understanding FP in Haskell, the
book is the introduction to medium size projects that I'm looking for.

Working through the exercises of the books, I've found about another book: "Real
World Haskell" by Bryan O’Sullivan, John Goerzen, and Don Stewart. The person
that mentions it says that it covers some more ground before going into concept
of monads. Up to chapter Four, I don't find it as "hands on" as "Write
Yourself...". Chapter three, about types, is where I've learn what I know about
types so far. Reading the table of contents, the book seems to get more hands on
in chapters four and ahead. In fact I've started the book at chapter five about
writing a JSON library and then working my way to the first chapter. I'm not at
the Monads part yet.

Working the exercises of this second book I've enjoyed (yes, joy) one about
the [Convex Hull](http://en.wikipedia.org/wiki/Convex_hull) of a set of
points.

For the hands on experience, I've found
[Ninety-Nine Haskell Problems](http://www.haskell.org/haskellwiki/H-99:_Ninety-Nine_Haskell_Problems)
. Not yet the medium size projects I was looking for, but those problems have been
how I've been training my Haskell mindset so far(more on that later). They are
in fact 88 problems, divided into topics. Each topic I have covered 
starts easy and then build on those first simple problems. I like an exercise about
writing a [Huffman Code](http://en.wikipedia.org/wiki/Huffman_coding).

## Thinking in Haskell

The moment after working through the Huffman Code exercise, where you can build
a Huffman tree if you want to define your own types, is when the link between
Haskell and Algebra has become more evident to me.

The first solution that has come to my mind, after reading how to build a Huffman
tree on Wikipedia, was about storing values in some kind of hash to read them
later. Maybe that could work on javascript to solve the problem. But then I've
remembered that I'm writing Haskell this week.

Haskell is more about thinking how to define a type to store what you want to
generate (a Huffman tree for example). And how to define the desired result in
terms of the input. 

I'm sure I have still much more road to cover, but this is how I think 
Haskell now:

> Have a concrete structure for what you want to obtain and a definition of it
> in terms of the input.

I don't need to think about moving values back and forth with assignments. Just
think about definitions like those found in algebra.

Finally, the last problem I've read so far, problem 54A, says:

>Haskell's type system ensures that all terms of type Tree a are binary trees:
>it is just not possible to construct an invalid tree with this type. Hence, it
>is redundant to introduce a predicate to check this property: it would always
>return True.

It is amusing to find written the ideas you are forming in your head.

I'm going to try an example: Suppose I have to sort a list of integers. I write
whats the definition of a sorted empty list.

~~~ haskell
-- The sorted version of an empty
-- list is just another empty list
mySort [] = []
~~~

Then I could write a definition for: "the sorted version of a list".

~~~ haskell
mySort list = min(list) ++ mySort (remove min(list) from list)
~~~

This definition says: "The definition of the sorted version of a list 'list' is:
take the minimum of 'list' and append to it the sorted version of 'list' without
this minimum value."

## What I'm still not getting

**Writing readable code**. I've seen other people's code in Haskell for the
problems I've been working on and I still don't find it easy to read. There is code
that is more easy to read than other but I still need careful reading. Even
when I read what the code does in a comment it's hard to see how it's done.
It could be my limitations with the syntax, but I fear that, despite my best
intentions, even the code I've written will be hard to read in the future.

**Syntatic sugar**. At least when speaking about Monads and defining values in
a scope. There is more than one way to write the same.

For example:

~~~ haskell
do
	x1 <- action1
	x2 <- action2
	action3 x1 x2
~~~ 

is the same as

~~~ haskell
action1 >>= \ x1 -> action2 >>= \ x2 -> action3 x1 x2
~~~ 

The book "Write Yourself..." uses one or the other to make them both familiar to
you. I think you only get the benefits of syntactic sugar *once* you know what
you are doing.

**Writing the code**. I started writing type definitions before writing new
functions for example. Now, I write them when the function is done. This allows
me to return different types as I build the definition.

I first write part of a definition and then move away the parts that can be
placed in a function to improve the clarity and reduce the length. I often get
the type wrong when trying to write more clear code in on shot. And then I find
it hard to refactor the definitions. Again, I still can get more experience in
this regard.

## After five days

Although I'm not yet used to read the code, I like that Haskell makes you focus
in the definition of the problem you are solving.
