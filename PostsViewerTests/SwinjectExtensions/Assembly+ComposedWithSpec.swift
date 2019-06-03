import Quick
import Nimble
import Swinject
import PostsViewer

final class Assembly_ComposedWithSpec: QuickSpec {

    override func spec() {
        super.spec()

        describe("Assembly composed with a second one") {
            var assembler: Assembler!

            context("FoodAssembly composed with AnimalAssembly") {
                var composedAssembly: Assembly!
                beforeEach {
                    composedAssembly = FoodAssembly().composed(with: AnimalAssembly())
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
        }
    }
}
