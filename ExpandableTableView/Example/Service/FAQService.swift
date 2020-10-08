import Foundation

protocol FAQServiceProtocol {
    func fetchQuestions(completion: @escaping (Result<[FAQModel], Error>) -> Void)
}

struct FAQService: FAQServiceProtocol {
    func fetchQuestions(completion: @escaping (Result<[FAQModel], Error>) -> Void) {
        let jsonData = JSONHelper.getDataFrom(json: "FAQs")!
        do {
            let faqs = try JSONDecoder().decode([FAQModel].self, from: jsonData)
            completion(.success(faqs))
        } catch(let error) {
            completion(.failure(error))
        }
    }
}
