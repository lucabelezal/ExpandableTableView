import UIKit

final class FAQViewCell: UITableViewCell {
    private let titleLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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

extension FAQViewCell: ViewCodable {
    func configureHierarchy() {
        addSubview(titleLabel)
    }

    func configureConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            titleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -16)
        ]
        NSLayoutConstraint.activate(constraints)
    }

    func configureView() {
        backgroundColor = #colorLiteral(red: 0.9764705882, green: 0.9764705882, blue: 0.9764705882, alpha: 1)
        titleLabel.textColor = .darkGray
        titleLabel.font = .systemFont(ofSize: 14)
        selectionStyle = .none
        separatorInset = UIEdgeInsets(top: 0, left: UIScreen.main.bounds.size.width, bottom: 0, right: 0)
    }
}

