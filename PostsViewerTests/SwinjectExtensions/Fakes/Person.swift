protocol Person { }

class PetOwner: Person {
    var pet: Animal?
    var favoriteFood: Food?

    init() { }

    init(pet: Animal) { self.pet = pet }

    func injectAnimal(_ animal: Animal) { self.pet = animal }
}
