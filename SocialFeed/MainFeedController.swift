//
//  MainFeedController.swift
//  SocialFeed
//
//  Created by Анастасия on 17.11.2025.
//

import UIKit
import SnapKit

final class MainFeedController: UIViewController {
    
    var posts: [Post] = []
    var postLoader = PostLoader()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView.init()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(PostCell.self, forCellReuseIdentifier: PostCell.reuseID)
        
        return tableView
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let rc = UIRefreshControl()
        rc.addTarget(self, action: #selector(refreshPosts), for: .valueChanged)
        return rc
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()
        
        fetchPosts()
    }
    
    @objc private func refreshPosts() {
        postLoader.loadPosts { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
                switch result {
                case .success(let posts):
                    self.posts = posts
                    self.tableView.reloadData()
                case .failure(let error):
                    print(error)
                }
            }
        }
    }

}

extension MainFeedController {
    
    private func setupViews() {
        view.addSubview(tableView)
        view.backgroundColor = .white
        tableView.refreshControl = refreshControl
    }
    private func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func fetchPosts() {
        postLoader.loadPosts { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let posts):
                self.posts = posts
                tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension MainFeedController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostCell.reuseID, for: indexPath) as? PostCell
            else { return UITableViewCell() }
        cell.update(posts[indexPath.row])
        return cell
    }
}
