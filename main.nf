#!/usr/bin/env nextflow
nextflow.preview.dsl=2

import Dog

process NoTag {
    input:
    val(dog)

    "touch test.txt"
}

process TagUsesField {
    tag { dog.name }

    input:
    val(dog)

    "touch test.txt"
}

process TagUsesMethod {
    tag { dog }

    input:
    val(dog)

    "touch test.txt"
}

workflow {
    Channel.from("Fido", "Spot", "Lassie") \
    | map { new Dog(name: it) } \
    | (NoTag & TagUsesField & TagUsesMethod)
}
