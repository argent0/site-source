---
layout: "post"
title: "Finding what is new in your personal journal"
categories: "update test"
---

I've keep a log of my everyday activities since 2011. The goal is to
allow me to look back into the past having a clear perspective of myself at that
particular moment. But to accomplish this clear perspective, the text on the
journal should be clear too.

Here are some of the ways I'm using the [VIM](http://www.vim.org/) text editor
to make writing good text a little easier.

## Using a spell checker

The first one is obvious: I need spell checking. This command switches on spell
checking on the current buffer:

{% highlight vim %}
:setlocal spell
{% endhighlight %}

This is not only helpful if you want to read the text later, but also if
you want to do some kind automatic analysis like counting frequency of words.

## Using descriptive words

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

You only need to source a *vim* script where you basically tell *vim* which are the
words you want to be aware of:

{% highlight vim linenos=table %}
syn case ignore
" Some words that might be imprecise 
syn keyword WarningMsg something new
{% endhighlight %}

## Finding new words

A new feature I'm trying now is the ability to highlight words I haven't use
before. These words might appear when I'm writing about something I haven't
written before and I would like to be especially clear about.

Here's an example how this works. Notice how new words turn green as you type
them.

![sample session]({{ site.url }}/media/img/new_words_sample_session.gif "Sample session")

The process consist basically of:

* Knowing which words I have already used
* Knowing which words I have available in my language
* Highlight the words that I have available and I haven't use already

To know what words I have used already I'm using python's [*NLTK*](http://www.nltk.org/).
With *NLTK*, it's easy to load your corpus of text and calculate the frequency
of appearance for each word.

{% highlight python %}
import nltk
my_corpus = nltk.corpus.reader.PlaintextCorpusReader('.','diary.txt')
fdist = nltk.FreqDist(w.lower() for w in my_corpus.words())
{% endhighlight %}

Now `fdist["word"]` contains the number of times "word" is contained in the
file `diaray.txt`

To obtain a list of available words in a language, I searched for *wordlist*
and found one [here](http://www.google.com/search?q=english+wordlist "Google Search").

Now, to find the words I haven't used before,  I wrote a little python script
`filterWords.py` . Given your corpus, the *wordlist* and a number `N`, the
script will return the words in *wrodlist* that were used `N` times in the corpus.

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

Finally, to highlight this words in *vim* I generate a syntax file just before
launching *vim*:

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
