#! /bin/bash

set -x
set -e

# this script will build a docker container and push it to the shared registry

# it's hideous. it will only work for gds and relies on his personal setup and access keys.
# but better than no docs at all, right?

cd ~/code/skfs || exit 1

find . -name state.db|xargs rm

echo "Building skgw image"
docker build -t skgw-deploy --progress=plain -f sql/server/deploy/Dockerfile .

cd ~/code/skfs/sql/server/proxy || exit 1

echo "Building nginx image"
docker build -t nginx-deploy --progress=plain -f Dockerfile .

echo "Logging docker in to AWS repo"
aws ecr get-login-password --region us-east-1 |
    docker login --username AWS --password-stdin 400962513797.dkr.ecr.us-east-1.amazonaws.com

echo "Pushing skgw"
docker tag skgw-deploy:latest 400962513797.dkr.ecr.us-east-1.amazonaws.com/skdb:latest
docker push 400962513797.dkr.ecr.us-east-1.amazonaws.com/skdb:latest

echo "Pushing nginx"
docker tag nginx-deploy:latest 400962513797.dkr.ecr.us-east-1.amazonaws.com/nginx:latest
docker push 400962513797.dkr.ecr.us-east-1.amazonaws.com/nginx:latest

# pulling down and running the container is entirely manual right now. I'm not even scripting it.
# but the steps are:

# ssh corp # get on to the bastion

# aws ecr get-login-password --region us-east-1 | sudo docker login --username AWS --password-stdin 400962513797.dkr.ecr.us-east-1.amazonaws.com
# sudo /usr/bin/docker pull 400962513797.dkr.ecr.us-east-1.amazonaws.com/nginx:latest
# sudo docker stop $(sudo docker ps -q)
# sudo /usr/bin/docker run -p 443:443 -v /etc/letsencrypt:/etc/letsencrypt 400962513797.dkr.ecr.us-east-1.amazonaws.com/nginx:latest

# ssh -i ~/.ssh/gds_id_ed25519 ubuntu@10.0.131.45 # get on to the replication server

# aws ecr get-login-password --region us-east-1 | sudo docker login --username AWS --password-stdin 400962513797.dkr.ecr.us-east-1.amazonaws.com
# sudo /usr/bin/docker pull 400962513797.dkr.ecr.us-east-1.amazonaws.com/skdb:latest

# port over any databases, here's an example
# sudo docker exec -it -w /skfs -e INSIDE_EMACS=1 <CONTAINER> /bin/bash
# build/skdb dump --data /var/db/skdb_service_mgmt.db
# sudo docker stop $(sudo docker ps -q)
# sudo /usr/bin/docker run -it -p 8080:8080 -v /var/db:/var/db 400962513797.dkr.ecr.us-east-1.amazonaws.com/skdb:latest /bin/bash
# rm /var/db/skdb_service_mgmt.db
# build/skdb --init /var/db/skdb_service_mgmt.db
# build/skdb --data /var/db/skdb_service_mgmt.db << EOF

# sudo /usr/bin/docker run -p 8080:8080 -v /var/db:/var/db 400962513797.dkr.ecr.us-east-1.amazonaws.com/skdb:latest
