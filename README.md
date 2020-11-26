# nextflow-bug-report
Tiny repository to demonstrate a potential bug in nextflow

## Bug Description

It appears that accessing an object's fields or methods in the `tag` directive will break the ability to resume a cached task.

## Reproducing the bug

Clone this repository and run it twice - once to generate the cached results and then once again with the `-resume` flag to use the cached process results.

```
nextflow run -r main robsyme/nextflow-bug-report
nextflow run -r main -resume robsyme/nextflow-bug-report
```

The workflow pipes the same channel through three processes. The process without a tag set (`process NoTag`) is able to use the cached results as expected.

The second process (`TagUsesField`) accesses a filed of the groovy object in the channel. This process is unable to use the cached results.

The third process (`TagUsesMethod`) calls the `toString()` method of the groovy object to set the `tag` directive. This process is also unable to use the cached results.

## Example of the bug

```
❯ rm -rf .nextflow* work

❯ nextflow run -r main robsyme/nextflow-bug-report
N E X T F L O W  ~  version 20.04.1
Launching `robsyme/nextflow-bug-report` [kickass_mayer] - revision: 5a7f833e04 [main]
WARN: DSL 2 IS AN EXPERIMENTAL FEATURE UNDER DEVELOPMENT -- SYNTAX MAY CHANGE IN FUTURE RELEASE
executor >  local (9)
[b3/442385] process > NoTag (2)             [100%] 3 of 3 ✔
[cf/02094d] process > TagUsesField (Lassie) [100%] 3 of 3 ✔
[28/62159a] process > TagUsesMethod (Dog)   [100%] 3 of 3 ✔

❯ nextflow run -r main -resume robsyme/nextflow-bug-report
N E X T F L O W  ~  version 20.04.1
Launching `robsyme/nextflow-bug-report` [angry_stallman] - revision: 5a7f833e04 [main]
WARN: DSL 2 IS AN EXPERIMENTAL FEATURE UNDER DEVELOPMENT -- SYNTAX MAY CHANGE IN FUTURE RELEASE
executor >  local (6)
[72/26d6b2] process > NoTag (3)           [100%] 3 of 3, cached: 3 ✔
[1e/6b961e] process > TagUsesField (Spot) [100%] 3 of 3 ✔
[50/d66c73] process > TagUsesMethod (Dog) [100%] 3 of 3 ✔
WARN: [TagUsesMethod (Dog)] Unable to resume cached task -- See log file for details
WARN: [TagUsesField (Lassie)] Unable to resume cached task -- See log file for details
WARN: [TagUsesField (Fido)] Unable to resume cached task -- See log file for details
WARN: [TagUsesField (Spot)] Unable to resume cached task -- See log file for details

```
