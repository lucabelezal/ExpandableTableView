import Foundation

struct FAQModel: Decodable {
    let title: String
    let section: [Section]
}

extension FAQModel: Hashable {
    static func == (lhs: FAQModel, rhs: FAQModel) -> Bool {
        return lhs.title == rhs.title && lhs.section == rhs.section
    }
}

struct Section: Decodable {
    let title: String
    let questions: [Question]
}

extension Section: Hashable {
    static func == (lhs: Section, rhs: Section) -> Bool {
        return lhs.title == rhs.title && lhs.questions == rhs.questions
    }
}

struct Question: Decodable {
    let id: Int
    let title: String
}

extension Question: Hashable {
    static func == (lhs: Question, rhs: Question) -> Bool {
        return lhs.id == rhs.id && lhs.title == rhs.title
    }
}
