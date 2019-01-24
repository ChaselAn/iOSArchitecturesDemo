import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    private let model = Model(value: "init")

    private let mvcView = View(title: "MVC:")
    private let mvpView = View(title: "MVP:")
    private let mvvmView = View(title: "MVVM:")
    private let mvvmDataBindView = View(title: "MVVM-B:")

    private var mvcObserver: NSObjectProtocol?

    private var presenter: Presenter?

    private var viewModel: ViewModel?
    private var mvvmObserver: NSObjectProtocol?

    private var dataBindViewModel: DataBindViewModel?
    private var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        makeUI()

        mvcDidLoad()
        mvpDidLoad()
        mvvmDidLoad()
        mvvmDataBindDidLoad()
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

// MARK: - MVVM

class ViewModel: NSObject {

    @objc dynamic var textFieldValue: String

    private var model: Model
    private var observer: NSObjectProtocol?

    init(model: Model) {
        self.model = model
        textFieldValue = model.value
        super.init()

        observer = NotificationCenter.default.addObserver(forName: Model.textDidChange, object: nil, queue: nil) { [weak self] (note) in
            self?.textFieldValue = note.userInfo?[Model.textKey] as? String ?? ""
        }
    }

    func commit(value: String) {
        model.value = value
    }
}

extension ViewController {

    private func mvvmDidLoad() {
        viewModel = ViewModel(model: model)

        mvvmObserver = viewModel?.observe(\.textFieldValue, options: [.initial, .new], changeHandler: { [weak self] (_, change) in
            self?.mvvmView.textFieldValue = change.newValue
        })

        mvvmView.commit = { [weak self] in
            self?.viewModel?.commit(value: self?.mvvmView.textFieldValue ?? "")
        }
    }
}

// MARK: - mvvmDataBind
class DataBindViewModel: NSObject {

    private var model: Model
    var modelVariable: Variable<Model>
    private var disposeBag = DisposeBag()

    init(model: Model) {
        self.model = model
        self.modelVariable = Variable(model)
        super.init()

        modelVariable = Variable(model)

        NotificationCenter.default.rx.notification(Model.textDidChange).subscribe(onNext: { [weak self] notification in
            if let model = notification.object as? Model {
               self?.modelVariable.value = model
            }
        }).disposed(by: disposeBag)
    }

    func commit(value: String) {
        model.value = value
    }
}
extension ViewController {
    private func mvvmDataBindDidLoad() {
        dataBindViewModel = DataBindViewModel(model: model)

        dataBindViewModel?.modelVariable.asObservable().subscribe(onNext: { [weak self] (model) in
            self?.mvvmDataBindView.textFieldValue = model.value
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)

        mvvmDataBindView.commit = { [weak self] in
            self?.dataBindViewModel?.commit(value: self?.mvvmDataBindView.textFieldValue ?? "")
        }
    }
}

extension ViewController {

    private func makeUI() {
        view.backgroundColor = .lightGray

        let stack = UIStackView(arrangedSubviews: [mvcView, mvpView, mvvmView, mvvmDataBindView])
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .equalSpacing

        view.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.topAnchor.constraint(equalTo: view.topAnchor, constant: 150).isActive = true
        stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true

        stack.arrangedSubviews.forEach({
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.heightAnchor.constraint(equalToConstant: 50).isActive = true
        })
    }
}
