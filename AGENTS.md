# Repository Instructions

## Versioning

Whenever you make a user-visible change to a chart, bump the chart version in that chart's `Chart.yaml`.

Keep version bumps scoped to the charts that actually changed. Do not bump unrelated charts.

Do not bump chart versions on feature branches. A version may already have been bumped for unreleased work, so defer version bumps until the branch or release flow where the chart is actually being prepared for publication.

## README consistency

Whenever you change chart values files (`values.yaml` or other values override files) or bump chart versions in `Chart.yaml`, run `scripts/check-readme-consistency.sh` before finishing.

Use the chart directory as an argument when you only changed a single chart, for example:

```sh
scripts/check-readme-consistency.sh charts/n8n
```

If multiple charts were changed, run the script for each affected chart or run it without arguments to validate all chart READMEs.

This script ensures that the README of every changed chart stays in sync with the chart metadata and values.

Do not hand-edit generated README sections when the content is derived from chart metadata or values. Regenerate or validate them through the repository scripts instead.

## Values documentation

Whenever you change `values.yaml`, keep the Helm Docs comments (`# -- ...`) in sync and run `scripts/check-values-docs.sh` for the affected values file.

Example:

```sh
scripts/check-values-docs.sh charts/n8n/values.yaml
```

## Scope of changes

Keep changes tightly scoped to the affected chart directories under `charts/<name>/`.

Avoid committing unrelated generated README updates or version bumps for charts that were not part of the task.
