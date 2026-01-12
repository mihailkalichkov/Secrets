//
//  ContactsView.swift
//  Secrets
//
//  Created by Mihail Kalichkov on 12.01.26.
//

import SwiftUI

@MainActor protocol ContactsViewModelProtocol: ObservableObject {
    var friends: [Friend] { get }
    func saveFriendTapped(name: String, key: String)
}

struct ContactsView<ViewModel: ContactsViewModelProtocol>: View {
    @StateObject var viewModel: ViewModel
    
    @State private var showingAddSheet = false
    
    @State private var newName = ""
    @State private var newKeyString = ""
    
    var body: some View {
        NavigationView {
            VStack {
                friendsList
                    .padding(.horizontal, 16)
            }
            .navigationTitle("Secure Contacts")
            .toolbar {
                Button(action: { showingAddSheet = true }) {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $showingAddSheet) {
                addFriendSheet
            }
        }
    }
    
    @ViewBuilder var friendsList: some View {
        List {
            Section(header: Text("My Friends")) {
                ForEach(viewModel.friends) { friend in
                    VStack {
                        Text(friend.name)
                        Text("Key: \(friend.publicKeyBase64.prefix(8))...")
                            .font(.caption)
                            .foregroundStyle(.gray)
                    }
                }
            }
        }
    }
    
    @ViewBuilder var addFriendSheet: some View {
        VStack(spacing: 20) {
            Text("Add Contact")
                .font(.headline)
            TextField("Friend's name", text: $newName)
                .textFieldStyle(.roundedBorder)
            TextField("Paste public key", text: $newKeyString)
                .textFieldStyle(.roundedBorder)
            
            Button("Save Friend") {
                viewModel.saveFriendTapped(name: newName, key: newKeyString)
                showingAddSheet = false
                newName = ""
                newKeyString = ""
            }
            .disabled(newName.isEmpty || newKeyString.isEmpty)
        }
        .padding(.horizontal, 16)
    }
}
