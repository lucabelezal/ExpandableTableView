import UIKit

protocol FAQViewControllerProtocol: AnyObject {
    func showQuestions(items: [FAQItemsModel])
    func showRetry(error: Error)
}

final class FAQViewController: UIViewController {

    private lazy var faqView: FAQView = {
        let view = FAQView()
        view.delegate = self
        return view
    }()

    private lazy var retryView: UIView = {
        let view = UIView()
        view.isHidden = true
        return view
    }()

    private let presenter: FAQPresenterProtocol

    init(presenter: FAQPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        presenter.fetchQuestions()
    }

    @objc
    private func reloadView() {
        presenter.fetchQuestions()
    }
}

extension FAQViewController: ViewCodable {
    func configureHierarchy() {
        [faqView, retryView].forEach(view.addSubview)
    }

    func configureConstraints() {
        retryView.translatesAutoresizingMaskIntoConstraints = false
        let retryViewConstraints = [
            retryView.topAnchor.constraint(equalTo: view.topAnchor),
            retryView.leftAnchor.constraint(equalTo: view.leftAnchor),
            retryView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            retryView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ]
        NSLayoutConstraint.activate(retryViewConstraints)

        faqView.translatesAutoresizingMaskIntoConstraints = false
        let faqViewConstraints = [
            faqView.topAnchor.constraint(equalTo: view.topAnchor),
            faqView.leftAnchor.constraint(equalTo: view.leftAnchor),
            faqView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            faqView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ]
        NSLayoutConstraint.activate(faqViewConstraints)
    }

    func configureView() {
        title = "Perguntas mais frequentes"
        view.backgroundColor = .white
    }
}

extension FAQViewController: FAQViewControllerProtocol {
    func showQuestions(items: [FAQItemsModel]) {
        retryView.isHidden = true
        faqView.update(faqItems: items)
    }

    func showRetry(error: Error) {
        retryView.isHidden = false
    }
}

extension FAQViewController: FAQViewDelegate {
    func didSelectQuestion(questionAnswer: QuestionAnswerModel) {
        let viewController = UIViewController()
        viewController.title = questionAnswer.title
        viewController.view.backgroundColor = .lightGray
        navigationController?.pushViewController(viewController, animated: true)
    }
}
