# Prereqs

The following CLI utilities are required:
 - `docker`
 - `aws` (configured with your AWS credentials)
 - `kubectl`
 - `eksctl`

# Steps

	0. Set some environment variables to simplify steps to follow:

```bash
export AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
export AWS_REGION=<your choice of AWS region here>
export ECR=$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/rhn-skip-example
```

	1. Create a cluster using EKS auto-mode: `eksctl create cluster
	--enable-auto-mode --name skip-quickstart --region $AWS_REGION`. Note that
	it can take some time for your cluster to be spun up in AWS -- it's normal
	for the command to be "waiting for CloudFormation stack" for ~10 minutes.
	
	2. Create an ECR repository to hold custom docker images: `aws ecr
	create-repository --repository-name rhn-skip-example --region $AWS_REGION`,
	then authenticate your local docker client to that repository: `aws ecr
	get-login-password --region $AWS_REGION | docker login --username AWS
	--password-stdin $ECR`
	
	3. Build and push docker images for the Reactive HackerNews example:

```bash
for image in web_service reactive_service www db reverse_proxy ; do
  docker build --platform linux/amd64 --tag rhn-$image-aws $image
  docker tag rhn-$image-aws $ECR:$image;
  docker push $ECR:$image;
done
```

	4. Set up permissions for your EKS cluster to pull those docker images from ECR

```bash
TOKEN=$(aws ecr --region=eu-north-1 get-authorization-token \
	    --output text --query authorizationData\[\].authorizationToken \
		| base64 -d | cut -d: -f2 )
kubectl create secret docker-registry rhn-skip-ecr-registry \
  --docker-server=https://$ECR --docker-username=AWS \
  --docker-password="${TOKEN}" --docker-email=user@example.com
```



```bash
for f in kubernetes/eks/*.yaml ; do
	sed <$f s%__ECR__%$ECR% | kubectl apply -f - ;
done

kubectl create configmap haproxy-auxiliary-configmap \
    --from-file kubernetes/distributed_skip/haproxy-aux.cfg
helm repo add haproxytech https://haproxytech.github.io/helm-charts
helm repo update
helm install haproxy haproxytech/kubernetes-ingress \
	-f kubernetes/distributed_skip/haproxy-helm-config \
	--set controller.service.type=LoadBalancer
```
