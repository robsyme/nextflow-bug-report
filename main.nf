#!/usr/bin/env nextflow
nextflow.preview.dsl=2


import Dog

import nextflow.util.KryoHelper
KryoHelper.register(Dog)

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

process TagUsesExtractedField {
    tag {name}

    input:
    tuple val(name), val(dog)

    "touch test.txt"
}

workflow {
    ch_dogs = Channel.from("Fido", "Spot", "Lassie")

    ch_dogs | map { new Dog(name: it) } \
    | (NoTag & TagUsesField & TagUsesMethod)

    TagUsesExtractedField(ch_dogs.map { name -> tuple(name, new Dog(name: name))})
}
