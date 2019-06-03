import Quick
import Nimble
import Swinject
import PostsViewer

final class AssemblyFromClosureSpec: QuickSpec {

    override func spec() {
        super.spec()

        describe("Assembly from '(Container) -> Void' closure") {
            var assembler: Assembler!
            var assembly: Assembly!

            context("assembly with Cat named Felix registration") {
                beforeEach {
                    assembly = assemblyFrom { container in
                        container.register(Cat.self) { _ in Cat(name: "Felix") }
                    }
                    assembler = Assembler([assembly])
                }

                context("resolving Food") {
                    var result: Food?
                    beforeEach {
                        result = assembler.resolver.resolve(Food.self)
                    }
                    it("must be nil") {
                        expect(result).to(beNil())
                    }
                }

                context("resolving Cat") {
                    var result: Cat?
                    beforeEach {
                        result = assembler.resolver.resolve(Cat.self)
                    }
                    it("must be a non-nil Cat named Felix") {
                        expect(result).toNot(beNil())
                        expect(result!.name).to(equal("Felix"))
                    }
                }
            }
        }
    }
}
