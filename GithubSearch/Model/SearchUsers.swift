//
//  SearchUsers.swift
//  GithubSearch
//
//  Created by 김지우 on 2019. 1. 31..
//  Copyright © 2019년 havetherain. All rights reserved.
//

import Foundation

struct SearchUsers: Codable {
    let items: [SearchUsersItems]
}

struct SearchUsersItems: Codable {
    let login: String?
    let id: Int?
    let node_id: String?
    let avatar_url: String?
    let gravatar_id: String?
    let url: String?
    let html_url: String?
    let followers_url: String?
    let subscriptions_url: String?
    let organizations_url: String?
    let repos_url: String?
    let received_events_url: String?
    let type: String?
    let score: Double?
}
