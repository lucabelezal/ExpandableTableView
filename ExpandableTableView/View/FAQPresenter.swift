import Foundation

protocol FAQPresenterProtocol {
    func fetchQuestions()
}

final class FAQPresenter: FAQPresenterProtocol {
    weak var view: FAQViewControllerProtocol?

    func fetchQuestions() {

        let jsonData = JSONHelper.getDataFrom(json: "FAQs")!
        do {
            let faqs = try JSONDecoder().decode([FAQModel].self, from: jsonData)
            view?.showView(withFAQs: faqs)
        } catch(let error) {
            view?.showErrorView(withError: error)
        }
    }
}
