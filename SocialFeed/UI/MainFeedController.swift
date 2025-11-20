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
        let tv = UITableView()
        tv.dataSource = self
        tv.delegate = self
        tv.register(PostCell.self, forCellReuseIdentifier: PostCell.reuseID)
        return tv
    }()

    private lazy var refreshControl: UIRefreshControl = {
        let rc = UIRefreshControl()
        rc.addTarget(self, action: #selector(refreshFeed), for: .valueChanged)
        return rc
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()

        // 1. Загружаем оффлайн-посты
        posts = CoreDataManager.shared.fetchPosts()
        tableView.reloadData()

        // 2. Загружаем новые
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
            case .success(let postsDTO):

                CoreDataManager.shared.savePosts(postsDTO)
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
