//
//  PostCell.swift
//  SocialFeed
//
//  Created by Анастасия on 17.11.2025.
//

import UIKit
import SnapKit

final class PostCell: UITableViewCell {

    static let reuseID = "PostCell"

    private var avatarImageView: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 10
        image.clipsToBounds = true
        return image
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()
    
    private var bodyLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.numberOfLines = 0
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(_ post: Entity) {
        titleLabel.text = post.title
        bodyLabel.text = post.body

        let urlString = "https://picsum.photos/seed/\(post.id)/80/80"

        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { data, _, _ in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.avatarImageView.image = image
                    }
                }
            }.resume()
        }
    }

    private func setupViews() {
        contentView.addSubview(avatarImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(bodyLabel)
    }

    private func setupConstraints() {
        avatarImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(20)
            make.width.height.equalTo(30)
        }

        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(avatarImageView.snp.right).offset(12)
            make.top.equalToSuperview().inset(20)
            make.right.equalToSuperview().inset(20)
        }

        bodyLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalTo(avatarImageView.snp.bottom).offset(8)
            make.bottom.equalToSuperview().inset(12)
        }
    }
}

