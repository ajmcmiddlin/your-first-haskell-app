# App {data-background-image="images/the-app.png"}

## Requirements

##

I want comments on my static blog, but I don't want to deploy a database or use
a third party service

##

> Par·ley n.  
>   
> To have a discussion, especially with an enemy.

## {data-background-image="images/comment-section.jpg" data-background-size=contain}

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

##

**ONLY AN EDUCATIONAL EXAMPLE**

<!-- Not because we can't, but in the interests of simplicity of explanation in a 25 minute talk-->

## Proof

## {data-background-image="images/demo-list.png" data-background-size="contain"}

## {data-background-image="images/demo-view.png"  data-background-size="contain"}

## {data-background-image="images/demo-not-found.png"  data-background-size="contain"}

## {data-background-image="images/keep_calm_and_carry_on.jpg"}

