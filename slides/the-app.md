# The app

##

> Par·ley n.  
>   
> To have a discussion, especially with an enemy.

##

<img alt="meanwhile, at the YouTube comment section" src="images/comment-section.jpg" />

## Requirements

##

I want comments on my static blog, but I don't want to deploy a database or use
a third party service

## Spec

##

Operation                     Route
---------------------------   ---------------
Add to a topic                /&lt;topic&gt;/add
View comments for a topic     /&lt;topic&gt;/view
List topics                   /list

##

<div id="logos">
 <div id="haskell-logo-wrapper">
  <img alt="Haskell logo" src="images/haskell-logo.svg" id="haskell-logo" class="logo" />
 </div>
 <div id="plus-between-logos">+</div>
 <div id="sqlite-logo-wrapper">
  <img alt="SQLite logo" src="images/sqlite-logo.svg" id="sqlite-logo" class="logo" />
 </div>
</div>
<div style="clear: both;"></div>

##

**ONLY AN EDUCATIONAL EXAMPLE**

<!-- Not because we can't, but in the interests of simplicity of explanation in a 25 minute talk-->

## Assumed knowledge

##

`Maybe`  
`Either`  
`Monoid`  
`Functor`  
`Applicative`  
`Monad`  

##

..._BUT_ you haven't written an application

## Libraries

##

Library                     Purpose
------------------------    ----------------------------
`aeson`                     JSON encoding
`sqlite-simple`             Talk to SQLite
`sqlite-simple-errors`      Exceptions to values
`optparse-applicative`      Command line parsing
`wai`                       Web application interface
`warp`                      Web server

