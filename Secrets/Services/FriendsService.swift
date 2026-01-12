//
//  FriendsService.swift
//  Secrets
//
//  Created by Mihail Kalichkov on 12.01.26.
//

import Foundation
import Combine

protocol FriendsServiceProtocol: ObservableObject {
    var friends: [Friend] { get }
    var friendsPublisher: Published<[Friend]>.Publisher { get }
    func addFriend(_ friend: Friend)
}

class FriendsService: FriendsServiceProtocol {
    @Published var friends: [Friend] = []
    var friendsPublisher: Published<[Friend]>.Publisher { $friends }
    
    func addFriend(_ friend: Friend) {
        friends.append(friend)
    }
}

