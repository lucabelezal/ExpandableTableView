import UIKit

public final class BrMScrollableStack: UIView {
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.contentInsetAdjustmentBehavior = .never
        view.showsVerticalScrollIndicator = false
        view.contentInset = .zero
        return view
    }()

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 0
        stackView.distribution = .fill
        return stackView
    }()

    public override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        backgroundColor = .cyan
        buildViewHierarchy()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func setScrollView(insets: UIEdgeInsets) {
        scrollView.contentInset = insets
    }

    public func update(with views: [UIView]) {
        removeAllArrangedSubviews()
        views.forEach(stackView.addArrangedSubview(_:))
    }

    public func setCustom(space: CGFloat, after viewOfType: UIView.Type) {
        if let view = stackView.arrangedSubviews.first(
            where: { $0.isKind(of: viewOfType) }
        ) {
            stackView.setCustomSpacing(space, after: view)
        }
    }

    private func removeAllArrangedSubviews() {
        stackView.arrangedSubviews.forEach { view in
            stackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
    }
}

extension BrMScrollableStack {
    public func buildViewHierarchy() {
        addSubview(scrollView)
        scrollView.addSubview(stackView)

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])


        NSLayoutConstraint.activate([
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor)
        ])
    }
}
