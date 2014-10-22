---
title: "Counting permutations with a tree"
categories: "haskell"
abstract: "Starting from an \"imperative\" solution implemented in Haskell, here is how, when trying to make the code more idiomatic, I ended with a completely different approach to solve the problem."
order: 0
---

### Motivation

I've been following the [coursera's](http://www,coursera.org) class 
[Algorithms: design and analysis.](https://www.coursera.org/course/algo)

The first week of the course introduces an algorithm for counting the number of
permutations on a list of numbers.

> A list $A=[a_i]$ of numbers has one permutation if $a_j < a_i$ for $j>i$.

This means that a sorted list has zero permutations and a list in reverse order has the
largest number of permutations possible for a list of that size.

I'm trying to couple the course with learning Haskell. So, for the programming
exercises I've implemented the course's suggested algorithm in Haskell. In doing
so I've had first hand experience on what Chris Okasaki says in his thesis
[Purely Functional Data Structures(pdf)](www.cs.cmu.edu/~rwh/theses/okasaki.pdf):

> Much literature purports to be language-independent but it is [only in the
> senece of "as long as you choose an imperative language"]

Although it is possible to implement those *imperative* algorithms is Haskell
using tail recursion and accumulators,it is also
[discouraged](http://www.haskell.org/haskellwiki/Haskell_programming_tips#Avoid_explicit_recursion)
. The rationale to avoid tail recursion is that:

> "it is hard for the reader to find out how much of the list is processed and
> on which values the elements of the output list depend"

In other words, if the recursion is in fact a `map` then using `map` is easier to understand
and thus more readable.

### The *imperative* approach.

Counting the inversions using a *divide & conquer* approach is: split the input
list in two and calculate the number of inversions in each part. Add each part's
inversions and an extra term of the inversions between the parts (*a.k.a*: split
inversions). Here is how it could be done on Haskell:

~~~haskell
countInversions :: Ord a => [a] -> Integer
countInversions [] = 0
countInversions [_] = 0
countInversions (x:xs) =
  countInversions h + countInversions t + countSplitInversions (mergeSort h) (mergeSort t)
  where
  (h,t) = splitAt (length (x:xs) `div` 2) (x:xs)
~~~

I find this code clear enough but, there is that call to `length`. The [Haskell
Wiki](http://www.haskell.org/haskellwiki/Haskell_programming_tips#Don.27t_ask_for_the_length_of_a_list_when_you_don.27t_need_it) advices:

> Don't ask for the length of a list when you don't need it.

Now asking for the length of a list raises the question: Do I need it?

To obtain the total number of inversions, it is necessary to count the *split*
inversions between the first and the second half of the list. The code below
uses a recursive call on `go` and two accumulators `adv` and `inv` for the
advance in the first half and the number of inversions so far respectively.

~~~haskell
countSplitInversions :: Ord a => [a] -> [a] -> Integer
countSplitInversions xx  = go 0 0 (fromIntegral (length xx) :: Integer) xx
  where
  go _ inv _ [] [] = inv
  go _ inv _ [] _ = inv
  go _ inv _ _ [] = inv
  go adv inv len xl@(x:xs) yl@(y:ys)
    | len < adv = undefined --This should never be reached
    | x < y = go (adv + 1) inv len xs yl
    | otherwise = go adv (inv+(len-adv)) len xl ys
~~~

I'm also passing around the length of the first argument(`len`) but I now see
that it is completely unnecessary. It can be calculated only once and assigned to a
variable in the `where` clause.

This has been my first attempt to count the inversions on Haskell. It's also
possible to avoid all those accumulations using `fold`. But I've not seen it
clearly when writing the code.

After finishing with this implementation and seeing that it works. The question
has become: Can this be done in a different way? I would like to see if there is
a more functional way to do this.

That is, when possible, eliminate the accumulations in the recursions. Eliminate
the recursions. This two things should be achieved expressing the operations in
terms of more *conventional* operations (`map`, `fold`, etc..). Finally, see if
it is possible to avoid the calls to `length`.

### Using trees

There is another data structure that I know of, it is the *binary tree*. From
[Wikipedia](en.wikipedia.org/wiki/Binary_tree):

> A *binary tree* is a tree graph data structure in which each node has at most two
> children, which are referred to as the left child and the right child.

This structure represents a binary tree in haskell:

~~~haskell
data Tree k v = Empty | Leaf k v | Branch k v (Tree k v) (Tree k v) deriving Show
~~~

The nodes store pairs `k v`. Where `k` is the key and `v` is the value.

And among binary trees there are *binary search trees(BST)*. From
[Wikipedia](http://en.wikipedia.org/wiki/Binary_search_tree):

> A binary search tree (BST), sometimes also called an ordered or sorted binary
> tree, is a node-based binary tree data structure where each node has a
> comparable key (and an associated value) and satisfies the restriction that
> the key in any node is larger than the keys in all nodes in that node's left
> subtree and smaller than the keys in all nodes in that node's right sub-tree. 


To count permutations with a binary tree, it is important to note that:

**You can insert a new (key,value) into a BST and obtain a new BST**

Not surprisingly, this operation is called *insert*. For the data structure
defined above this would be:

~~~haskell
insert :: Ord k => Tree k v -> k -> v -> Tree k v
insert Empty k v= Leaf k v
insert (Leaf ok ov) k v
   | k < ok = Branch ok ov (Leaf k v) Empty
   | otherwise = Branch ok ov Empty (Leaf k v)
insert (Branch ok ov l r) k v
   | k < ok = Branch ok ov (insert l k v) r
   | otherwise = Branch ok ov l (insert r k v)
~~~

Note how the comparison `k < ok` determines where to insert the new pair (`k
v`). This operation, as you can see, is recursive for the `Branch` pattern. But
in only transverses half of the tree depending on the comparison `k < ok`. It
would be interesting to see if it is possible to instantiate a proper `Functor`
and express this a `fmap`.

Now, the second detail to note is that if you are building a tree from a list
$A=[a_i]$:

**If the recursion of insert takes the left branch, thus `k < ok`, then there
was an inversion in $A=[a_i]$**

So it's possible to create a overloaded insert function that: inserts an element
in a tree and returns the new tree and how many permutations it has found:

~~~haskell
insertAndCountInversions' k Empty = (Leaf k (0,0), 0)
insertAndCountInversions' k (Leaf ok (vl, vr))
  | k < ok = (Branch ok (vl+1,vr) (Leaf k (0,0)) Empty, 1)
  | otherwise = (Branch ok (vl,vr+1) Empty (Leaf k (0,0)), 0)
insertAndCountInversions' k (Branch ok (vl, vr) l r)
  | k < ok = (Branch ok (vl+1,vr) new_l_branch r, cl+vr+1)
  | otherwise = (Branch ok (vl,vr+1) l new_r_branch, cr)
  where
    (new_l_branch,cl) = insertAndCountInversions' k l
    (new_r_branch,cr) = insertAndCountInversions' k r
~~~

This insert function creates `Tree k (Integer, Integer)` where the tuple value
represents how many nodes are to the left and right of the current node. It also
returns an `Integer` value counting the number of inversions found when storing
`k` in the tree.

Checking the pattern for `Leaf` reveals that, If `k < ok` then there is one
inversion, otherwise none. For the `Branch` pattern, each time when `k < ok` adds
`vr+1` inversions to the count. `1` because the new value is less that the
current node and `vr` because the new value is also less than the values
in the right branch.

This function is also recursive. And assumes lazy evaluation, like Haskell has.

Finally, for the case of counting inversions:

**$a_j$ can only form inversions with $a_i$ for $i < j$**

So, when inserting values into a tree, you only have to check for inversions with
the previously inserted values.

Here is a function that counts inversions in any `Foldable` data structure (like
lists):

~~~haskell
countInversions' :: (Foldable c, Ord k) => c k -> (Tree k (Integer, Integer), Integer)
countInversions' = Data.Foldable.foldl f (Empty,0)
  where
  f (ot,op) k = (nt, op+np)
    where (nt, np) = insertAndCountInversions' k ot

-- Could also be the, less general, signature:
-- countInversions' :: (Ord k) => [k] -> (Tree k (Integer, Integer), Integer)
~~~

### Conclusion

First, all the accumulator variables have disappeared. There is still
accumulation in the `foldl` of `countInversions'` and in the recursive
call of the overloaded insert `insertAndCountInversions'`
But it's no longer on the function parameters, making the accumulation more
clear.

The recursion of `insertAndCountInversions'` is inserting into a BST, so the reader
of the code may be familiar with the structure a know what to expect,

There are zero calls to `length`. This means that it was not needed after all.
The program can start calculating inversions right away without
needing to read all the input list to compute its length.

Insertion on the tree takes, according to Wikipedia, $O(n)$ in the worst case
and $O(\log n)$ in the average case. To count the inversions it is necessary to
insert $n$ values. So the count would take $O(n \log n)$ in the average case and
$O(n^2)$ in the worst case. The space used by the tree is $O(n)$.

I've not revised the question of *stack space* in `insertAndCountInversions` and
`countInversions`.

<script type="text/javascript"
	src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"></script>

<script type="text/x-mathjax-config">
  MathJax.Hub.Config({tex2jax: {inlineMath: [['$','$'], ['\\(','\\)']]}});
</script>
