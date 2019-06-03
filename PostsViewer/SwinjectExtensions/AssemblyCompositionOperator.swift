import Swinject

infix operator +: AdditionPrecedence
public func +(lhs: Assembly, rhs: Assembly) -> Assembly {
    return lhs.composed(with: rhs)
}
