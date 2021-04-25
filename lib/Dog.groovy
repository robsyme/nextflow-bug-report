import nextflow.io.ValueObject

import nextflow.util.KryoHelper

@ValueObject
class Dog  {

    static {
        KryoHelper.register(Dog)
    }

    String name
}
