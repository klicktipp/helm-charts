[![Artifact Hub](https://img.shields.io/endpoint?url=https://artifacthub.io/badge/repository/klicktipp)](https://artifacthub.io/packages/search?repo=klicktipp)

# KT Helm Charts

## Helm Chart Repo Usage

[Helm](https://helm.sh) must be installed to use the charts.  Please refer to
Helm's [documentation](https://helm.sh/docs) to get started.

Once Helm has been set up correctly, add the repo as follows:
```
  helm repo add klicktipp https://klicktipp.github.io/helm-charts/
```
If you had already added this repo earlier, run `helm repo update` to retrieve
the latest versions of the packages.  You can then run `helm search repo
klicktipp` to see the charts.

To install the `<chart-name>` chart:
```
    helm install my-<chart-name> klicktipp/<chart-name>
```
To uninstall the chart:
```
    helm delete my-<chart-name>
```

## Creating/Updating Charts

* Pull latest `main` branch changes
* Branch out with the name `${chartname}-chart`
* Put all your changes on this branch and push
* Bump the `Chart.yaml` version and push
* Create a merge request and let it approve and be merged to the `main` branch
* After successful merging, Github Actions (bot) will automagically create a tag on the `main` branch with the name of the chart and the latest chart version. Example: `redisinsight-0.2.0`.
* The release workflow now also generates intelligent release notes per chart version (from changed values, templates, and app/chart version bumps) and updates the GitHub release description automatically.
* Now the chart index (in the `gh-pages`) has been updated with the latest chart changes: https://github.com/klicktipp/helm-charts/blob/gh-pages/index.yaml

## Chart Documentation (values -> README)

This repository uses `helm-docs` and local scripts to keep chart README files in sync with `values.yaml`.

Install `helm-docs`:

```bash
go install github.com/norwoodj/helm-docs/cmd/helm-docs@v1.14.2
```

Validate values documentation comments (`# -- ...`) for one chart:

```bash
scripts/check-values-docs.sh charts/n8n/values.yaml
```

Generate/refresh chart README files from values:

```bash
scripts/generate-chart-readmes.sh
```

Check README consistency for one chart:

```bash
scripts/check-readme-consistency.sh charts/n8n
```

For all charts, run:

```bash
scripts/check-values-docs.sh
scripts/check-readme-consistency.sh
```
