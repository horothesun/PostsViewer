import Nimble

extension Collection where Index == Int {

    public func extract(at index: Int, expectationsBlock: (Element) -> Void) {
        guard indices.contains(index) else {
            fail("Index \(index) is out of bounds")
            return
        }
        expectationsBlock(self[index])
    }
    
    public func extractAndExpect(at index: Int, to predicate: Predicate<Element>) {
        guard indices.contains(index) else {
            fail("Index \(index) is out of bounds")
            return
        }
        expect(self[index]).to(predicate)
    }
    
    public func extractAndExpect(at index: Int, to predicate: Predicate<Element?>) {
        guard indices.contains(index) else {
            fail("Index \(index) is out of bounds")
            return
        }
        expect(self[index]).to(predicate)
    }
}

extension Collection where Index == Int, Element: Equatable {

    public func extractAndExpect(at index: Int, to predicate: Predicate<Element>) {
        guard indices.contains(index) else {
            fail("Index \(index) is out of bounds")
            return
        }
        expect(self[index]).to(predicate)
    }
}
