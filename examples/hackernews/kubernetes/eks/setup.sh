#!/bin/bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to prompt for confirmation
confirm() {
    read -p "$1 (y/N): " -n 1 -r
    echo
    [[ $REPLY =~ ^[Yy]$ ]]
}

# Function to wait for user input
wait_for_user() {
    read -p "Press Enter to continue..."
}

print_status "Starting EKS Reactive HackerNews Setup"
echo

# Step 0: Check prerequisites
print_status "Checking prerequisites..."

missing_tools=()
for tool in docker aws kubectl eksctl; do
    if ! command_exists $tool; then
        missing_tools+=($tool)
    fi
done

if [ ${#missing_tools[@]} -ne 0 ]; then
    print_error "The following required tools are missing:"
    for tool in "${missing_tools[@]}"; do
        case $tool in
            docker)
                echo "  - $tool - Install from: https://docs.docker.com/get-docker/"
                ;;
            aws)
                echo "  - $tool - Install from: https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html"
                ;;
            kubectl)
                echo "  - $tool - Install from: https://kubernetes.io/docs/tasks/tools/install-kubectl/"
                ;;
            eksctl)
                echo "  - $tool - Install from: https://eksctl.io/installation/"
                ;;
            *)
                echo "  - $tool"
                ;;
        esac
    done
    echo
    echo "Please install the missing tools and run this script again."
    exit 1
fi

print_success "All required tools are installed"
echo

# Check AWS credentials
print_status "Checking AWS credentials..."
if ! aws sts get-caller-identity >/dev/null 2>&1; then
    print_error "AWS credentials not configured. Please run 'aws configure' first."
    exit 1
fi

print_success "AWS credentials are configured"
echo

# Step 1: Set environment variables
print_status "Setting up environment variables..."

export AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
print_success "AWS Account ID: $AWS_ACCOUNT_ID"

echo "Select AWS region:"
echo "1) us-east-1 (N. Virginia) [default]"
echo "2) us-west-2 (Oregon)"
echo "3) eu-west-1 (Ireland)"
echo "4) eu-north-1 (Stockholm)"
echo "5) ap-southeast-1 (Singapore)"
echo "6) Other (enter manually)"
echo

read -p "Enter your choice (1-6) [1]: " region_choice

case $region_choice in
    2) AWS_REGION="us-west-2" ;;
    3) AWS_REGION="eu-west-1" ;;
    4) AWS_REGION="eu-north-1" ;;
    5) AWS_REGION="ap-southeast-1" ;;
    6) read -p "Enter AWS region: " AWS_REGION ;;
    *) AWS_REGION="us-east-1" ;;
esac

export AWS_REGION

if [ -z "$AWS_REGION" ]; then
    print_error "AWS region is required"
    exit 1
fi

export ECR=$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/rhn-skip-example

print_success "Environment variables set:"
echo "  AWS_ACCOUNT_ID: $AWS_ACCOUNT_ID"
echo "  AWS_REGION: $AWS_REGION"
echo "  ECR: $ECR"
echo

# Step 2: Create EKS cluster
print_status "Step 1: Creating EKS cluster..."
echo "This will create a cluster named 'skip-quickstart' using EKS auto-mode."
echo "Note: This can take 10-15 minutes to complete."
echo

if confirm "Do you want to create the EKS cluster?"; then
    print_status "Creating EKS cluster (this may take a while)..."
    eksctl create cluster --enable-auto-mode --name skip-quickstart --region $AWS_REGION
    print_success "EKS cluster created successfully"
else
    print_warning "Skipping EKS cluster creation"
fi
echo

# Step 3: Create ECR repository
print_status "Step 2: Creating ECR repository..."
echo "This will create an ECR repository named 'rhn-skip-example'."
echo

if confirm "Do you want to create the ECR repository?"; then
    print_status "Creating ECR repository..."
    aws ecr create-repository --repository-name rhn-skip-example --region $AWS_REGION || true
    
    print_status "Authenticating Docker with ECR..."
    aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR
    print_success "ECR repository created and Docker authenticated"
