import Foundation

@MainActor
class BaseViewModel {
    var onError: ((String) -> Void)?

    func trimmed(_ value: String) -> String {
        value.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    func emit<State>(_ state: State, using handler: ((State) -> Void)?) {
        handler?(state)
    }

    func emitFailure<State>(
        _ message: String,
        using handler: ((State) -> Void)?,
        transform: (String) -> State
    ) {
        emit(transform(message), using: handler)
    }

    func emitError(_ message: String) {
        onError?(message)
    }

    func performSubmission<T>(
        setSubmitting: (Bool) -> Void,
        emitState: () -> Void,
        operation: () async throws -> T
    ) async rethrows -> T {
        setSubmitting(true)
        emitState()

        defer {
            setSubmitting(false)
            emitState()
        }

        return try await operation()
    }
}
