# Configuration

##

![partial options post](images/partial-options.png)

##

```haskell
data Config =
  Config { port   :: Port
         , dbPath :: FilePath
         }
```

##

```haskell
data PartialConfig =
  PartialConfig { pcPort   :: Last Port
                , pcDBPath :: Last FilePath
                }
```

##

```haskell
newtype Last a = Last {getLast :: Maybe a}

instance Monoid (Last a) where
  mempty = Last Nothing
  l `mappend` Last Nothing = l
  _ `mappend` r            = r
```

##

```haskell
instance Monoid PartialConfig where
  mempty = PartialConfig mempty mempty
  mappend a b = mempty { pcPort = pcPort a <> pcPort b
                       , pcDBPath = pcDBPath a <> pcDBPath b
                       }
```

##

```haskell
 
 
 
 
           (defaultConfig <> fileConfig <> commandLineConfig)
 
```

##

```haskell
parseOptions :: FilePath -> IO (Either String Config)
parseOptions configFilePath = do
  fileConfig <- parseConfigFile configFilePath
  commandLineConfig <- parseCommandLine
  let pc = (defaultConfig <> fileConfig <> commandLineConfig)
  pure (makeConfig pc)
```

##

```haskell
makeConfig pc = do
  let lastToEither e (Last m) = maybe (Left e) Right m
  port' <- lastToEither "Missing port" (pcPort pc)
  dbPath' <- lastToEither "Missing database path" (pcDBPath pc)
  pure Config {port = port', dbPath = dbPath'}
{-# LANGUAGE RecordWildCards #-}

makeConfig :: PartialConfig -> Either String Config
makeConfig PartialConfig {..} = do
 
  port <- lastToEither "Missing port" pcPort
  dbPath <- lastToEither "Missing database path" pcDBPath
 
```

##

```haskell
makeConfig pc = do
  let lastToEither e (Last m) = maybe (Left e) Right m
  port' <- lastToEither "Missing port" (pcPort pc)
  dbPath' <- lastToEither "Missing database path" (pcDBPath pc)
  pure Config {port = port', dbPath = dbPath'}
```

##

```haskell
{-# LANGUAGE RecordWildCards #-}

makeConfig :: PartialConfig -> Either String Config
makeConfig PartialConfig {..} = do
  let lastToEither e (Last m) = maybe (Left e) Right m
  port <- lastToEither "Missing port" pcPort
  dbPath <- lastToEither "Missing database path" pcDBPath
  pure Config {..}
```

