import UIKit
import SnapKit

final class PostTableViewCell: UITableViewCell, Reusable {

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 13)
        return label
    }()
    private lazy var nextImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = UIImage(safeNamed: "chevron")
        return imageView
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
        [titleLabel, nextImageView].forEach(contentView.addSubview(_:))
    }

    private func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.top.bottom.equalToSuperview().inset(13)
        }
        nextImageView.snp.makeConstraints { make in
            make.left.equalTo(titleLabel.snp.right).offset(15)
            make.right.equalToSuperview().inset(13)
            make.width.height.equalTo(14)
            make.centerY.equalToSuperview()
        }
    }

    func apply(cellDisplayModel: PostList.CellDisplayModel.Post) {
        titleLabel.text = cellDisplayModel.title
    }
}