else
    print_warning "Skipping ECR repository creation"
fi
echo

# Step 4: Build and push Docker images
print_status "Step 3: Building and pushing Docker images..."
echo "This will build and push images for: web_service, reactive_service, www, db, reverse_proxy"
echo "Note: This requires the docker images to be built for linux/amd64 platform."
echo

if confirm "Do you want to build and push Docker images?"; then
    print_status "Building and pushing Docker images..."
    
    # Check if we're in the right directory
    if [ ! -d "web_service" ] || [ ! -d "reactive_service" ] || [ ! -d "www" ] || [ ! -d "db" ] || [ ! -d "reverse_proxy" ]; then
        print_error "Required directories not found. Please run this script from the hackernews example directory."
        exit 1
    fi
    
    for image in web_service reactive_service www db reverse_proxy; do
        print_status "Building $image..."
        docker build --platform linux/amd64 --tag rhn-$image-aws $image
        docker tag rhn-$image-aws $ECR:$image
        docker push $ECR:$image
        print_success "Pushed $image"
    done
    print_success "All Docker images built and pushed"
else
    print_warning "Skipping Docker image build and push"
fi
echo

# Step 5: Set up ECR permissions
print_status "Step 4: Setting up ECR permissions for EKS..."
echo "This will create a Kubernetes secret for ECR access."
echo

if confirm "Do you want to set up ECR permissions?"; then
    print_status "Creating ECR access secret..."
    TOKEN=$(aws ecr --region=$AWS_REGION get-authorization-token \
        --output text --query authorizationData[].authorizationToken \
        | base64 -d | cut -d: -f2)
    
    kubectl create secret docker-registry rhn-skip-ecr-registry \
        --docker-server=https://$ECR --docker-username=AWS \
        --docker-password="${TOKEN}" --docker-email=user@example.com || true
    
    print_success "ECR permissions configured"
else
    print_warning "Skipping ECR permissions setup"
fi
echo

# Step 6: Apply Kubernetes manifests
print_status "Step 5: Applying Kubernetes manifests and installing HAProxy..."
echo "This will apply all Kubernetes manifests and install HAProxy Helm chart."
echo

if confirm "Do you want to apply Kubernetes manifests?"; then
    print_status "Applying Kubernetes manifests..."
    
    # Check if kubernetes/eks directory exists
    if [ ! -d "kubernetes/eks" ]; then
        print_error "kubernetes/eks directory not found. Please run this script from the hackernews example directory."
        exit 1
    fi
    
    for f in kubernetes/eks/*.yaml; do
        print_status "Applying $f..."
        sed <$f s%__ECR__%$ECR% | kubectl apply -f -
    done
    
    print_status "Creating HAProxy config map..."
    kubectl create configmap haproxy-auxiliary-configmap \
        --from-file kubernetes/distributed_skip/haproxy-aux.cfg || true
    
    print_status "Installing HAProxy Helm chart..."
    helm repo add haproxytech https://haproxytech.github.io/helm-charts
    helm repo update
    helm install haproxy haproxytech/kubernetes-ingress \
        -f kubernetes/distributed_skip/haproxy-helm-config || true
    
    print_success "Kubernetes manifests applied and HAProxy installed"
else
    print_warning "Skipping Kubernetes manifests application"
fi
echo

# Step 7: Show services
print_status "Step 6: Checking services..."
echo "Getting all services..."
echo

kubectl get services

echo
print_status "Setup complete!"
echo "Look for the 'haproxy-kubernetes-ingress' service above and navigate to its EXTERNAL-IP in your browser."
echo "It may take a few minutes for the external IP to be assigned."
echo
print_status "You can check the status again with: kubectl get services"
print_status "To clean up resources later, run: eksctl delete cluster --name skip-quickstart --region $AWS_REGION"