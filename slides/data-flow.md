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
app :: Connection
    -> Request
    -> (Response -> IO ResponseReceived)
    -> IO ResponseReceived
app conn request response = do
  rq <- mkRequest request
  rsp <- either (pure . Left) (handleRequest conn) rq
  response $ either handleError id rsp
```
