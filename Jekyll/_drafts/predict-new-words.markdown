<!---
Check if I'm using all the data of the *blog* to the closed month. [DONE]

I will use information available to the paragraph. The order of the sentence,
the number of word, etc...

The first iteration consist of using the constant p=N_1/N. I would like to see a
graph p as a function of N.

	* Not only is taking too long it also converges to zero.
	* That means it depends on the size of the training set.
	* At the end of all the words the probability of a new one is
		0.047

We should always predict "already used word with this model"

The next iteration is using the order of the sentence in the paragraph.
	This also converges to zero (better guess that there will be no new word.
	This was to be expected given that there are no sentences written mostly with
	new words

Enough of this blind trying, let's consider the previous word if its above
certain frequency threshold or RARE-N where N is the frequency and N <
threshold.

After all the words the probability by sentence number is:

sentence order, probability of new word
01 0.089670652029
02 0.0973020787262
03 0.0896068859198
04 0.0967480615669
05 0.0935775766939
06 0.097065462754
07 0.100787401575
08 0.0884057971014
09 0.118421052632
10 0.145833333333
11 0.0809248554913
12 0.121212121212
13 0.103448275862
14 0.115384615385
15 0.190476190476
16 0.125
17 0.222222222222
18 0.125
19 0.2

So later sentences in the paragraph are more likely to have new words. It's not
a completely useless feature

Let's make a tool that tells me whether a word is new on the sentence order

# Naive bayes

I can now train naive bayes models. And have a program to assign features to a
word.

Before starting to engineer features, I would like to have a program that tells
me which features predict a positive (newly used word).

I have the results and the posible predictors.

the file = 2014-03-21.txt

----------------------------
I fix the features.

The <BEGIN> tag now appears at the beggining of every sentence and added the
word order in the sentence

the file 2014-03-21-word-order-begin-fix.txt

I have slightly better precision and recall.

----------------------------

Logatimic frequency

I want to decrase the number of dimensions.

1) alternative take the log_10 of the frequency
	Precision ~ 0.42
	1.1) log_2
	1.2) log_e, this looks less arbitrary
		1.2.1) Increase the number of explicit words
			[150,50,10]
2) PCA

-->

