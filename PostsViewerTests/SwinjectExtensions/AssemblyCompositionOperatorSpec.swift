import Quick
import Nimble
import Swinject
import PostsViewer

final class AssemblyCompositionOperatorSpec: QuickSpec {

    override func spec() {
        super.spec()

        describe("Assembly composition operator") {
            var assembler: Assembler!
            var composedAssembly: Assembly!

            context("FoodAssembly + AnimalAssembly") {
                beforeEach {
                    composedAssembly = FoodAssembly() + AnimalAssembly()
                    assembler = Assembler([composedAssembly])
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

            context("FoodAssembly + AnimalAssembly + PersonAssembly") {
                beforeEach {
                    composedAssembly = FoodAssembly()
                        + AnimalAssembly()
                        + PersonAssembly()
                    assembler = Assembler([composedAssembly])
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
