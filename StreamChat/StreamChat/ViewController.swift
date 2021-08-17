//
//  StreamChat - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import SnapKit

class ViewController: UIViewController {

    let tableView = UITableView()
    let sendMessageView = SendMessageView()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        setupSendMessageView()
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.delegate = self

        tableView.backgroundColor = .systemBackground
        tableView.snp.makeConstraints { tableView in
            tableView.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
    }

    private func setupSendMessageView() {
        view.addSubview(sendMessageView)

        sendMessageView.snp.makeConstraints { sendView in
            sendView.height.equalTo(70)
            sendView.top.equalTo(tableView.snp.bottom)
            sendView.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }

}

// MARK: - TableView Delegate
extension ViewController: UITableViewDelegate {

}

// MARK: - TableView DataSource
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath) as? TableViewCell else { return UITableViewCell() }

        return cell
    }

}
