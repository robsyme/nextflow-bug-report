# nextflow-bug-report
Tiny repository to demonstrate a potential bug in nextflow

## Bug Description

It appears that accessing an object's fields or methods in the `tag` directive will break the ability to resume a cached task.

## Reproducing the bug

Clone this repository and run it twice - once to generate the cached results and then once again with the `-resume` flag to use the cached process results.

```
nextflow run -r static_tag robsyme/nextflow-bug-report
nextflow run -r static_tag -resume robsyme/nextflow-bug-report
```

The workflow pipes the same channel through two processes. The first process does not set the tag directive (`process NoTag`) and is able to use the cached results as expected.

The second process (`StaticTag`) is exactly the same, but uses the tag directive. This process is unable to use the cached results.

## Example of the bug

```
❯ rm -rf .nextflow* work

❯ nextflow run -r static_tag robsyme/nextflow-bug-report
N E X T F L O W  ~  version 20.11.0-edge
Launching `./main.nf` [cheesy_euclid] - revision: 1cc68b9486
WARN: DSL 2 IS AN EXPERIMENTAL FEATURE UNDER DEVELOPMENT -- SYNTAX MAY CHANGE IN FUTURE RELEASE
executor >  local (6)
[0c/8268c1] process > NoTag (2)          [100%] 3 of 3 ✔
[e6/bb3709] process > StaticTag (FOOBAR) [100%] 3 of 3 ✔

❯ nextflow run -r main -static_tag robsyme/nextflow-bug-report
N E X T F L O W  ~  version 20.11.0-edge
Launching `./main.nf` [amazing_perlman] - revision: 1cc68b9486
WARN: DSL 2 IS AN EXPERIMENTAL FEATURE UNDER DEVELOPMENT -- SYNTAX MAY CHANGE IN FUTURE RELEASE
executor >  local (3)
[27/0b5c71] process > NoTag (3)          [100%] 3 of 3, cached: 3 ✔
[3f/9c1dc7] process > StaticTag (FOOBAR) [100%] 3 of 3 ✔
WARN: [StaticTag (FOOBAR)] Unable to resume cached task -- See log file for details
```
