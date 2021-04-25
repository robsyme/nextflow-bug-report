# nextflow-bug-report
Tiny repository to demonstrate a potential bug in nextflow

## Bug Description

It appears that accessing an object's fields or methods in the `tag` directive will break the ability to resume a cached task.

## Reproducing the bug

Clone this repository and run it twice - once to generate the cached results and then once again with the `-resume` flag to use the cached process results.

```
export NXF_VER="21.04.0-edge"
nextflow run -r main robsyme/nextflow-bug-report
nextflow run -r main -resume robsyme/nextflow-bug-report
```

The workflow pipes the same channel through three processes. The process without a tag set (`process NoTag`) is able to use the cached results as expected.

The second process (`TagUsesField`) accesses a filed of the groovy object in the channel. This process is unable to use the cached results.

The third process (`TagUsesMethod`) calls the `toString()` method of the groovy object to set the `tag` directive. This process is also unable to use the cached results.

## Example of the bug

```
❯ rm -rf .nextflow* work

❯ nextflow run -lib lib main.nf
N E X T F L O W  ~  version 21.04.0-edge
Launching `main.nf` [stoic_wilson] - revision: b85efb5381
WARN: DSL 2 IS AN EXPERIMENTAL FEATURE UNDER DEVELOPMENT -- SYNTAX MAY CHANGE IN FUTURE RELEASE
executor >  local (9)
[fa/b54eeb] process > NoTag (3)                 [100%] 3 of 3 ✔
[bf/69c5b4] process > TagUsesField (Lassie)     [100%] 3 of 3 ✔
[58/ee401b] process > TagUsesMethod (Dog(Fido)) [100%] 3 of 3 ✔

❯ nextflow run -lib lib -resume main.nf
N E X T F L O W  ~  version 21.04.0-edge
Launching `main.nf` [reverent_picasso] - revision: b85efb5381
WARN: DSL 2 IS AN EXPERIMENTAL FEATURE UNDER DEVELOPMENT -- SYNTAX MAY CHANGE IN FUTURE RELEASE
executor >  local (6)
[fa/b54eeb] process > NoTag (3)                   [100%] 3 of 3, cached: 3 ✔
[32/4d3305] process > TagUsesField (Fido)         [100%] 3 of 3 ✔
[aa/61e0b7] process > TagUsesMethod (Dog(Lassie)) [100%] 3 of 3 ✔
WARN: [TagUsesField (Spot)] Unable to resume cached task -- See log file for details
WARN: [TagUsesMethod (Dog(Fido))] Unable to resume cached task -- See log file for details
WARN: [TagUsesMethod (Dog(Spot))] Unable to resume cached task -- See log file for details
WARN: [TagUsesMethod (Dog(Lassie))] Unable to resume cached task -- See log file for details
WARN: [TagUsesField (Fido)] Unable to resume cached task -- See log file for details
WARN: [TagUsesField (Lassie)] Unable to resume cached task -- See log file for details
```
