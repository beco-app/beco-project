# Backend directory


## Connection to EC2 instance (server)

You need the authentication file `BECO.pem`. If you don't, please contact @jguaschmarti

Make sure you have the correct permissions over the `pem` file. Type `chmod go-r BECO.pem` the first time to set the proper permissions.

Connection command:
```
ssh -i BECO.pem ubuntu@3.145.208.2
```

## Connection to remote mongo instance

- **Tunnel**: ``` ssh -i BECO.pem -N -L 27017:localhost:27017 ubuntu@3.145.208.2 
 
```
