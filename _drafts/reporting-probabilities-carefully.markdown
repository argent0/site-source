---
layout: "post"
title: "Reporting probabilities carefully"
categories: "update test"
---

Suppose you have an experiment with two possible outcomes. For example: "You
send an email to a person", the possible outcomes being: you get a response or
you don't.

Now suppose you sent two emails and received only one response. Afterwards 
someone asks you: "Hey! I want to send enough emails to get at least one
response. How many ($n$) should I send?"

The answers depends on how much risk are you willing to take. Risk of getting
zero answers. Let's say you are willing to take risk $\epsilon = 0.01$. That is, over
$100$ times you send the bunch of emails, you expect to get at least one answer $99$
times.

If $p$ is the probability that someone replies, then you want to find $n$ such that

$$ (1-p)^n < \epsilon $$
$$ n < log(\epsilon)/log(1-p) $$

What about $p$? Suppose you can't make more experiments. You could say

$$ p = \frac{1}{2} $$

That would mean that if you want to take $\epsilon$ risk then you should send
about $7$ emails.

But what if you where lucky to get one out of two. If the real probability to have
a replay is $q$, then the probability of one reply in two tries $P(N=1)$ is:

$$ P(N=1) = {1 \choose 2}q(1-q) $$

If $q=0.4$ then you would get one reply in two tries almost half of the time

$$ 2 * 0.4*(1-0.4) \approx 0.48 $$

and if $q=0.4$ then you should advice to send $10$ emails instead of $7$.

So, in this particular case, overestimating $p$ results in underestimating
$n$.

One strategy to prevent this underestimation could be:

> Find $p$ such that the probablity of obtaining one reply in two tries is below
> some $\eta$.

That is:

$$ P(N=1,p) = {1 \choose 2}p(1-p) < \eta$$
$$ p^2-p+\frac{\eta}{2} < 0 $$

For the case of $\eta = 0.01$, $p = 0.005$.

In other words if you want to overestimate $p$ only $1$ every $100$, you should
say that it's value is $p = 0.005$. Given your experience of one reply in two
emails. This value of $p$ implies that you should send about $920$ emails to
recieve at least one answer $99$ of $100$ times you send a bunch.

## In general

If you make $k$ experiments and succed $m \le k$ times then you should:

> Find $p$ such that the probablity of obtaining $k$ replies in $m$ tries is below
> some $\eta$.

$$ P(N=m,p) = {m \choose k}p^m (1-p)^{(k-m)} < \eta$$

<script type="text/javascript"
   src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"></script>

<script type="text/x-mathjax-config">
  MathJax.Hub.Config({tex2jax: {inlineMath: [['$','$'], ['\\(','\\)']]}});
</script>
