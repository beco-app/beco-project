# Backend directory


## Connection to EC2 instance (server)

You need the authentication file `BECO.pem`. If you don't, please contact @jguaschmarti

Make sure you have the correct permissions over the `pem` file. Type `chmod 400 BECO.pem` the first time to set the proper permissions.

Connection command:
```
ssh -i BECO.pem ubuntu@18.219.12.116
```

## Connection to remote mongo instance

- **Tunnel**: 

``` 
ssh -i BECO.pem -N -L 27017:localhost:27017 ubuntu@18.219.12.116
```
