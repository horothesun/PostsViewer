import Swinject

infix operator +: AdditionPrecedence
public func +(lhs: Assembly, rhs: Assembly) -> Assembly { lhs.composed(with: rhs) }
