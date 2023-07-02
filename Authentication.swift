//
//  Authentication.swift
//  secretContactsBook
//
//  Created by Jai Telang on 01/07/23.
//

import CryptoKit
import Foundation

enum AuthError: Error {
    case nameTaken
    case phoneNumberTaken
    case invalidUsername
    case invalidPassword
    case unknown
}

struct AuthInfo: Codable {
    let token: String
}

class Authentication {
    typealias AuthenticationHandler = (Result<String?, AuthError>) -> Void
    static let shared = Authentication()
    
    // These are the keys we will be using to save unique usernames and phonenumbers.
    private static let userKey = "Users"
    private static let phoneNumbersKey = "PhoneNumbers"

    private init() {}

    /*
        The Mapping is:
                        KEY ===> VALUE
         username+pass+salt ===> AuthInfo(i.e. unique token)
     */
    private func makeKey(username: String, password: String) -> String {
        let salt = "ixs^X9T@12QQvu1W"
        return "\(username).\(password).\(salt)".sha256()
    }

    func signIn(username: String, password: String, completion: @escaping AuthenticationHandler) {
        let username = username
        guard let usersData = KeychainWrapper.standard.data(forKey: Self.userKey),
              let decodedUsersData = try? JSONDecoder().decode([String].self, from: usersData),
              decodedUsersData.contains(username) else {
            completion(.failure(.invalidUsername))
            return
        }
        let key = makeKey(username: username, password: password)
        guard let data = KeychainWrapper.standard.data(forKey: key) else {
            completion(.failure(.invalidPassword))
            return
        }
        let authInfo = try! JSONDecoder().decode(AuthInfo.self, from: data)
        completion(.success(authInfo.token))
    }
    
    func signUp(username: String, phoneNumber: String, password: String, completion: @escaping AuthenticationHandler) {
        var users: [String] = []
        if let userData = KeychainWrapper.standard.data(forKey: Self.userKey) {
            let decodedUsernameList = try! JSONDecoder().decode([String].self, from: userData)
            users.append(contentsOf: decodedUsernameList)
        }
        var phoneNumbers: [String] = []
        if let phoneNumbersData = KeychainWrapper.standard.data(forKey: Self.phoneNumbersKey) {
            let decodedPhoneNumbersList = try! JSONDecoder().decode([String].self, from: phoneNumbersData)
            phoneNumbers.append(contentsOf: decodedPhoneNumbersList)
        }
        guard !users.contains(username) else {
            completion(.failure(.nameTaken))
            return
        }
        guard !phoneNumbers.contains(phoneNumber) else {
            completion(.failure(.phoneNumberTaken))
            return
        }
        let authInfo = AuthInfo(token: UUID().uuidString)
        // authInfo encoded from struct to json
        let data = try! JSONEncoder().encode(authInfo)
        let authInfoKey = makeKey(username: username, password: password)
        guard KeychainWrapper.standard.set(data, forKey: authInfoKey) else {
            completion(.failure(.unknown))
            return
        }
        users.append(username)
        phoneNumbers.append(phoneNumber)
        KeychainWrapper.standard.set(try! JSONEncoder().encode(users), forKey: Self.userKey)
        KeychainWrapper.standard.set(try! JSONEncoder().encode(phoneNumbers), forKey: Self.phoneNumbersKey)
        completion(.success(nil))
    }
}

extension String {
    fileprivate func sha256() -> String {
        return SHA256.hash(data: Data(self.utf8)).description
    }
}
