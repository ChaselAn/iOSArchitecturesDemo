import UIKit

class ViewController: UIViewController {

    private let model = Model(value: "init")

    private let mvcView = View(title: "MVC:")
    private let mvpView = View(title: "MVP:")

    private var mvcObserver: NSObjectProtocol?

    private var presenter: Presenter?

    override func viewDidLoad() {
        super.viewDidLoad()

        makeUI()

        mvcDidLoad()
        mvpDidLoad()
    }

}

// MARK: - MVC
extension ViewController {

    private func mvcDidLoad() {
        mvcView.textFieldValue = model.value
        mvcObserver = NotificationCenter.default.addObserver(forName: Model.textDidChange, object: nil, queue: nil) { [weak self] (note) in
            self?.mvcView.textFieldValue = note.userInfo?[Model.textKey] as? String
        }

        mvcView.commit = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.model.value = strongSelf.mvcView.textFieldValue ?? ""
        }
    }
}

// MARK: - MVP
protocol ViewProtocol: class {
    var textFieldValue: String { get set }
}

class Presenter: NSObject {
    private let model: Model
    private weak var viewProtocol: ViewProtocol?
    private var mvpObserver: NSObjectProtocol?

    init(model: Model, viewProtocol: ViewProtocol) {
        self.model = model
        self.viewProtocol = viewProtocol
        super.init()

        viewProtocol.textFieldValue = model.value
        mvpObserver = NotificationCenter.default.addObserver(forName: Model.textDidChange, object: nil, queue: nil) { [weak self] (note) in
            self?.viewProtocol?.textFieldValue = note.userInfo?[Model.textKey] as? String ?? ""
        }
    }

    func commit() {
        model.value = viewProtocol?.textFieldValue ?? ""
    }
}

extension ViewController: ViewProtocol {

    var textFieldValue: String {
        get {
            return mvpView.textFieldValue ?? ""
        }
        set {
            mvpView.textFieldValue = newValue
        }
    }

    private func mvpDidLoad() {
        presenter = Presenter(model: model, viewProtocol: self)

        mvpView.commit = { [weak self] in
            self?.presenter?.commit()
        }
    }
}


extension ViewController {

    private func makeUI() {
        view.backgroundColor = .lightGray

        let stack = UIStackView(arrangedSubviews: [mvcView, mvpView])
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .equalSpacing

        view.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true

        stack.arrangedSubviews.forEach({
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.heightAnchor.constraint(equalToConstant: 50).isActive = true
        })
    }
}
