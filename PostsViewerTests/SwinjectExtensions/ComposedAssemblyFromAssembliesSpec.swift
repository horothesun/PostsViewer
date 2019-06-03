import Quick
import Nimble
import Swinject
import PostsViewer

final class ComposedAssemblyFromAssembliesSpec: QuickSpec {

    override func spec() {
        super.spec()

        describe("Composed Assembly from non-empty array of assemblies") {
            var assembler: Assembler!
            var assemblyCompositionResult: Assembly!

            context("array with just FoodAssembly") {
                beforeEach {
                    assemblyCompositionResult = composedAssembly(from: FoodAssembly())
                    assembler = Assembler([assemblyCompositionResult])
                }

                context("resolving Food") {
                    var food: Food?
                    beforeEach {
                        food = assembler.resolver.resolve(Food.self)
                    }
                    it("must be non-nil Sushi") {
                        expect(food).toNot(beNil())
                        expect(food).to(beAnInstanceOf(Sushi.self))
                    }
                }

                context("resolving Animal") {
                    var animal: Animal?
                    beforeEach {
                        animal = assembler.resolver.resolve(Animal.self)
                    }
                    it("must be nil") {
                        expect(animal).to(beNil())
                    }
                }
            }

            context("array with FoodAssembly and AnimalAssembly") {
                beforeEach {
                    assemblyCompositionResult = composedAssembly(from:
                        FoodAssembly(),
                        AnimalAssembly()
                    )
                    assembler = Assembler([assemblyCompositionResult])
                }

                context("resolving Food") {
                    var food: Food?
                    beforeEach {
                        food = assembler.resolver.resolve(Food.self)
                    }
                    it("must be non-nil Sushi") {
                        expect(food).toNot(beNil())
                        expect(food).to(beAnInstanceOf(Sushi.self))
                    }
                }

                context("resolving Animal") {
                    var animal: Animal?
                    beforeEach {
                        animal = assembler.resolver.resolve(Animal.self)
                    }
                    it("must be non-nil Cat named Whiskers") {
                        expect(animal).toNot(beNil())
                        expect(animal).to(beAnInstanceOf(Cat.self))
                        expect(animal!.name).to(equal("Whiskers"))
                    }
                }

                context("resolving PetOwner") {
                    var petOwner: PetOwner?
                    beforeEach {
                        petOwner = assembler.resolver.resolve(PetOwner.self)
                    }
                    it("must be nil") {
                        expect(petOwner).to(beNil())
                    }
                }
            }

            context("array with FoodAssembly, AnimalAssembly and PersonAssembly") {
                beforeEach {
                    assemblyCompositionResult = composedAssembly(from:
                        FoodAssembly(),
                        AnimalAssembly(),
                        PersonAssembly()
                    )
                    assembler = Assembler([assemblyCompositionResult])
                }

                context("resolving Food") {
                    var food: Food?
                    beforeEach {
                        food = assembler.resolver.resolve(Food.self)
                    }
                    it("must be non-nil Sushi") {
                        expect(food).toNot(beNil())
                        expect(food).to(beAnInstanceOf(Sushi.self))
                    }
                }

                context("resolving Animal") {
                    var animal: Animal?
                    beforeEach {
                        animal = assembler.resolver.resolve(Animal.self)
                    }
                    it("must be non-nil Cat named Whiskers") {
                        expect(animal).toNot(beNil())
                        expect(animal).to(beAnInstanceOf(Cat.self))
                        expect(animal!.name).to(equal("Whiskers"))
                    }
                }

                context("resolving PetOwner") {
                    var petOwner: PetOwner?
                    beforeEach {
                        petOwner = assembler.resolver.resolve(PetOwner.self)
                    }
                    it("must be non-nil PetOwner of a Cat and be Sushi lover") {
                        expect(petOwner).toNot(beNil())
                        expect(petOwner!.pet).toNot(beNil())
                        expect(petOwner!.pet).to(beAnInstanceOf(Cat.self))
                        expect(petOwner!.favoriteFood).toNot(beNil())
                        expect(petOwner!.favoriteFood).to(beAnInstanceOf(Sushi.self))
                    }
                }
            }
        }
    }
}
