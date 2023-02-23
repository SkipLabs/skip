#! /bin/zsh

set -x
set -e

# this script will build a docker container and push it to the shared registry

# it's hideous. it will only work for gds and relies on his personal setup and access keys.
# but better than no docs at all, right?

cd ~/code/skfs

docker build -t deploy --progress=plain -f sql/server/deploy/Dockerfile .

aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 400962513797.dkr.ecr.us-east-1.amazonaws.com
docker tag deploy:latest 400962513797.dkr.ecr.us-east-1.amazonaws.com/skdb:latest
docker push 400962513797.dkr.ecr.us-east-1.amazonaws.com/skdb:latest

# pulling down and running the container is entirely manual right now. I'm not even scripting it.
# but the steps are:
# ssh corp # get on to the bastion
# ssh -i ~/.ssh/gds_id_ed25519 ubuntu@10.0.131.45 # get on to the replication server
# aws ecr get-login-password --region us-east-1 | sudo docker login --username AWS --password-stdin 400962513797.dkr.ecr.us-east-1.amazonaws.com
# sudo /usr/bin/docker pull 400962513797.dkr.ecr.us-east-1.amazonaws.com/skdb:latest
# sudo docker stop $(sudo docker ps -q)
# sudo /usr/bin/docker run -p 8080:8080 -v /var/db:/var/db 400962513797.dkr.ecr.us-east-1.amazonaws.com/skdb:latest
