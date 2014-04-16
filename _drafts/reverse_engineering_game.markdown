---
layout: "post"
title: "Reverse Engineering game"
categories: "Web development"
---

<!--

POST OBJECTIVE: I want to share my experience reading the book and writing this
game

* I started with a unclear idea: I wanted a game about reverse engineering.
* I built the prototype of the led board
* I played with it
* I picked a way to code the inner workings as population migrations
* I Built the current code
	+ It started from javascript
	+ Then moved to coffeescript
	+ Easier to work with arrays
		

What would I do different now:

* I would think beforehand of the requirements
	- difficult to cheat
* Design the code better. Separate the mechanics from the display
* Reorganize the build process
-->

As I started reading the book  Code Complete 2, I thought I could as well
practice by writing some code.

I also had the idea of making a [game about reverse
engineering](http://argent0.github.io/-turnt-octo-reverse-engineering/). My idea about
reverse engineering was having some kind of system with unknown underlaying
mechanics, some way you can interact with and some response. A black box system.

The next key idea was that I wanted some kind of keypad with colors. I wanted
that the keys' colors change as you press the keys, but I wasn't sure about which
logic should they follow to change their color.

So that made the starting idea: "A reverse engineering game with a color keypad
with keys that changes colors". It should also run in the browser so the player
doesn't have to install anything.

With these requirements I wrote the code for the keypad and started playing with
it. I didn't know at that time what to do about the underlaying mechanics, but
plying with it remained me of the dynamics of ethnicities in cities. That's what
makes that ethnicities cluster together in neighbours. It's called
[Schelling's segregation
model](http://en.wikipedia.org/wiki/Thomas_Schelling#Models_of_segregation).

The Schelling segregation model says that you prefer to live among people of
your same race. In the case of this game, I made each key have most frequent
color among the keys it was connected to.

Once the mechanics where decided (see [mechanics](#mechanics)), I started thinking
how this was going to be a game. It needed some kind of score and I also wanted to
help the player make the game easier for him/her if he/she wanted to.

As I want the players to experiment I don't want to count the number of
connections tried. I instead count the how many times does he think he has a
solution. I also count the numnber of aids used.

So the ideal score is one solution check with no hints.

## Next improvements

The game part of the game was an aftertought. I would like to make the scores
more comparable among them. That means adding how many conections where there to
be found. In the same spirit, I would like to move some logic to a server in
order to make cheating harder.

## Conclusion

On the one sense, the development was based on protypes in three stages. The
keypad, which inspired the mechanics, and the keypad plus the mechanics the
socre system. On the other way I should have anticipated that I wanted the
socres to be secure and comparable.

## Appendices

### <a name="mechanics"></a>Resulting mechanics

You press keys in a keypad. Each press makes the key change color. These keys
are connected to other keys by connections the player can't see. The resulting
color of each key depends on its connections.

The dependency is: Each key's color is the most frequent color among the keys
it is connected to.

The objective of the game is to discover how keys are connected.

The player can connect the keys in another keypad and check if his proposed
connections are right by pressing a button. Each time you the button a counter
is increased.

The player can also reveal a connection by pressing another button and
increasing a counter.

### Technical aspects

Before deciding the mechanics the code was written in *javascript*. I expected
the code for the dynamics to involve a lot of array operations, so I switched to
*coffeescript*. *Coffescript's* syntax allows array manipulations automatically
handling the details about array length and iteration, thus reducing the
complexity that I have to handle when writing these operations. They call this
"array comprehensions":

{% highlight coffeescript %}
cubes = (math.cube num for num in list)
{% endhighlight %}
