#!/usr/bin/env nextflow
nextflow.preview.dsl=2

import Dog

process NoTag {
    executor 'local'

    input:
    val(dog)

    "touch test.txt"
}

process TagUsesField {
    tag { dog.name }
    executor 'local'

    input:
    val(dog)

    "touch test.txt"
}

process TagUsesMethod {
    tag { dog }
    executor 'local'

    input:
    val(dog)

    "touch test.txt"
}

workflow {
    Channel.from("Fido", "Spot", "Lassie") \
    | map { new Dog(name: it) } \
    | (NoTag & TagUsesField & TagUsesMethod)
}
