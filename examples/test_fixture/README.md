Test fixture of TODO
====================
TODO description

Usage
-----

To run the tests, from the repo root execute:

```
$ kitchen test
...
Finished in 4.25 seconds (files took 2.75 seconds to load)
20 examples, 0 failures

       Finished verifying <default-aws> (0m9.03s).
-----> Kitchen is finished. (0m9.40s)
```

This will destroy any existing test resources, create the resources afresh, run the tests, report back, and destroy the resources.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| aws\_allowed\_account\_ids | - | list | `[ "845868186186" ]` | no |
| region | - | string | `eu-west-1` | no |
| user | - | string | `user` | no |

## Outputs

| Name | Description |
|------|-------------|
| region | Region we created the resources in. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
