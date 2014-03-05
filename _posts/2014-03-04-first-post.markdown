---
layout: "post"
title: "Finding what is new in your personal journal."
excerpt: "This this a test post excerpt"
categories: "update test"
---

<!---
> talk about nlp first (how?)
> i'm concerned about the clarty(precicion of the content
> Writing needs to convey precise information through time

Titles: "Finding what is new in your personal log."
	"Writing your dairy using vim"

I don't want the word personal in title

I will use the word JOURNAL for the diary.

Who am I addressing?
	Speaking about me?
	Speaking to you?
-->

# Motivation

<!--- Too serious

Subtitle: Motivation
theme: I want to introduce what I wanted to do

I've keep a log of my everyday activities since 2011. The goal is to
allow myself in the future the possibility of recalling events in the past.
Thus, the text written in the log should be as precise and informative as possible.

Having spent three years wrinting in this log with a simple text editor (vim). I
started thinking about what functionality would I like to have while wrtiting.
-->

I've keep a log of my everyday activities since 2011. The goal is to
allow myself in the future the possibility to know what was I thinking in the
past. This implies that the text should as clear as to allow me to understand it
later.

Here are some of the ways I'm using to make writing good text a little easier
for me. I'm using the [VIM](http://www.vim.org/) text editor.

## Using(mostly) words from the dictionary

<!---
I didn't say I'm using vim

First of all I need spell checking. This is very helpful if I was  planing to analyze
the text using the computer or even read it myself. Fortunately, vim already has
spell checking capabilities. This helps with clarity, since it promotes using words in
the dictionary.

And so, problem of using words that everybody can look up in a dictionary was
solved.
-->
The first one is obvious. I need spell checking and fortunately vim comes with
one.  To enable spelling mistakes highlight use:

{% highlight vim %}
:setlocal spell
{% endhighlight %}

This is not only helpful if you want to read the text by yourself, but also if
you want to do some kind automatic analysis like counting frequency of words.

## Using descriptive words
<!---
But using words in the dictionary you can also be very vague. For example
consider the sentence: "I did something new.". It doesn't say much; I don't know
what was done; and, more subtle, What do I mean by new? New for humanity? New
because I've never done it before? Etc...

The easiest I found to start dealing with this kind of imprecision is to simply
highlight the words that I consider needs more clarification
-->

Using words from the dictionary stills allows you to say things like: "I did
something new". The problem with this sentence, which is an extreme example, is
that it leaves many unanswered questions. Like: "What was done?" and "Why is it
new?".

Of course you can answer these questions later in the paragraph, but only if you
are aware that you left them unanswered in the first place.

Vim can remind you when you are using such words by highlighting them. For
example in:

<pre class="terminal">
<code>I did <span style="background-color:blue;">something new</span>.</code>
</pre>

So that you can clarify what you meant:

<pre class="terminal">
<code>I did <span style="background-color:blue;">something new</span>. What I did was...</code>
</pre>

You only need to source a vim script where you basically tell vim which are the
words you want to be aware of:

{% highlight vim linenos=table %}
syn case ignore
" Some words that might be imprecise 
syn keyword WarningMsg something new
{% endhighlight %}

<!---
> Here I would like to explain the effect if produces to know that you are
> being imprecise while you write. It makes you rethink what you are writing and
> be more precise
-->

## Finding new words

> I have used the previous functionality for a while now to see it's effect.

> This is still experimental. The idea is that now that you know you have
> entered a word you never used before in your log, you could expend some more
> time describing what happened. And it is not so hard to do

> So far, I can say that after three years writing a diary, representing many
> activities. I still use words I have not used before. Number like 13-22 per entry

## Sample session

Here's an example how this works. Notice how new words turn green as you type
them.

![sample session]({{ site.url }}/media/img/new_words_sample_session.gif "Sample session")

### How was it done

The process consist basically of:

* Knowing which words I have already used
* Knowing which words I have available in my language
* Highlight the words that I have available and I haven't use already

#### Which words were already used

> Using python [NLTK](http://www.nltk.org/), it's easy to load your corpus of
> text and calculate the frequency of each word.


{% highlight python %}
import nltk
my_corpus = nltk.corpus.reader.PlaintextCorpusReader('.','diary.txt')
fdist = nltk.FreqDist(w.lower() for w in my_corpus.words())
{% endhighlight %}

Now `fdist["word"]` contains the number of times "word" is contained in the
file `diaray.txt`

> So much for the words I have already use

#### Available Words.

To obtain a list of all words available you should search for a *wordlist*. I
found an english *wordlist* [here](http://www.google.com/search?q=english+wordlist "Google Search").

#### Finding the words you haven't used.

To accomplish this task, I wrote a little python script `filterWords.py` . Given your corpus,
the *wordlist* and a number `N`, the script will return the words in *wrodlist*
that were used `N` times in the corpus.

{% highlight python linenos=table %}

""" 
    USAGE: filterWords.py <diaray file> <frequency filter>
    Given a list of words from stdin, prints the ones that apear <frequency
    filter> times in the <diaray file> corpus.
"""
import sys                      
if (len(sys.argv) < 3):
    print "USAGE: "+sys.argv[0]+" <diaray file> <frequency filter>"
    sys.exit()
diaryFile = sys.argv[1]
freq_filter = int(sys.argv[2])
import nltk
# You may want to use a custom word tokenizer
my_corpus = nltk.corpus.reader.PlaintextCorpusReader('.',diaryFile)
# calculating the frequency distribution of the words
# You could save this distribution using pickle
# https://wiki.python.org/moin/UsingPickle
fdist = nltk.FreqDist(w.lower() for w in my_corpus.words())
for line in sys.stdin:
    key = line.strip() 
    if (fdist[key]==freq_filter):
			print key
{% endhighlight %}

Using this script it is easy to obtain the words you have not used yet by:

{% highlight bash %}
python2 filterWords.py your_diary.txt 0 < your_wordlist
{% endhighlight %}

## Highlight new words in vim

To achieve this I generate a syntax file just before launching vim:

{% highlight bash %}
vim_script_file="/tmp/uniq.vim"
#Ignore case
echo syn case ignore > "$vim_script_file" 

# Highlight new words (never used before)
echo syn keyword Type\
        $(cat res/en.txt |\
			python2 filterWords.py "$diary_with_no_comments" 0 |\
        tr '\n' ' ') >> "$vim_script_file"

# Correct posible errors
sed -i -e '/Type$/d' "$vim_script_file"

# Source syntax file before launching vim
vim -S "$vim_script_file" diary.txt
{% endhighlight %}


Categories

{% for categorie in page.categories %}
{{ categorie }}
{% endfor %}
