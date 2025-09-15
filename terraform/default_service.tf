resource "harness_platform_service" "simple_service" {
  name        = "transaction-ingestor-test"
  identifier  = "transactioningestortest"
  description = "Minimal service without connectors"
  org_id      = "ing175org"
  project_id  = "ing175ip1"
  yaml = <<-EOT
      service:
        name: transaction-ingestor-test
        identifier: transactioningestortest
        serviceDefinition:
          type: NativeHelm
          spec:
            manifests:
              - manifest:
                  identifier: transactioningestortest
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