# Database

## sqlite-simple-errors

```haskell
type DatabaseResponse a = Either SQLiteResponse a

runDBAction :: IO a -> IO (DatabaseResponse a)
```

## ParleyDb

```haskell
data ParleyDb = ParleyDb Connection Table
```

## Queries

```haskell
newtype Query = Query {fromQuery Text}

query :: (ToRow q, FromRow r)
      => Connection -> Query -> q -> IO [r]

execute :: ToRow q
        => Connection -> Query -> q -> IO ()
```

## Only

```haskell
newtype Only a = Only {fromOnly :: a}
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

## Pattern

##

```haskell
dbToParley ::
              IO [a]
           
 
 
 
 
 
```

##

```haskell
dbToParley ::
              IO [a]
           -> IO (Either Error [b])
 
 
 
 
 
```

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

## Viewing

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

