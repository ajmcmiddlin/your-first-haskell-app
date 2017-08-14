# Types

##

> - Model the domain
> - Prevents certain classes of errors
> - Reduces the number of possible programs
> - Documents our code

##

```haskell
data Comment = Comment CommentId
                       Topic
                       CommentText
                       UTCTime
               deriving Show
```

<!--
Note that each component of our product has a meaningful type. Haskell makes it
easy and convenient to do this.
-->

##

```haskell
data Error = NoTopicInRequest
           | UnknownRoute
           | NoCommentText
           | SQLiteError SQLiteResponse
```

<!--
 - Errors as values, NOT exceptions
 - SQLiteResponse comes from sqlite-simple-errors - wrap it up for our app
 - All of our application errors in one place.
 - Compilers stops us adding a new one and not handling it
-->

##

```haskell
data ContentType = PlainText
                 | JSON

render :: ContentType -> ByteString
render PlainText = "text/plain"
render JSON      = "text/json"
```

<!--
Foreshadowing - responses take the content type header as a ByteString.
Once again, we care about two content types, not the infinite universe of strings, so lock it down with a sum type.
-->

## Operations as data

```haskell
data ParleyRequest = AddRequest Topic CommentText
                   | ViewRequest Topic
                   | ListRequest
```

<!--
 - Correspondance to our spec.
 - Compare to the universe of strings or an open inheritance hierarchy.
 - Exhaustive pattern matches
-->

## newtype

##

<img alt="If you're asking whether you should newtype, you should newtype"
     src="images/newtype.png" />

<!--
https://twitter.com/mattoflambda/status/892113796927324160

 - Not an alias - a whole new type that fails to type check
 - Prevents mistakes by allowing the type system to tell us when we're using the wrong `Text`
 - acts as documentation
 - Wrapper disappears at compile time
-->

##

```haskell
newtype Table = Table Text
                deriving (Show)

newtype CommentId = CommentId Integer
                    deriving (Eq, Show, ToJSON)

newtype Port = Port { unPort :: Int16 }
               deriving Show
```

## Smart constructors

##

```haskell
newtype Topic = Topic {getTopic :: Text}
                deriving (Eq, Show)

newtype CommentText = CommentText {getComment :: Text}
                      deriving (Eq, Show)
```

##

```haskell
module Parley.Types ( ...
                    , Topic (getTopic)
                    , CommentText (getComment)
                    ...
                    )
```

##

```haskell
mkTopic :: Text -> Either Error Topic
mkTopic "" = Left NoTopicInRequest
mkTopic t  = pure $ Topic t

mkCommentText :: Text -> Either Error CommentText
mkCommentText "" = Left NoCommentText
mkCommentText t  = pure $ CommentText t
```

##

```haskell
module Parley.Types ( ...
                    , Topic (getTopic)
                    , CommentText (getComment)
                    , mkTopic
                    , mkCommentText
                    ...
                    )
```

## Untyped at the border

##

```haskell
data DbComment =
  DbComment { dbCommentId    :: Integer
            , dbCommentTopic :: Text
            , dbCommentBody  :: Text
            , dbCommentTime  :: UTCTime
            }
            deriving Show
```

<!--
Our database doesn't know about our types. So we use more clumsy representations, but
only at the edges of our system.
-->

## JSON

##

```haskell
instance ToJSON Comment where
  toJSON (Comment id' topic comment time) =
    object [ "id" .= id'
           , "topic" .= topic
           , "comment" .= comment
           , "time" .= time
           ]

  toEncoding (Comment id' topic comment time) =
    pairs (  "id" .= id'
          <> "topic" .= topic
          <> "comment" .= comment
          <> "time" .= time
          )
```

<!--
Could have got these for free, but names would correspond to field names in
record - not as nice
-->

