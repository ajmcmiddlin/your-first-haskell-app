# Your first Haskell app

## Abstract

When learning a new programming language there is almost always a leap from learning to applying
your knowledge. This leap can be quite large when learning Haskell for a number of reasons. One
reason is the dramatic difference between Haskell's style of programming compared to more common
imperative languages that many learners are more familiar with. As a consequence, a difficulty for
those new to Haskell is identifying when and how to apply the concepts they've learned when writing
an application. Another is navigating the Haskell ecosystem; including finding packages and understanding how they
work. Finally, some newcomers may delay writing their first application, believing they need to be
comfortable with more advanced concepts before they can successfully write useful software. This is
not the case. While these abstractions are useful, many of Haskell's benefits
can be enjoyed while sticking to its more basic abstractions.

By referring to a simple example application, we'll demonstrate how and when to apply some core techniques
and abstractions, and alleviate the burden of starting an app from scratch. We'll cover a number of
data types, type classes, and techniques, including:

 - Effectively using algebraic data types to more precisely model the problem
 - Using applicative parsers to read configuration from the command line or files
 - Using the `Monoid` type class to merge layers of configuration. e.g. user values merged with
   defaults
 - Using `Maybe` in place of `null` or exceptions to handle missing/optional data
 - Using `Either` in place of exceptions or return codes to handle failures
 - Using the `Monad` type class to sequence computations in a particular context, such as IO

If you've ever been intimidated by the thought of starting a project in Haskell, then this talk will
give you a solid place to start. Along the way we'll see that, not only is Haskell a general purpose
language that can be used to write everyday applications, but that it brings with it a range of
benefits.

## Bio

Andrew is a functional programming engineer at Data61. Earlier in his career he worked across a
range of domains using conventional imperative programming languages, growing more and more
frustrated with the difficulties of reasoning in a stateful and often untyped world. After hearing the
claims that functional programming offered solutions to these problems, he embarked on learning
Clojure - having fond memories of his first year programming course in Scheme. Convinced that FP was
a good choice, but being burned by a lack of types, Andrew then switched his focus to Haskell and
hasn't looked back since.
