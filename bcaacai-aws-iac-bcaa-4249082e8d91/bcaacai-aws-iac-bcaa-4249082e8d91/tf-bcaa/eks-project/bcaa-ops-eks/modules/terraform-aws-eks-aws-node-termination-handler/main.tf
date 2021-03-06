resource "kubernetes_namespace" "namespace" {
  # Create a kubernetes_namespace resource so Helm can deploy resource to
  # the specified namespace

  depends_on = [var.mod_dependency]
  count      = (var.enabled && var.k8s_namespace != "kube-system") ? 1 : 0

  metadata {
    name = var.k8s_namespace
  }
}

resource "helm_release" "release" {
  depends_on = [var.mod_dependency]
  count      = var.enabled ? 1 : 0
  chart      = var.helm_chart_name
  namespace  = var.k8s_namespace
  name       = var.helm_release_name
  version    = var.helm_chart_version
  repository = var.helm_repo_url

  dynamic "set" {
    for_each = var.settings
    content {
      name  = set.key
      value = set.value
    }
  }
}