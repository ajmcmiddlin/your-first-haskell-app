# Your first Haskell app

## Keywords

Haskell, tutorial, error handling, configuration parsing, Monoid, Either, Maybe, Applicative

## Authors

Andrew McCluskey - Data61

## Abstract

### Intended audience

Beginner functional programmers who have a reasonable understanding of foundational concepts, but
are yet to write an application using functional programming.

### Motivation

When learning a new programming language there is almost always a leap from learning to applying
that knowledge. This leap can be quite large when learning Haskell for a number of reasons. One
reason is the dramatic differences between Haskell's style of programming compared to more common,
imperative languages that many learners are more familiar with. Another is navigating the Haskell
ecosystem; including finding packages and understanding how they work. As a consequence of this
difficulty, those new to Haskell sometimes have difficulty identifying when and how to apply the
concepts they've learned when writing their first applications.

For example, beginners may not be aware of common approaches when writing Haskell applications, such
as:

 - Effectively using algebraic data types to more precisely model the problem
 - Using applicative parsers to read configuration from the command line or files
 - Using the `Monoid` type class to merge layers of configuration. e.g. user values merged with
   defaults
 - Using `Maybe` in place of `null` or exceptions to handle missing/optional data
 - Using `Either` in place of exceptions or return codes to handle failures
 - Using the `Monad` type class to sequence computations in a particular context, such as IO

Furthermore, some newcomers may delay writing their first application believing they need to be
comfortable with more advanced concepts before they can successfully write useful software. This is
not the case. While these concepts are useful, many of Haskell's benefits can be enjoyed while
sticking to its more basic abstractions.
 
### Goal

This talk aims to bridge the gap between learning functional programming concepts, and writing a
useful application. By providing a guided tour of a working example, beginners will be able to more
quickly and confidently write their first Haskell application.

By exploring a simple example, the talk will demonstrate how and when to apply various techniques
and abstractions. Furthermore, it will alleviate the burden of navigating the Haskell ecosystem to
find solutions to common problems such as options parsing. In addition, the talk aims to motivate
people who might not feel ready to take on an application to give it a go. Finally, it shall be
demonstrated that Haskell is a useful, general purpose programming language that can be used for
common tasks, while bringing with it a range of benefits.

### Description

The talk will start with a brief description of the motivation and goals of the talk, followed by a
description of the application being developed. From here, each requirement of the application will
be explained, and the chosen solution presented, including code snippets from the example
application.

Rather than deep diving into any of the topics covered, the idea is to provide enough detail and
signposting to allow people to confidently build on the example or use it as a template. The
completed example will be available publicly under an open source license from the day of the talk.
