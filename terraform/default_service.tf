
resource "harness_platform_service" "simple_service" {
  name        = var.service_name #"transaction-ingestor-test"
  identifier  = var.service_identifier #"transactioningestortest"
  description = "Minimal service without connectors"
  org_id      = var.org_id
  project_id  = var.proj_id
  yaml = <<-EOT
      service:
        name: ${var.service_name}
        identifier: ${var.service_identifier}
        serviceDefinition:
          type: ${var.service_type}
          spec:
            manifests:
              - manifest:
                  identifier: ${var.service_identifier}_manifest
                  type: HelmChart
                  spec:
                    store:
                      type: Github
                      spec:
                        connectorRef: harnessconnector
                        gitFetchType: Branch
                        folderPath: example/helmcharts/${var.service_name}
                        branch: main
                    subChartPath: ""
                    valuesPaths:
                      - example/helmcharts/${var.service_name}/values.yaml
                    skipResourceVersioning: false
                    enableDeclarativeRollback: false
                    helmVersion: V3
                    fetchHelmChartMetadata: false
        gitOpsEnabled: false
        orgIdentifier: ${var.org_id}
        projectIdentifier: ${var.proj_id}
  EOT
}