# Backend directory


## Connection to EC2 instance (server)

You need the authentication file `BECO.pem`. If you don't, please contact @jguaschmarti

Make sure you have the correct permissions over the `pem` file.

Permissions:
```
chmod 400 BECO.pem
```

Connection command:
```
ssh -i BECO.pem ubuntu@34.252.26.132
```

## Connection to remote mongo instance

- **Tunnel**: 

``` 
ssh -i BECO.pem -N -L 27017:localhost:27017 ubuntu@34.252.26.132
```


## Restart connection to mongo

```
sudo systemctl stop mongod
sudo systemctl start mongod
```
