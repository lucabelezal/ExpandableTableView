import Foundation

protocol ViewCodable {
    func setupView()
    func configureHierarchy()
    func configureConstraints()
    func configureView()
}

extension ViewCodable {
    
    func setupView() {
        configureHierarchy()
        configureConstraints()
        configureView()
    }
}
