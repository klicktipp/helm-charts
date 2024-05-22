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
* After successful merging, create a tag on the `main` branch with the name of the chart and the latest chart version. Example: `redisinsight-0.2.0`.
* Push the tag
* Now the chart index (in the `gh-pages`) should be updated with the latest chart changes
