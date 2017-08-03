# Types

##

<!--
Haskell programmers talk a lot about types, and with good reason.

 - Model the domain
 - Reduce the number of possible programs
 - Less need for documentation
-->

```haskell
data Comment =
  Comment { _commentId    :: Integer
          , _commentTopic :: Topic
          , _commentBody  :: CommentText
          , _commentTime  :: UTCTime
          }
          deriving Show
```

##

```haskell
data ParleyRequest = AddRequest Topic CommentText
                   | ViewRequest Topic
                   | ListRequest
```

<!--
Mentioned our "spec" before with 3 operations. Put them in a sum type.
CLOSED TYPE - there are exactly 3 possible requests we'll have to handle. Compare
that to the universe of strings or an open inheritance hierarchy.

With warnings turned on and warnings as errors, we get a compile-time error anywhere our code
doesn't account for the new request.
-->

##

```haskell
data Error = NoTopicInRequest
           | UnknownRoute
           | NoCommentText
           | SQLiteError SQLiteResponse
```

<!--
Note that we use sqlite-simple-errors to catch SQLite exceptions and turn them into errors
Same benefits of sum types - these are ALL possible errors.
-->

##

```haskell
data Config = Config { port   :: Port
                     , dbPath :: FilePath
                     }
```

## Smart constructors

##

```haskell
newtype Topic = Topic {getTopic :: Text}
                deriving (Eq, Show)

newtype CommentText = CommentText {getComment :: Text}
                      deriving (Eq, Show)
```

<!--
We use newtypes as "free" wrappers around Text fields.
 - prevents mistakes by allowing the type system to tell us when we're using the wrong `Text`
 - makes it clear which values are which
 - acts as documentation
 - free because the type information gets stripped away at compile time and becomes whatever
   the contained type is - in this case `Text`
-->

##

```haskell
class FromRow a where
  fromRow :: RowParser a

module Parley.Types ( ...
                    , Topic (getTopic)
                    , CommentText (getComment)
                    ...
                    )
```

## Instances

##

```haskell
instance FromRow Comment where
  fromRow = Comment <$> field <*> field <*> field <*> field
```

<!--
`field :: FromField a => Database.SQLite.Simple.Internal.RowParser a`

Each call to `field` _must_ correspond, in order, to fields returned by a query
-->

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

