import UIKit

final class FAQHeaderViewCell: UITableViewCell, ExpandableTableHeaderCell {
    private let titleLabel = UILabel()
    private let arrowImageView = UIImageView(image: UIImage(named: "expand-arrow"))
    private let horizontalLineView = UIView()

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

    func changeState(state: ExpandableState, cellReuse: Bool) {
        if case .willExpand = state {
            arrowUp(animated: !cellReuse)
        } else if case .willCollapse = state {
            arrowDown(animated: !cellReuse)
        }
        //horizontalLineView.backgroundColor = state == .willExpand ? .clear :  #colorLiteral(red: 0.8862745098, green: 0.8862745098, blue: 0.8862745098, alpha: 1)
    }

    private func arrowUp(animated: Bool) {
        UIView.animate(withDuration: animated ? 0.3 : 0) {
            self.arrowImageView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        }
    }

    private func arrowDown(animated: Bool) {
        UIView.animate(withDuration: animated ? 0.3 : 0) {
            self.arrowImageView.transform = CGAffineTransform(rotationAngle: 0)
        }
    }
}

extension FAQHeaderViewCell: ViewCodable {
    func configureHierarchy() {
         [titleLabel, arrowImageView, horizontalLineView].forEach(addSubview)
    }

    func configureConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        arrowImageView.translatesAutoresizingMaskIntoConstraints = false
        horizontalLineView.translatesAutoresizingMaskIntoConstraints = false

        let titleLabelConstraints = [
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            titleLabel.rightAnchor.constraint(equalTo: arrowImageView.leftAnchor, constant: -16)
        ]
        NSLayoutConstraint.activate(titleLabelConstraints)


        let arrowImageViewConstraints = [
            arrowImageView.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            arrowImageView.heightAnchor.constraint(equalToConstant: 16),
            arrowImageView.widthAnchor.constraint(equalToConstant: 16),
            arrowImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -16)
        ]
        NSLayoutConstraint.activate(arrowImageViewConstraints)

        let horizontalLineViewConstraints = [
            horizontalLineView.leftAnchor.constraint(equalTo: leftAnchor),
            horizontalLineView.bottomAnchor.constraint(equalTo: bottomAnchor),
            horizontalLineView.rightAnchor.constraint(equalTo: rightAnchor),
            horizontalLineView.heightAnchor.constraint(equalToConstant: 1)
        ]
        NSLayoutConstraint.activate(horizontalLineViewConstraints)
    }

    func configureView() {
        backgroundColor = .white
        titleLabel.textColor = .systemBlue
        titleLabel.font = .boldSystemFont(ofSize: 14)
        horizontalLineView.backgroundColor = #colorLiteral(red: 0.8862745098, green: 0.8862745098, blue: 0.8862745098, alpha: 1)
        arrowImageView.contentMode = .scaleAspectFit
        selectionStyle = .none
        separatorInset = UIEdgeInsets(top: 0, left: UIScreen.main.bounds.size.width, bottom: 0, right: 0)
    }
}

