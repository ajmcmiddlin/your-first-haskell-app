# Data flow

## Wai

> Web Application Interface: a low level interface between web servers and applications

##

```haskell
app :: Request -> IO Response
```

##

```haskell
app :: Request
    -> (Response -> IO ResponseReceived)
    -> IO ResponseReceived
```

##

```haskell
app :: Connection
    -> Request
    -> (Response -> IO ResponseReceived)
    -> IO ResponseReceived
```

##

```haskell
app :: Connection
    -> Request
    -> (Response -> IO ResponseReceived)
    -> IO ResponseReceived
app conn request response = do
  rq <- mkRequest request
  rsp <- either (pure . Left) (handleRequest conn) rq
  response $ either handleError id rsp
```

##

```haskell
mkRequest :: Request
          -> IO (Either Error ParleyRequest)

handleRequest :: Connection
              -> ParleyRequest
              -> IO (Either Error Response)

handleError :: Error
            -> Response
```

##

```haskell
mkRequest :: Request
          -> IO (Either Error ParleyRequest)
mkRequest request =
  case pathInfo request of
    [t,"add"]  -> mkAddRequest t <$> strictRequestBody request
    [t,"view"] -> pure $ mkViewRequest t
    ["list"]   -> pure (Right ListRequest)
    _          -> pure (Left UnknownRoute)
```

##

```haskell
handleRequest :: Connection
              -> ParleyRequest
              -> IO (Either Error Response)
handleRequest conn r =
  case r of
    AddRequest topic comment -> handleAdd conn topic comment
    ViewRequest t            -> dbJSONResponse $ getComments conn t
    ListRequest              -> dbJSONResponse $ getTopics conn
```

##

```haskell
dbJSONResponse :: ToJSON a
               => IO (Either Error a)
               -> IO (Either Error Response)
dbJSONResponse =
  let responseFromJSON =
        responseLBS HT.status200 [contentHeader JSON] . encode
   in (=<<) (pure . fmap responseFromJSON)

```

