import Foundation

protocol FAQPresenterProtocol {
    func fetchQuestions()
}

final class FAQPresenter: FAQPresenterProtocol {
    weak var view: FAQViewControllerProtocol?

    private let service: FAQServiceProtocol

    init(service: FAQServiceProtocol = FAQService()) {
        self.service = service
    }

    func fetchQuestions() {
        service.fetchQuestions { [weak self] result in
            switch result {
            case let .success(faqs):
                self?.handleSuccessFetchQuestions(faqItems: faqs)
            case let .failure(error):
                self?.view?.showRetry(error: error)
            }
        }
    }

    private func handleSuccessFetchQuestions(faqItems: [FAQModel]) {
        var items: [FAQItemsModel] = []

        for item in faqItems {
            for section in item.section {
                var title: String?
                if section == item.section.first {
                    title = item.title
                }
                items.append(
                    FAQItemsModel(
                        title: title,
                        rows: transformSectionIntoRows(section: section),
                        ids: [-1] + section.questions.compactMap { $0.id }
                    )
                )
            }
        }

        view?.showQuestions(items: items)
    }

    private func transformSectionIntoRows(section: FAQSectionModel) -> [String] {
        return [section.title] + section.questions.compactMap { $0.title }
    }
}







