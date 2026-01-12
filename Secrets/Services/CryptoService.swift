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
}

class CryptoService {
    static let shared = CryptoService()
    
    func exportPublicKey() -> String {
        do {
            return try getMyPrivateKey().publicKey.rawRepresentation.base64EncodedString()
        } catch {
          print("Handle error properly")
          return ""
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
}

