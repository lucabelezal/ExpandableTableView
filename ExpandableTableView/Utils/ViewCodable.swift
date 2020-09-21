import Foundation

protocol ViewCodable {
    func setupView()
    func configureView()
    func configureHierarchy()
    func configureConstraints()
}

extension ViewCodable {
    
    func setupView() {
        configureView()
        configureHierarchy()
        configureConstraints()
    }
}
