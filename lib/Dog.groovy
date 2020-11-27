import nextflow.util.CacheFunnel
import nextflow.util.CacheHelper
import com.google.common.hash.Hasher
import nextflow.util.CacheHelper.HashMode

class Dog implements Serializable, CacheFunnel {
    String name

    String toString() {
        "Dog"
    }

    @Override
    public int hashCode() {
        return name.hashCode()
    }

    Hasher funnel(Hasher hasher, HashMode mode) {
        return CacheHelper.hasher(hasher, this.name, mode)
    }
}
