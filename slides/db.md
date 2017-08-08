# Database

## sqlite-simple-errors

##

```haskell
type DatabaseResponse a = Either SQLiteResponse a

runDBAction :: IO a -> IO (DatabaseResponse a)
```

## Initialisation

##

```haskell
initDB :: FilePath
       -> Table
       -> IO (Either SQLiteResponse ParleyDb)







 
```

##

```haskell
initDB :: FilePath
       -> Table
       -> IO (Either SQLiteResponse ParleyDb)
initDB dbPath t@(Table tbl) = runDBAction $ do




  conn <- open dbPath

  pure (ParleyDb conn t)
```

##

```haskell
initDB :: FilePath
       -> Table
       -> IO (Either SQLiteResponse ParleyDb)
initDB dbPath t@(Table tbl) = runDBAction $ do
  let createQ =
        Query ("CREATE TABLE IF NOT EXISTS " <> tbl
            <> " (id INTEGER PRIMARY KEY, topic TEXT,"
            <> "  comment TEXT, time INTEGER)")
  conn <- open dbPath
  execute_ conn createQ
  pure (ParleyDb conn t)
```

## helper

##

```haskell
dbToParley :: (a -> Either Error b)
           -> IO [a]
           -> IO (Either Error [b])
 
 
 
 
 
```

##

```haskell
dbToParley :: (a -> Either Error b)
           -> IO [a]
           -> IO (Either Error [b])
dbToParley f a = do
  result <- runDBAction a
  
  
  
```

##

```haskell
dbToParley :: (a -> Either Error b)
           -> IO [a]
           -> IO (Either Error [b])
dbToParley f a = do
  result <- runDBAction a
  case result of
    Left e   -> (pure . Left . SQLiteError) e
 
```

##

```haskell
dbToParley :: (a -> Either Error b)
           -> IO [a]
           -> IO (Either Error [b])
dbToParley f a = do
  result <- runDBAction a
  case result of
    Left e   -> (pure . Left . SQLiteError) e
    Right as -> (pure . Right . rights . fmap f) as
```

## Listing

##

```haskell
getTopics :: ParleyDb -> IO (Either Error [Topic])
 
 
 
 
```

##

```haskell
getTopics :: ParleyDb -> IO (Either Error [Topic])
getTopics (ParleyDb conn (Table t)) =
  let q = Query ("SELECT DISTINCT(topic) FROM " <> t)
 
 
```

##

```haskell
getTopics :: ParleyDb -> IO (Either Error [Topic])
getTopics (ParleyDb conn (Table t)) =
  let q = Query ("SELECT DISTINCT(topic) FROM " <> t)
      result = query_ conn q
 
```

##

```haskell
getTopics :: ParleyDb -> IO (Either Error [Topic])
getTopics (ParleyDb conn (Table t)) =
  let q = Query ("SELECT DISTINCT(topic) FROM " <> t)
      result = query_ conn q
   in dbToParley (mkTopic . fromOnly) result
```

## Viewing

##

`DbComment -> Comment`

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

##

```haskell
data Comment = Comment CommentId
                       Topic
                       CommentText
                       UTCTime
               deriving Show
```
               
##

```haskell
fromDbComment :: DbComment -> Either Error Comment
 
 
 
 
 
```

##

```haskell
fromDbComment :: DbComment -> Either Error Comment
fromDbComment dbc =
  Comment     (CommentId (dbCommentId dbc))
 
 
 
```

##

```haskell
fromDbComment :: DbComment -> Either Error Comment
fromDbComment dbc =
  Comment     (CommentId (dbCommentId dbc))
          <$> mkTopic (dbCommentTopic dbc)
 
 
```

##

```haskell
fromDbComment :: DbComment -> Either Error Comment
fromDbComment dbc =
  Comment     (CommentId (dbCommentId dbc))
          <$> mkTopic (dbCommentTopic dbc)
          <*> mkCommentText (dbCommentBody dbc)
 
```

##

```haskell
fromDbComment :: DbComment -> Either Error Comment
fromDbComment dbc =
  Comment     (CommentId (dbCommentId dbc))
          <$> mkTopic (dbCommentTopic dbc)
          <*> mkCommentText (dbCommentBody dbc)
          <*> pure (dbCommentTime dbc)
```

##

```haskell
getComments :: ParleyDb
            -> Topic
            -> IO (Either Error [Comment])
  
  
  
  
  
 
```

##

```haskell
getComments :: ParleyDb
            -> Topic
            -> IO (Either Error [Comment])
getComments (ParleyDb conn _) t =
  let q =  "SELECT id, topic, comment, time "
        <> "FROM comments WHERE topic = ?"
      p = Only (getTopic t)
  
  
```

##

```haskell
getComments :: ParleyDb
            -> Topic
            -> IO (Either Error [Comment])
getComments (ParleyDb conn _) t =
  let q =  "SELECT id, topic, comment, time "
        <> "FROM comments WHERE topic = ?"
      p = Only (getTopic t)
      result = query conn q p
  
```

##

```haskell
getComments :: ParleyDb
            -> Topic
            -> IO (Either Error [Comment])
getComments (ParleyDb conn _) t =
  let q =  "SELECT id, topic, comment, time "
        <> "FROM comments WHERE topic = ?"
      p = Only (getTopic t)
      result = query conn q p
   in dbToParley fromDbComment result
```

## Adding

##

```haskell
addCommentToTopic :: ParleyDb
                  -> Topic
                  -> CommentText
                  -> IO (Either Error ())
```

##

```haskell
addCommentToTopic (ParleyDb conn (Table table)) t c = do
 
  let q = Query ("INSERT INTO " <> table
              <> "(topic, comment, time) "
              <> "VALUES (:topic, :comment, :time)")
 
 
 
 
 
 
 
 
```

##

```haskell
addCommentToTopic (ParleyDb conn (Table table)) t c = do
  now <- getCurrentTime
  let q = Query ("INSERT INTO " <> table
              <> "(topic, comment, time) "
              <> "VALUES (:topic, :comment, :time)")
      params = [ ":topic" := getTopic t
               , ":comment" := getComment c
               , ":time" := now
               ]
 
 
 
 
```

##

```haskell
addCommentToTopic (ParleyDb conn (Table table)) t c = do
  now <- getCurrentTime
  let q = Query ("INSERT INTO " <> table
              <> "(topic, comment, time) "
              <> "VALUES (:topic, :comment, :time)")
      params = [ ":topic" := getTopic t
               , ":comment" := getComment c
               , ":time" := now
               ]
  result <- runDBAction (executeNamed conn q params)
 
 
 
```

##

```haskell
addCommentToTopic (ParleyDb conn (Table table)) t c = do
  now <- getCurrentTime
  let q = Query ("INSERT INTO " <> table
              <> "(topic, comment, time) "
              <> "VALUES (:topic, :comment, :time)")
      params = [ ":topic" := getTopic t
               , ":comment" := getComment c
               , ":time" := now
               ]
  result <- runDBAction (executeNamed conn q params)
  case result of
    Left e -> pure (Left (SQLiteError e))
    Right a -> pure (Right a)
```

