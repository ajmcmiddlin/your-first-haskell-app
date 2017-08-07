# Data flow

## Wai

> Web Application Interface: a low level interface between web servers and applications

<!-- Standard interface for web applications - think Rack in Ruby, WSGI in Pythong.
Can talk to multiple servers -->

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

<!--
Still `Request -> Response` for our purposes.
Callback is to ensure resources aren't cleaned up before response is evaluated - lazy IO
-->

##

```haskell
app :: ParleyDb
    -> Request
    -> (Response -> IO ResponseReceived)
    -> IO ResponseReceived
```

##

```haskell
app :: ParleyDb
    -> Request
    -> (Response -> IO ResponseReceived)
    -> IO ResponseReceived
app db request cb = do
 
 

 
 
 
  erq <- mkRequest request
  
  
```

##

```haskell
app :: ParleyDb
    -> Request
    -> (Response -> IO ResponseReceived)
    -> IO ResponseReceived
app db request cb = do
  let handleRq (Left e) = pure (Left e)
      handleRq (Right r) = handleRequest db r

      
      

  erq <- mkRequest request
  ersp <- handleRq erq
  
```

##

```haskell
app :: ParleyDb
    -> Request
    -> (Response -> IO ResponseReceived)
    -> IO ResponseReceived
app db request cb = do
  let handleRq (Left e) = pure (Left e)
      handleRq (Right r) = handleRequest db r

      handleRsp (Left e) = handleError e
      handleRsp (Right rsp) = rsp

  erq <- mkRequest request
  ersp <- handleRq erq
  cb (handleRsp ersp)
```

##

```haskell
mkRequest :: Request
          -> IO (Either Error ParleyRequest)

handleRequest :: ParleyDb
              -> ParleyRequest
              -> IO (Either Error Response)

handleError :: Error
            -> Response
```

## Routing

##

```haskell
mkRequest :: Request
          -> IO (Either Error ParleyRequest)
mkRequest request =
  case pathInfo request of
 

 
    ["list"]   -> pure (Right ListRequest)
 
```

##

```haskell
mkRequest :: Request
          -> IO (Either Error ParleyRequest)
mkRequest request =
  case pathInfo request of
 

    [t,"view"] -> pure (mkViewRequest t)
    ["list"]   -> pure (Right ListRequest)
 
```

##

```haskell
mkRequest :: Request
          -> IO (Either Error ParleyRequest)
mkRequest request =
  case pathInfo request of
    [t,"add"]  -> fmap (mkAddRequest t)
                       (strictRequestBody request)
    [t,"view"] -> pure (mkViewRequest t)
    ["list"]   -> pure (Right ListRequest)
 
```

##

```haskell
mkRequest :: Request
          -> IO (Either Error ParleyRequest)
mkRequest request =
  case pathInfo request of
    [t,"add"]  -> fmap (mkAddRequest t)
                       (strictRequestBody request)
    [t,"view"] -> pure (mkViewRequest t)
    ["list"]   -> pure (Right ListRequest)
    _          -> pure (Left UnknownRoute)
```

## Request -> Response

##

```haskell
handleRequest :: ParleyDb
              -> ParleyRequest
              -> IO (Either Error Response)
handleRequest db rq =
  case rq of
    AddRequest t c -> handleAdd db t c
 
 
```

##

```haskell
handleRequest :: ParleyDb
              -> ParleyRequest
              -> IO (Either Error Response)
handleRequest db rq =
  case rq of
    AddRequest t c -> handleAdd db t c
    ViewRequest t  -> dbJSONResponse $ getComments db t
 
```

##

```haskell
handleRequest :: ParleyDb
              -> ParleyRequest
              -> IO (Either Error Response)
handleRequest db rq =
  case rq of
    AddRequest t c -> handleAdd db t c
    ViewRequest t  -> dbJSONResponse $ getComments db t
    ListRequest    -> dbJSONResponse $ getTopics db
```

##

```haskell
dbJSONResponse :: ToJSON a
               => IO (Either Error a)
               -> IO (Either Error Response)
 
 
 
 
 
 
 
```

##

```haskell
dbJSONResponse :: ToJSON a
               => IO (Either Error a)
               -> IO (Either Error Response)
dbJSONResponse iea = do
 
 
 
 
  ea <- iea
 
```

##

```haskell
dbJSONResponse :: ToJSON a
               => IO (Either Error a)
               -> IO (Either Error Response)
dbJSONResponse iea = do
 
 
 
 
  ea <- iea
  pure (fmap responseFromJSON ea)
```

##

```haskell
dbJSONResponse :: ToJSON a
               => IO (Either Error a)
               -> IO (Either Error Response)
dbJSONResponse iea = do
  let responseFromJSON a =
        responseLBS HT.status200
                    [contentHeader JSON]
                    (encode a)
  ea <- iea
  pure (fmap responseFromJSON ea)
```

## Error -> Response

##

```haskell
handleError :: Error -> Response
handleError e =
  case e of
 
 
    UnknownRoute ->
      rsp HT.status404 "Not found :("
 
 
 
 
 
 
 
```

##

```haskell
handleError :: Error -> Response
handleError e =
  case e of
    NoTopicInRequest ->
      rsp HT.status400 "Empty topics not allowed"
    UnknownRoute ->
      rsp HT.status404 "Not found :("
    NoCommentText ->
      rsp HT.status400 "Empty body text not allowed"
 
 
 
 
 
```

##

```haskell
handleError :: Error -> Response
handleError e =
  case e of
    NoTopicInRequest ->
      rsp HT.status400 "Empty topics not allowed"
    UnknownRoute ->
      rsp HT.status404 "Not found :("
    NoCommentText ->
      rsp HT.status400 "Empty body text not allowed"
    SQLiteError se ->
      rsp HT.status500 (dbError se)
 
 
 
```

##

```haskell
handleError :: Error -> Response
handleError e =
  case e of
    NoTopicInRequest ->
      rsp HT.status400 "Empty topics not allowed"
    UnknownRoute ->
      rsp HT.status404 "Not found :("
    NoCommentText ->
      rsp HT.status400 "Empty body text not allowed"
    SQLiteError se ->
      rsp HT.status500 (dbError se)
  where
 
    dbError se = "Database error: " <> LBS8.pack (show se)
```

##

```haskell
handleError :: Error -> Response
handleError e =
  case e of
    NoTopicInRequest ->
      rsp HT.status400 "Empty topics not allowed"
    UnknownRoute ->
      rsp HT.status404 "Not found :("
    NoCommentText ->
      rsp HT.status400 "Empty body text not allowed"
    SQLiteError se ->
      rsp HT.status500 (dbError se)
  where
    rsp s t = responseLBS s [contentHeader PlainText] t
    dbError se = "Database error: " <> LBS8.pack (show se)
```

