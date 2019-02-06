//
//  GithubSearchViewController+Extension.swift
//  GithubSearch
//
//  Created by 김지우 on 2019. 1. 30..
//  Copyright © 2019년 havetherain. All rights reserved.
//

import UIKit

extension GithubSearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.removeAllData()
        if searchText.count == 0 {
            self.noDataLabel.isHidden = false
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.loadTable), object: searchBar)
            self.perform(#selector(self.loadTable), with: nil, afterDelay: 0.5)
            
        } else {
            self.noDataLabel.isHidden = true
            GithubSearchService.shared.getUserList(keyword: searchText, token: self.token) { (res) in
                self.searchUsersItems = res
                self.totalEntries = self.searchUsersItems.count
                self.appenddisplaySearchUsersItems(startIndex: 0)
            }
        }
    }
}

extension GithubSearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.displaySearchUsersItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GithubSearchTableViewCell", for: indexPath) as! GithubSearchTableViewCell
        cell.profileImageView.imageFromUrl(self.displaySearchUsersItems[indexPath.row].avatar_url, defaultImgPath: "defaultProfile")
        cell.nameLabel.text = self.displaySearchUsersItems[indexPath.row].login
        cell.publicReposCountLabel.text = "\(self.usersPublicRepoCntArray[indexPath.row])"
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == (self.displaySearchUsersItems.count - 1) {
            if self.displaySearchUsersItems.count < self.totalEntries {
                let startIndex = displaySearchUsersItems.count
                self.limit = startIndex + 20
                
                self.spinner = UIActivityIndicatorView.init(style: .gray)
                self.spinner.startAnimating()
                self.spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
                self.githubSearchTableView.tableFooterView = spinner
                self.refreshState = true
                self.githubSearchTableView.tableFooterView?.isHidden = false
                
                self.appenddisplaySearchUsersItems(startIndex: startIndex)
            }
        }
    }
}



