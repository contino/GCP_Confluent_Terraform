resource "helm_release" "operator" {
    name      = "operator"
    chart     = "confluent-operator/helm/confluent-operator"
    namespace = "operator"
    wait      = true
    
    values = [
        "${file("confluent-operator/helm/providers/gcp.yaml")}"
    ]
    set {
        name  = "operator.enabled"
        value = true
    }
    provisioner "local-exec" {
       command = "sleep 30s"
    }

}

resource "helm_release" "zookeeper" {
    name      = "zookeeper"
    chart     = "confluent-operator/helm/confluent-operator"
    namespace = "operator"
    wait      = true
    
    values = [
        "${file("confluent-operator/helm/providers/gcp.yaml")}"
    ]
    set {
        name  = "zookeeper.enabled"
        value = true
    }
    depends_on = [helm_release.operator]

    provisioner "local-exec" {
       command = "sleep 2m"
    }
}

resource "helm_release" "kafka" {
    name      = "kafka"
    chart     = "confluent-operator/helm/confluent-operator"
    namespace = "operator"
    wait      = true

    values = [
        "${file("confluent-operator/helm/providers/gcp.yaml")}"
    ]
    set {
        name  = "kafka.enabled"
        value = true
    }
    depends_on = [helm_release.zookeeper]

    provisioner "local-exec" {
       command = "sleep 6m"
    }
}

resource "helm_release" "schemaregistry" {
    name      = "schemaregistry"
    chart     = "confluent-operator/helm/confluent-operator"
    namespace = "operator"
    wait      = true

    values = [
        "${file("confluent-operator/helm/providers/gcp.yaml")}"
    ]
    set {
        name  = "schemaregistry.enabled"
        value = true
    }
    depends_on = [helm_release.kafka]

    provisioner "local-exec" {
       command = "sleep 4m"
    }
}

resource "helm_release" "controlcenter" {
    name      = "controlcenter"
    chart     = "confluent-operator/helm/confluent-operator"
    namespace = "operator"
    wait      = true
    
    values = [
        "${file("confluent-operator/helm/providers/gcp.yaml")}"
    ]
    set {
        name  = "controlcenter.enabled"
        value = true
    }
    depends_on = [helm_release.schemaregistry]

    provisioner "local-exec" {
       command = "sleep 2m"
    }
}
