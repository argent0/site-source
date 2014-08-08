---
title: "Imprecise Words"
categories: "web development linguistics"
---

I wrote a **Google Chrome** extension to highlight imprecise words in HN's
comment pages. Here is how and why.

There are certain words which can be used imprecisely. Let's take for example
the word "all" in the phrase "All is X". If you can find a single instance of
something that is not X, then you should not have used the word all. Another example
could be the word *easy*. Easy to whom?, compared with what?.

What I suggest is not avoiding these words completely, but rather to make sure
the pertinent clarifications are there when you use them. The complementary
suggestion would be to make sure you are aware of their loose meanings when you
read them. This is where the *Google Chrome* extension I wrote comes into play.

The extension highlights a list of possible imprecise words in
[Hacker News](https://news.ycombinator.com/news) comment's pages. Here it's
working:

![sample session](img/hn_screen_shot.png "Sample session")

If you want to try the [unpackaged
extension](https://developer.chrome.com/extensions/getstarted) you can go grab
it in its [github repository](https://github.com/argent0/hn-warning-words). Here
are [instructions](#instructions) to install it in your chrome browser.

I also wrote this extension as an exercise to apply what I'm reading in Code
Complete 2. So here are some technical considerations about the tools used.

### Technical Considerations

Before starting to code I thought about what I would like the extension to do:

* Have a list of potentially imprecise words
* Have words listed on the list marked on HN's comments pages
* The user can add/remove words from the list
* The user's list is persistent between browser restarts.

Then I started prototyping a way to mark the words in the comments. The first
prototype was thus a static list of words marked on the comments. This resulted
in code that made its way almost untouched to the final version, only changes
made where needed to update the comment's highlighting as the user changed the
words.

So here is something I could have anticipated: Change the marked words as the
user adds new words to the list.

After this part was prototyped I started writing the interface that was destined
to control the word list. This is add/remove words from the list. Once I had the
prototype I found that the *word-list* functionality was mixed with the
*word-list-display* functionality. This required me to, as it could have been
expected, separate both functionalities.

So the prototypes were built to check how or if certain parts of the extension
where going to work. Once the doubt is cleared, I could have stop to decide on
the architecture of the code. Both the *display* and the *word-list* have very
similar functionalities like *add-word*. But as the word list was also being
accessed by the *highlight-code* the separation of functionality was necessary.

The final surprise came when I found that the local storage works
asynchronously. I should have prototyped that too before starting to join the
different pieces together. Fortunately this wasn't an insurmountable difficulty.

## <a name="instructions"></a>How to install it

* Download and extract
[this](https://github.com/argent0/hn-warning-words/archive/master.zip) ZIP file.

* Go to the chrome menu Tools/Extensions

* Make sure [development mode](https://developer.chrome.com/extensions/faq#faq-dev-01)
  is enabled, by checking the checkbox to the top right.

* Click on "Load unpacked extension". 

* Select the folder *hn-warning-words-master* which was extracted from the zip file.
