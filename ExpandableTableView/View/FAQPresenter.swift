import Foundation

protocol FAQPresenterProtocol {
    func fetchQuestions()
}

final class FAQPresenter: FAQPresenterProtocol {
    weak var view: FAQViewControllerProtocol?

    private var sectionNames: [FAQModel] = []
    private var sectionItems: [FAQSectionViewModel] = []

    func fetchQuestions() {
        let jsonData = JSONHelper.getDataFrom(json: "FAQs")!
        do {
            let items = try JSONDecoder().decode([FAQModel].self, from: jsonData)
            handleSuccessRequest(FAQItems: items)
        } catch(let error) {
            view?.showErrorView(withError: error)
        }
    }

    private func handleSuccessRequest(FAQItems items: [FAQModel]) {

        sectionNames = items

        for (index, item) in items.enumerated() {
            for section in item.section {
                var title: String?
                if section == items[index].section.first { title = item.title }
                sectionItems += [FAQSectionViewModel(title: title, rows: transformSectionIntoRows(section: section))]
            }
        }

        view?.showView(sectionNames: sectionNames, sectionItems: sectionItems)
    }

    private func transformSectionIntoRows(section: Section) -> [String] {
        return [section.title] + section.questions.compactMap { $0.title }
    }
}







