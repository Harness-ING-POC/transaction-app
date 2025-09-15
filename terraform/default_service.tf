
variable "service_name" {
  type        = string
  description = "Name of the service"
}

variable "service_identifier" {
  type        = string
  description = "Identifier for the service"
}

variable "service_type" {
  type        = string
  description = "The type of service"
}


resource "harness_platform_service" "simple_service" {
  name        = var.service_name #"transaction-ingestor-test"
  identifier  = var.service_identifier #"transactioningestortest"
  description = "Minimal service without connectors"
  org_id      = "ing175org"
  project_id  = "ing175ip1"
  yaml = <<-EOT
      service:
        name: ${var.service_name}
        identifier: ${var.service_identifier}
        serviceDefinition:
          type: ${var.service_type}
          spec:
            manifests:
              - manifest:
                  identifier: ${var.service_identifier}
                  type: HelmChart
                  spec:
                    store:
                      type: Github
                      spec:
                        connectorRef: githubaccount
                        gitFetchType: Branch
                        folderPath: helmcharts/transaction-ingestor
                        branch: main
                    subChartPath: ""
                    valuesPaths:
                      - helmcharts/transaction-ingestor/values.yaml
                    skipResourceVersioning: false
                    enableDeclarativeRollback: false
                    helmVersion: V3
                    fetchHelmChartMetadata: false
        gitOpsEnabled: false
        orgIdentifier: ing175org
        projectIdentifier: ing175ip1
  EOT
}