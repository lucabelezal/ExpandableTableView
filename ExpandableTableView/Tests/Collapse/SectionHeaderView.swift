import UIKit

class SectionHeaderView: UITableViewHeaderFooterView, CollapseSectionHeader, ReusableView {

    let imageView: UIImageView = UIImageView()

    var indicatorImageView: UIImageView {
        return imageView
    }

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        addSubview(imageView)
        imageView.backgroundColor = .red
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
            imageView.widthAnchor.constraint(equalToConstant: 24),
            imageView.heightAnchor.constraint(equalToConstant: 24)
        ])

        imageView.image = #imageLiteral(resourceName: "expand-button") .withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .white
        backgroundColor = .blue
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
