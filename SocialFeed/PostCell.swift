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
    
    private var containerView: UIView = {
        var view = UIView()
        view.backgroundColor = .white
        
        return view
    }()
    
    private var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private var headingLabel: UILabel = {
        let label = UILabel()
        label.text = "Заголовок"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    private var postTextLabel: UILabel = {
        let label = UILabel()
        label.text = "Текст"
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 12)
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
    
    func update(_ post: Post) {
        headingLabel.text = post.title
        postTextLabel.text = post.body
        
        let urlString = "https://api.dicebear.com/7.x/bottts/png?seed=\(String(describing: post.id))"
        //https://ui-avatars.com/api/?name=\(post.id)&size=128&background=random&bold=true
        if let url = URL(string: urlString) {
            loadImage(from: url)
        }
    }
    
    private func loadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.avatarImageView.image = image
                }
            }
        }.resume()
    }
}

extension PostCell {
    
    private func setupViews() {
        contentView.addSubview(containerView)
        containerView.addSubview(avatarImageView)
        containerView.addSubview(headingLabel)
        containerView.addSubview(postTextLabel)
    }
    
    private func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
        
        avatarImageView.snp.makeConstraints { make in
            make.left.equalTo(containerView).inset(8)
            make.top.equalToSuperview()
            make.width.height.equalTo(40)
        }
        
        headingLabel.snp.makeConstraints { make in
            make.top.right.equalTo(containerView).inset(8)
            make.left.equalTo(avatarImageView.snp.right).offset(16)
        }
        
        postTextLabel.snp.makeConstraints { make in
            make.top.equalTo(avatarImageView.snp.bottom).offset(8)
            make.left.equalTo(containerView).inset(16)
            make.right.bottom.equalTo(containerView).inset(8)
        }
    }
}
