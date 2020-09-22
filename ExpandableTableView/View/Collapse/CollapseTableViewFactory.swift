import Foundation

final class CollapseTableViewFactory {

    func create(title: String, sections: [Section]) -> CollapseView {
        return CollapseView(title: title, sections: sections)
    }
}
