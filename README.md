# docker-webmin

To run

`docker build -t oracle-webmin .`

`docker run -d --name webmin-server -p 10000:10000 oracle-webmin`

`echo "your_secure_password" | docker exec -i webmin-container passwd --stdin YOUR PASSWORD`

### default username root
