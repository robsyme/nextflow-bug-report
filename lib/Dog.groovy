class Dog {
    String name

    String toString() {
        "Dog"
    }

    @Override
    public int hashCode() {
        return name.hashCode()
    }
}
