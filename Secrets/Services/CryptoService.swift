//
//  CryptoService.swift
//  Secrets
//
//  Created by Mihail Kalichkov on 12.01.26.
//

import Foundation
import CryptoKit

enum CryptoServiceError: Error {
    case errorCreatingTag
    case keyCorruption
    case encryptionFailed
    case decryptionFailed
}

protocol CryptoServiceProtocol {
    func exportPublicKey() -> String
    func encrypt(message: String, publicKey: P256.KeyAgreement.PublicKey) throws -> String?
    func decrypt(message: String, friendPublicKey: P256.KeyAgreement.PublicKey) throws -> String?
}

class CryptoService: CryptoServiceProtocol {
    func exportPublicKey() -> String {
        do {
            return try getMyPrivateKey().publicKey.rawRepresentation.base64EncodedString()
        } catch {
          print("Handle error properly")
          return ""
        }
    }
    
    public func encrypt(message: String, publicKey: P256.KeyAgreement.PublicKey) throws -> String? {
        guard let data = message.data(using: .utf8) else { return nil }
        
        do {
            let key = try deriveSharedKey(from: publicKey)
            let sealedBox = try AES.GCM.seal(data, using: key)
            
            return sealedBox.combined?.base64EncodedString()
        }
        catch {
            print("Encryption failed: \(error)")
            throw CryptoServiceError.encryptionFailed
        }
    }
    
    public func decrypt(message: String, friendPublicKey: P256.KeyAgreement.PublicKey) throws -> String? {
        guard let data = Data(base64Encoded: message) else { return nil }
        
        do {
            let key = try deriveSharedKey(from: friendPublicKey)
            let sealedBox = try AES.GCM.SealedBox(combined: data)
            let decryptedData = try AES.GCM.open(sealedBox, using: key)
            return String(data: decryptedData, encoding: .utf8)
        } catch {
            throw CryptoServiceError.decryptionFailed
        }
    }
    
    private func getMyPrivateKey() throws -> P256.KeyAgreement.PrivateKey {
        guard let tag = "com.kalichkov.mihail.Secrets".data(using: .utf8) else { throw CryptoServiceError.errorCreatingTag }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassKey,
            kSecAttrApplicationTag as String: tag,
            kSecAttrKeyType as String: kSecAttrKeyTypeECSECPrimeRandom,
            kSecReturnData as String: true
        ]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        // Check if we already have the key stored
        if status == errSecSuccess, let data = item as? Data {
            do {
                return try P256.KeyAgreement.PrivateKey(rawRepresentation: data)
            } catch {
                print("Key corruption detected.")
                throw CryptoServiceError.keyCorruption
            }
        }
        
        let newKey = P256.KeyAgreement.PrivateKey()
        
        let storeQuery: [String: Any] = [
            kSecClass as String: kSecClassKey,
            kSecAttrApplicationTag as String: tag,
            kSecAttrKeyType as String: kSecAttrKeyTypeECSECPrimeRandom,
            kSecValueData as String: newKey.rawRepresentation
        ]
        
        SecItemDelete(storeQuery as CFDictionary)
        SecItemAdd(storeQuery as CFDictionary, nil)
        
        return newKey
    }
    
    private func deriveSharedKey(from friendsPublicKey: P256.KeyAgreement.PublicKey) throws -> SymmetricKey {
        let myPrivateKey = try getMyPrivateKey()
        let sharedSecret = try myPrivateKey.sharedSecretFromKeyAgreement(with: friendsPublicKey)
        
        // Add Salt for more security
        return sharedSecret.hkdfDerivedSymmetricKey(using: SHA256.self,
                                                    salt: Data(),
                                                    sharedInfo: Data(),
                                                    outputByteCount: 32)
    }
}

