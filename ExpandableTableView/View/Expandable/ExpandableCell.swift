import UIKit

final class ExpandableCell: UITableViewCell {

    private let containerView: UIView = UIView()
    private var lineView: UIView = UIView()
    private let titleLabel: UILabel = UILabel()
    private let descriptionLabel: UILabel = UILabel()
    private let arrowImageView: UIImageView = UIImageView()
    private var bottomConstraintOn, bottomConstraintOff: NSLayoutConstraint?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(item: Section) {
        //let isExpanded = item.isExpanded ?? false

        //rotateArrowImage(isExpanded: isExpanded)

        titleLabel.text = item.title
        //descriptionLabel.text = isExpanded ? "\n"+item.title+"\n": ""

//        lineView.isHidden = !isExpanded ? true : false
//        bottomConstraintOn?.isActive = isExpanded
//        bottomConstraintOff?.isActive = !isExpanded
    }

    func update(title: String, description: String) {
         titleLabel.text = title
         descriptionLabel.text = description
    }

    private func rotateArrowImage(isExpanded: Bool) {
        UIView.animate(withDuration: 0.3) {
            self.arrowImageView.transform = CGAffineTransform(rotationAngle: isExpanded ? .pi : 0)
        }
    }
}

extension ExpandableCell: ViewCodable {

    func configureView() {
        lineView.backgroundColor = UIColor.gray.withAlphaComponent(0.3)
        arrowImageView.image = UIImage(named: "expand-button")
        titleLabel.numberOfLines = 0
        titleLabel.textColor = .black
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textColor = UIColor.darkGray
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        backgroundColor = .white
    }

    func configureHierarchy() {
        [lineView, descriptionLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview($0)
        }

        [titleLabel, arrowImageView, containerView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
    }

    func configureConstraints() {
        NSLayoutConstraint.activate([
            arrowImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            arrowImageView.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            arrowImageView.heightAnchor.constraint(equalToConstant: 24),
            arrowImageView.widthAnchor.constraint(equalToConstant: 24),
        ])

        bottomConstraintOff = titleLabel.bottomAnchor.constraint(equalTo: containerView.topAnchor)
        bottomConstraintOff?.priority = .defaultLow
        bottomConstraintOff?.isActive = true

        bottomConstraintOn = titleLabel.bottomAnchor.constraint(equalTo: containerView.topAnchor, constant: -16)
        bottomConstraintOn?.priority = .defaultHigh
        bottomConstraintOn?.isActive = true

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: arrowImageView.leadingAnchor, constant: -16)
        ])

        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        NSLayoutConstraint.activate([
            lineView.topAnchor.constraint(equalTo: containerView.topAnchor),
            lineView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            lineView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            lineView.heightAnchor.constraint(equalToConstant: 1)
        ])

        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: lineView.bottomAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16),
            descriptionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16)
        ])
    }
}


