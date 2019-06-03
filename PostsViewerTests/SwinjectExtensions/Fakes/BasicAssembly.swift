import Swinject

struct AnimalAssembly: Assembly {

    func assemble(container: Container) {
        container.register(Animal.self) { _ in Cat(name: "Whiskers") }
    }
}

struct FoodAssembly: Assembly {

    func assemble(container: Container) {
        container.register(Food.self) { _ in Sushi() }
    }
}

struct PersonAssembly: Assembly {

    func assemble(container: Container) {
        container.register(PetOwner.self) { resolver in
            let definition = PetOwner()
            definition.favoriteFood = resolver.resolve(Food.self)
            definition.pet = resolver.resolve(Animal.self)
            return definition
        }
    }
}
