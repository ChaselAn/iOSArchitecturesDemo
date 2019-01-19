public struct Reducer<State, Action> {
    let reduce: (inout State, Action) -> Void

    public init(reduce: @escaping (inout State, Action) -> Void) {
        self.reduce = reduce
    }
}

public class Store<State, Action> {
    private let reducer: Reducer<State, Action>
    private var subscribers: [(State) -> Void] = []
    public private(set) var currentState: State {
        didSet {
            subscribers.forEach({ $0(currentState) })
        }
    }

    public init(reducer: Reducer<State, Action>, initialState: State) {
        self.reducer = reducer
        self.currentState = initialState
    }

    public func subscribe(newStateOnly: Bool = false, _ subscriber: @escaping (State) -> Void) {
        subscribers.append(subscriber)
        if !newStateOnly {
            subscriber(currentState)
        }
    }

    public func dispatch(_ action: Action) {
        reducer.reduce(&currentState, action)
    }
}
