//
//  GithubSearchViewController.swift
//  GithubSearch
//
//  Created by 김지우 on 2019. 1. 30..
//  Copyright © 2019년 havetherain. All rights reserved.
//  

import UIKit

class GithubSearchViewController: UIViewController {
    @IBOutlet weak var githubSearchBar: UISearchBar!
    @IBOutlet weak var githubSearchTableView: UITableView!
    @IBOutlet weak var noDataLabel: UILabel!
    
    var displaySearchUsersItems: [SearchUsersItems] = []
    var searchUsersItems: [SearchUsersItems] = []
    var usersNamesArray: [String] = []
    var usersPublicRepoCntArray: [Int] = []
    
    var limit: Int = 20
    var refreshState: Bool = false
    var totalEntries: Int = 0
    var token: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.githubSearchBar.delegate = self
        self.githubSearchTableView.delegate = self
        self.githubSearchTableView.dataSource = self
    }
    
    func appenddisplaySearchUsersItems(startIndex: Int) {
        if self.totalEntries < self.limit {
            for index in startIndex..<self.totalEntries {
                self.displaySearchUsersItems.append(self.searchUsersItems[index])
                guard let username = self.displaySearchUsersItems[index].login else { return }
                self.usersNamesArray.append(username)
            }
        } else {
            for index in startIndex..<self.limit {
                self.displaySearchUsersItems.append(self.searchUsersItems[index])
                guard let username = self.displaySearchUsersItems[index].login else { return }
                self.usersNamesArray.append(username)
            }
        }
        self.getUserPublicRepoCnt(startIndex: startIndex)
    }
    
    func getUserPublicRepoCnt(startIndex: Int) {
        let group = DispatchGroup()
        
        let work = DispatchWorkItem {
            self.perform(#selector(self.loadTable), with: nil, afterDelay: 0.5)
        }
        if self.totalEntries < self.limit {
            for index in startIndex..<self.totalEntries {
                group.enter()
                GithubSearchService.shared.getUserInfo(username: self.usersNamesArray[index], token: self.token) { (res) in
                    self.usersPublicRepoCntArray.append(res)
                    group.leave()
                }
            }
        } else {
            for index in startIndex..<self.limit {
                group.enter()
                GithubSearchService.shared.getUserInfo(username: self.usersNamesArray[index], token: self.token) { (res) in
                    self.usersPublicRepoCntArray.append(res)
                    group.leave()
                }
            }
        }
        group.notify(queue: .main, work: work)
    }

    
    @objc func loadTable() {
        self.githubSearchTableView.reloadData()
    }
}

