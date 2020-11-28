# nextflow-bug-report
Tiny repository to demonstrate a potential bug in nextflow

## Bug Description

It appears that accessing an object's fields or methods in the `tag` directive will break the ability to resume a cached task.

## Reproducing the bug

Clone this repository and run it twice - once to generate the cached results and then once again with the `-resume` flag to use the cached process results.

```
nextflow run -r static_tag robsyme/nextflow-bug-report
nextflow run -r static_tag robsyme/nextflow-bug-report -resume
```

The workflow pipes the same channel through two processes. The first process does not set the tag directive (`process NoTag`) and is able to use the cached results as expected.

The second process (`StaticTag`) is exactly the same, but uses the tag directive. This process is unable to use the cached results.

## Example of the bug

```
❯ rm -rf .nextflow* work

❯ nextflow run -r static_tag robsyme/nextflow-bug-report
N E X T F L O W  ~  version 20.11.0-edge
Launching `robsyme/nextflow-bug-report` [lethal_khorana] - revision: a0f058e2d2 [static_tag]
WARN: DSL 2 IS AN EXPERIMENTAL FEATURE UNDER DEVELOPMENT -- SYNTAX MAY CHANGE IN FUTURE RELEASE
executor >  local (6)
[64/8c7267] process > NoTag (1)          [100%] 3 of 3 ✔
[e5/a85191] process > StaticTag (FOOBAR) [100%] 3 of 3 ✔

❯ nextflow run -r main -static_tag robsyme/nextflow-bug-report -resume
N E X T F L O W  ~  version 20.11.0-edge
Launching `robsyme/nextflow-bug-report` [extravagant_edison] - revision: a0f058e2d2 [static_tag]
WARN: DSL 2 IS AN EXPERIMENTAL FEATURE UNDER DEVELOPMENT -- SYNTAX MAY CHANGE IN FUTURE RELEASE
executor >  local (3)
[64/8c7267] process > NoTag (1)          [100%] 3 of 3, cached: 3 ✔
[d5/5b616c] process > StaticTag (FOOBAR) [100%] 3 of 3 ✔
WARN: [StaticTag (FOOBAR)] Unable to resume cached task -- See log file for details
```
