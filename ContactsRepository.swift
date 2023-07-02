//
//  ContactsRepository.swift
//  secretContactsBook
//
//  Created by Jai Telang on 02/07/23.
//

class ContactsRepository {
    private let dataManager = ContactsDataManager.shared
    
    // MARK: Public Helpers
    
    func fetch(token: String?) -> [Contact] {
        return dataManager.fetch(token: token)
    }
    
    func fetchSortedResponses(token: String?) -> [Contact] {
        return dataManager.fetchSortedResponses(token: token)
    }

    func addContact(_ contact: Contact) {
        dataManager.insert(contact)
    }

    func deleteContact(_ contact: Contact) {
        dataManager.delete(contact)
    }
    
    func save() {
        dataManager.save()
    }
}

