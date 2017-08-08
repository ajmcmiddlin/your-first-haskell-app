# Command Line Arguments

## optparse-applicative

##

```haskell
partialConfigParser :: Parser PartialConfig
partialConfigParser =
  PartialConfig <$> portParser <*> dbParser
```

##

```shell
parley - simple comment management

Usage: parley [-p|--port PORT] [-d|--database SQLITE_FILE]
  Manage comments for a web blog

Available options:
  -p,--port PORT           TCP port to accept requests on
  -d,--database SQLITE_FILE
                           Path to sqlite database
  -h,--help                Show this help text
```

##

`execParser :: Parser     a -> IO a`

##

```haskell
dbParser :: Parser (Last FilePath)
dbParser =
  
  
  
  
               optional  strOption
```

##

```haskell
dbParser :: Parser (Last FilePath)
dbParser =
  
  
  
  
      Last <$> optional  strOption
```

##

```haskell
dbParser :: Parser (Last FilePath)
dbParser =
  let mods =  long "database"
           <> short 'd'
           <> metavar "SQLITE_FILE"
           <> help "Path to sqlite database"
   in Last <$> optional (strOption mods)
```

##

```haskell
portParser :: Parser (Last Port)
portParser =
  let mods =  long "port"
           <> short 'p'
           <> metavar "PORT"
           <> help "TCP port to accept requests on"
   in Last <$> optional (option auto mods)
```

##

```haskell
 
 
 
 
 
 
                        (option auto mods)
```

##

> A parser for things is a function from strings to lists of pairs of things and strings.  
> <p style="text-align: right; padding-right: 2em; display: block;">-- Fritz Ruehr</p>

##

```haskell
ReadS :: String -> [(a, String)]
  
class Read where
  readsPrec :: Int -> ReadS a
  ...
  
instance Read Port where
  readsPrec =
    let portIt (n, s) = (Port n, s)
    in fmap (fmap portIt) . readsPrec
```

##

`execParser :: Parser     a -> IO a`

##

`execParser :: ParserInfo a -> IO a`

##

```haskell
commandLineParser :: ParserInfo PartialConfig
commandLineParser =
  
  
  
      info             partialConfigParser
```

##

```haskell
commandLineParser :: ParserInfo PartialConfig
commandLineParser =
  
  
  
      info (helper <*> partialConfigParser)
```

##

```haskell
commandLineParser :: ParserInfo PartialConfig
commandLineParser =
  let mods =  fullDesc
           <> progDesc "Manage comments for a web blog"
           <> header "parley - simple comment management"
   in info (helper <*> partialConfigParser) mods
```

