import UIKit
import SnapKit

final class NoDataTableViewCell: UITableViewCell, Reusable {

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 12)
        label.textColor = .darkGray
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none
        configureViewHierarchy()
        configureLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("\(#function) has not been implemented")
    }

    private func configureViewHierarchy() {
        contentView.addSubview(descriptionLabel)
    }

    private func configureLayout() {
        descriptionLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(20)
        }
    }

    func apply(cellDisplayModel: PostList.CellDisplayModel.NoData) {
        descriptionLabel.text = cellDisplayModel.description
    }
}
