# Types

##

```haskell
data Comment =
  Comment { _commentId      :: Integer
          , _commentTopic   :: Text
          , _commentComment :: Text
          , _commentTime    :: UTCTime
          }
          deriving Show
```

##

```haskell
data ParleyRequest = AddRequest Topic CommentText
                   | ViewRequest Topic
                   | ListRequest
```

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
data Error = NoTopicInRequest
           | UnknownRoute
           | NoCommentText
           | SQLiteError SQLiteResponse
```

<!-- Note that we use sqlite-simple-errors to catch SQLite exceptions and turn them into errors -->

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

