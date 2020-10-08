import Foundation

struct FAQModel: Decodable {
    let title: String
    let section: [FAQSectionModel]
}

extension FAQModel: Hashable {
    static func == (lhs: FAQModel, rhs: FAQModel) -> Bool {
        return lhs.title == rhs.title && lhs.section == rhs.section
    }
}

struct FAQSectionModel: Decodable {
    let title: String
    let questions: [FAQItemModel]
}

extension FAQSectionModel: Hashable {
    static func == (lhs: FAQSectionModel, rhs: FAQSectionModel) -> Bool {
        return lhs.title == rhs.title && lhs.questions == rhs.questions
    }
}

struct FAQItemModel: Decodable {
    let id: Int
    let title: String
}

extension FAQItemModel: Hashable {
    static func == (lhs: FAQItemModel, rhs: FAQItemModel) -> Bool {
        return lhs.id == rhs.id && lhs.title == rhs.title
    }
}
