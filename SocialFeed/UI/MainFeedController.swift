//
//  MainFeedController.swift
//  SocialFeed
//
//  Created by Анастасия on 17.11.2025.
//

import UIKit
import SnapKit

final class MainFeedController: UIViewController {

    private var posts: [Entity] = []
    private var postLoader = PostLoader()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(PostCell.self, forCellReuseIdentifier: PostCell.reuseID)
        tableView.separatorStyle = .none
        return tableView
    }()

    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshFeed), for: .valueChanged)
        return refreshControl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()

        posts = CoreDataManager.shared.fetchPosts()
        tableView.reloadData()

        fetchPosts()
    }

    @objc private func refreshFeed() {
        fetchPosts()
    }

    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        tableView.refreshControl = refreshControl
    }

    private func setupConstraints() {
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    private func fetchPosts() {
        
        postLoader.loadPosts { result in

            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
            }

            switch result {
            case .success(let posts):

                CoreDataManager.shared.savePosts(posts)
                self.posts = CoreDataManager.shared.fetchPosts()

                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }

            case .failure(let error):
                print("Ошибка загрузки:", error)
            }
        }
    }
}

extension MainFeedController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        posts.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: PostCell.reuseID,
            for: indexPath
        ) as? PostCell else {
            return UITableViewCell()
        }

        cell.update(posts[indexPath.row])
        return cell
    }
}
