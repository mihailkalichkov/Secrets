//
//  ContactsView.swift
//  Secrets
//
//  Created by Mihail Kalichkov on 12.01.26.
//

import SwiftUI

@MainActor protocol ContactsViewModelProtocol: ObservableObject {
    var friends: [Friend] { get }
    var encryptedMessage: String { get }
    func saveFriendTapped(name: String, key: String)
    func encryptMessageTapped(friend: Friend, message: String)
}

struct ContactsView<ViewModel: ContactsViewModelProtocol>: View {
    @StateObject var viewModel: ViewModel
    
    @State private var showingAddSheet = false
    
    @State private var newName = ""
    @State private var newKeyString = ""
    
    @State private var message = ""
    
    var body: some View {
        NavigationView {
            VStack {
                friendsList
                    .padding(.horizontal, 16)
                
                encryptedMessage
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
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
            Section(header: Text("Message to encrypt")) {
                TextField("Type a message", text: $message)
            }
            Section(header: Text("My Friends")) {
                ForEach(viewModel.friends) { friend in
                    VStack {
                        Text(friend.name)
                        Text("Key: \(friend.publicKeyBase64.prefix(8))...")
                            .font(.caption)
                            .foregroundStyle(.gray)
                        
                        Button("Encrypt message for \(friend.name)") {
                            viewModel.encryptMessageTapped(friend: friend, message: message)
                        }
                        .buttonStyle(.borderedProminent)
                        .padding(.top, 6)
                    }
                }
            }
        }
    }
    
    @ViewBuilder var encryptedMessage: some View {
        if !viewModel.encryptedMessage.isEmpty {
            Section(header: Text("Encrypted Message")) {
                Text(viewModel.encryptedMessage)
                    .font(.system(.body, design: .monospaced))
                    .textSelection(.enabled)
                
                Text("Copy this message and send to a friend or create a QR code")
                    .font(.callout)
                
                Button("Copy message to Clipboard") {
                    UIPasteboard.general.string = viewModel.encryptedMessage
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
