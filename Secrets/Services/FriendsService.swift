//
//  FriendsService.swift
//  Secrets
//
//  Created by Mihail Kalichkov on 12.01.26.
//

import Foundation
import Combine

protocol FriendsServiceProtocol: ObservableObject {
    var friendsPublisher: Published<[Friend]>.Publisher { get }
    func addFriend(_ friend: Friend)
}

class FriendsService: FriendsServiceProtocol {
    var friendsPublisher: Published<[Friend]>.Publisher { $friends }
    @Published var friends: [Friend] = []
    
    func addFriend(_ friend: Friend) {
        friends.append(friend)
    }
}

