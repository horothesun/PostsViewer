import Quick
import Nimble
import Swinject
import PostsViewer

final class Assembler_InitVariadicAssembliesSpec: QuickSpec {

    override func spec() {
        super.spec()

        describe("Assembly init with variadic Assembly...") {
            var assembler: Assembler!

            context("assembler with FoodAssembly") {
                beforeEach {
                    assembler = Assembler(FoodAssembly())
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

            context("assembler with FoodAssembly and AnimalAssembly") {
                beforeEach {
                    assembler = Assembler(FoodAssembly(), AnimalAssembly())
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

            context("assembler with FoodAssembly, AnimalAssembly and PersonAssembly") {
                beforeEach {
                    assembler = Assembler(
                        FoodAssembly(),
                        AnimalAssembly(),
                        PersonAssembly()
                    )
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
