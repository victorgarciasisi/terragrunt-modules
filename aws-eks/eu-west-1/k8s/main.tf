### Kubernetes ###

## Cluster data ##
data "aws_eks_cluster" "eks_cluster" {
  name = var.cluster_name
}

data "aws_eks_cluster_auth" "eks_cluster_auth" {
  name = var.cluster_name
}

## Providers k8s connection ##
provider "kubernetes" {
  host                   = var.cluster_endpoint
  cluster_ca_certificate = base64decode(var.cluster_certificate_authority_data)
  token                  = data.aws_eks_cluster_auth.eks_cluster_auth.token
}

provider "helm" {
  kubernetes = {
    host                   = var.cluster_endpoint
    cluster_ca_certificate = base64decode(var.cluster_certificate_authority_data)
    token                  = data.aws_eks_cluster_auth.eks_cluster_auth.token
  }
}

## Nginx Ingress ##
resource "kubernetes_namespace" "ingress_namespace" {
  metadata {
    name = "ingress-nginx"
  }
}

resource "helm_release" "nginx_ingress" {
  name       = "nginx-ingress"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  namespace  = kubernetes_namespace.ingress_namespace.metadata[0].name
  depends_on = [kubernetes_namespace.ingress_namespace]

  set = [
    {
      name  = "controller.replicaCount"
      value = "1"
    },
    {
      name  = "controller.service.type"
      value = "LoadBalancer"
    }
  ]
}

## Cert Manager ##
resource "kubernetes_namespace" "cert_manager_namespace" {
  metadata {
    name = "cert-manager"
  }
  depends_on = [helm_release.nginx_ingress]
}

resource "helm_release" "cert_manager" {
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  namespace  = kubernetes_namespace.cert_manager_namespace.metadata[0].name
  depends_on = [kubernetes_namespace.cert_manager_namespace]

  set = [
    {
      name  = "installCRDs"
      value = "true"
    }
  ]
}

## Metrics server ##
resource "kubernetes_namespace" "metrics_server_namespace" {
  metadata {
    name = "metrics-server"
  }
}

resource "helm_release" "metrics_server" {
  name       = "metrics-server"
  repository = "https://kubernetes-sigs.github.io/metrics-server/"
  chart      = "metrics-server"
  namespace  = kubernetes_namespace.metrics_server_namespace.metadata[0].name
  depends_on = [kubernetes_namespace.metrics_server_namespace]
}

## Cluster autoscaler ##
resource "helm_release" "cluster_autoscaler" {
  name             = "cluster-autoscaler"
  namespace        = "autoscaler"
  repository       = "https://kubernetes.github.io/autoscaler"
  chart            = "cluster-autoscaler"
  create_namespace = true

  values = [yamlencode({
    cloudProvider = "aws"
    awsRegion     = var.aws_region
    autoDiscovery = {
      enabled = false
    }

    autoscalingGroups = [
      for name in var.node_group_autoscaling_names : {
        name    = name
        minSize = 1
        maxSize = 4
      }
    ]
  })]
}

## Cluster Autoscaler storage permissions ##
resource "kubernetes_cluster_role" "cluster_autoscaler_volumeattachments" {
  metadata {
    name = "cluster-autoscaler-volumeattachments"
  }

  rule {
    api_groups = ["storage.k8s.io"]
    resources  = ["volumeattachments"]
    verbs      = ["get", "list", "watch"]
  }
}

resource "kubernetes_cluster_role_binding" "cluster_autoscaler_volumeattachments" {
  metadata {
    name = "cluster-autoscaler-volumeattachments"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.cluster_autoscaler_volumeattachments.metadata[0].name
  }

  subject {
    kind      = "ServiceAccount"
    name      = "cluster-autoscaler-aws-cluster-autoscaler"
    namespace = "autoscaler"
  }
}
