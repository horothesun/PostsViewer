protocol Animal {
    var name: String? { get set }
}

class Cat: Animal {
    var name: String?
    var sleeping = false
    var favoriteFood: Food?

    init() { }

    init(name: String) { self.name = name }

    init(name: String, sleeping: Bool) {
        self.name = name
        self.sleeping = sleeping
    }
}

class Siamese: Cat { }

class Dog: Animal {
    var name: String?

    init() { }

    init(name: String) { self.name = name }
}

struct Turtle: Animal {
    var name: String?
}
