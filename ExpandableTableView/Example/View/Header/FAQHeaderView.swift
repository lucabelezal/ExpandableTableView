import UIKit

final class FAQHeaderView: UIView {
    private let titleLabel = UILabel()
    private let horizontalLineView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(title: String?) {
        titleLabel.text = title
    }
}

extension FAQHeaderView: ViewCodable {
    func configureHierarchy() {
        [titleLabel, horizontalLineView].forEach(addSubview)
    }

    func configureConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        horizontalLineView.translatesAutoresizingMaskIntoConstraints = false

        let titleLabelConstraints = [
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            titleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -16)
        ]
        NSLayoutConstraint.activate(titleLabelConstraints)

        let horizontalLineViewConstraints = [
            horizontalLineView.heightAnchor.constraint(equalToConstant: 1),
            horizontalLineView.leftAnchor.constraint(equalTo: leftAnchor),
            horizontalLineView.bottomAnchor.constraint(equalTo: bottomAnchor),
            horizontalLineView.rightAnchor.constraint(equalTo: rightAnchor)
        ]
        NSLayoutConstraint.activate(horizontalLineViewConstraints)
    }

    func configureView() {
        backgroundColor = .white
        titleLabel.textColor = .lightGray
        titleLabel.font = .boldSystemFont(ofSize: 12)
        horizontalLineView.backgroundColor = #colorLiteral(red: 0.8862745098, green: 0.8862745098, blue: 0.8862745098, alpha: 1)
    }
}
