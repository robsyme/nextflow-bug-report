#!/usr/bin/env nextflow
nextflow.preview.dsl=2

import Dog

process NoTag {
    input:
    val(dog)

    "touch test.txt"
}

process TagUsesField {
    tag "${dog.name}"

    input:
    val(dog)

    "touch test.txt"
}

process TagUsesMethod {
    tag "${dog.toString()}"

    input:
    val(dog)

    "touch test.txt"
}


process StaticTag {
    tag "$custom_tag"

    input:
    tuple custom_tag, dog

    "touch test.txt"
}

workflow {
    dogs = Channel.from("Fido", "Spot", "Lassie") | map { new Dog(name: it) }
    dogs | map { ["FOOBAR", it] } | StaticTag
}
