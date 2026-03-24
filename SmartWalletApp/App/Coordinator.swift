protocol Coordinator {
    var children: [Coordinator] { get set }
    func start()
}
