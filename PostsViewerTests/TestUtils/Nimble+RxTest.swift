import Nimble
import RxSwift
import RxTest

public func beNextEvent<T>(satisfying: @escaping (T) -> Bool) -> Predicate<Event<T>> {

    Predicate { expression in
        guard let event = try expression.evaluate() else {
            return .init(
                status: .fail,
                message: .fail("failed evaluating expression")
            )
        }

        let failingResult = PredicateResult(
            status: .fail,
            message: .expectedCustomValueTo("be next", "\(event)")
        )

        switch event {
        case .error, .completed:
            return failingResult
        case .next(let element):
            return satisfying(element)
                ? .init(
                    status: .matches,
                    message: .expectedTo("expectation fulfilled")
                )
                : failingResult
        }
    }
}

public func beNextEvent<T>(
    at time: TestTime,
    satisfying: @escaping (T) -> Bool) -> Predicate<Recorded<Event<T>>> {

    Predicate { expression in
        guard let recordedEvent = try expression.evaluate() else {
            return .init(
                status: .fail,
                message: .fail("failed evaluating expression")
            )
        }

        let failingResult = PredicateResult(
            status: .fail,
            message: .expectedCustomValueTo("be next @ \(time)", "\(recordedEvent)")
        )

        guard recordedEvent.time == time else { return failingResult }

        switch recordedEvent.value {
        case .error, .completed:
            return failingResult
        case .next(let element):
            return satisfying(element)
                ? .init(
                    status: .matches,
                    message: .expectedTo("expectation fulfilled")
                )
                : failingResult
        }
    }
}

public func beNextEvent<T>(test: @escaping (T) -> Void) -> Predicate<Event<T>> {

    Predicate { expression in
        guard let event = try expression.evaluate() else {
            return .init(
                status: .fail,
                message: .fail("failed evaluating expression")
            )
        }

        let failingResult = PredicateResult(
            status: .fail,
            message: .expectedCustomValueTo("be next", "\(event)")
        )

        switch event {
        case .error, .completed:
            return failingResult
        case .next(let element):
            test(element)
            return .init(
                status: .matches,
                message: .expectedTo("expectation fulfilled")
            )
        }
    }
}

public func beNextEvent<T>(
    at time: TestTime,
    test: @escaping (T) -> Void) -> Predicate<Recorded<Event<T>>> {

    Predicate { expression in
        guard let recordedEvent = try expression.evaluate() else {
            return .init(
                status: .fail,
                message: .fail("failed evaluating expression")
            )
        }

        let failingResult = PredicateResult(
            status: .fail,
            message: .expectedCustomValueTo("be next @ \(time)", "\(recordedEvent)")
        )

        guard recordedEvent.time == time else { return failingResult }

        switch recordedEvent.value {
        case .error, .completed:
            return failingResult
        case .next(let element):
            test(element)
            return .init(
                status: .matches,
                message: .expectedTo("expectation fulfilled")
            )
        }
    }
}

public func beErrorEvent<T>() -> Predicate<Event<T>> {

    Predicate { expression in
        guard let event = try expression.evaluate() else {
            return .init(
                status: .fail,
                message: .fail("failed evaluating expression")
            )
        }

        switch event {
        case .next, .completed:
            return .init(
                status: .fail,
                message: .expectedCustomValueTo("be error", "\(event)")
            )
        case .error:
            return .init(
                status: .matches,
                message: .expectedTo("expectation fulfilled")
            )
        }
    }
}

public func beErrorEvent<T>(at time: TestTime) -> Predicate<Recorded<Event<T>>> {

    Predicate { expression in
        guard let recordedEvent = try expression.evaluate() else {
            return .init(
                status: .fail,
                message: .fail("failed evaluating expression")
            )
        }

        let failingResult = PredicateResult(
            status: .fail,
            message: .expectedCustomValueTo("be error @ \(time)", "\(recordedEvent)")
        )

        guard recordedEvent.time == time else { return failingResult }

        switch recordedEvent.value {
        case .next, .completed:
            return failingResult
        case .error:
            return .init(
                status: .matches,
                message: .expectedTo("expectation fulfilled")
            )
        }
    }
}

public func beCompletedEvent<T>() -> Predicate<Event<T>> {

    Predicate { expression in
        guard let event = try expression.evaluate() else {
            return .init(
                status: .fail,
                message: .fail("failed evaluating expression")
            )
        }

        switch event {
        case .next, .error:
            return .init(
                status: .fail,
                message: .expectedCustomValueTo("be completed", "\(event)")
            )
        case .completed:
            return .init(
                status: .matches,
                message: .expectedTo("expectation fulfilled")
            )
        }
    }
}

public func beCompletedEvent<T>(at time: TestTime) -> Predicate<Recorded<Event<T>>> {

    Predicate { expression in
        guard let recordedEvent = try expression.evaluate() else {
            return .init(
                status: .fail,
                message: .fail("failed evaluating expression")
            )
        }

        let failingResult = PredicateResult(
            status: .fail,
            message: .expectedCustomValueTo("be completed @ \(time)", "\(recordedEvent)")
        )

        guard recordedEvent.time == time else { return failingResult }

        switch recordedEvent.value {
        case .next, .error:
            return failingResult
        case .completed:
            return .init(
                status: .matches,
                message: .expectedTo("expectation fulfilled")
            )
        }
    }
}
