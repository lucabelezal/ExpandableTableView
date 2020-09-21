import Foundation

class FAQModel: Decodable {
    let title: String
    let section: [Section]
}

class Section: Decodable {
    let title: String
    let questions: [Question]
    var isExpanded: Bool? = false
}

class Question: Decodable {
    let id: Int
    let title: String
    var isExpanded: Bool? = false
}
