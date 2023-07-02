//
//  ContactsViewModel.swift
//  secretContactsBook
//
//  Created by Jai Telang on 02/07/23.
//

import Foundation

protocol ContactsViewModelObserver: AnyObject {
    /*
     Implement this method where you need to update the view in case contacts info changes.

     In my case the viewController responsible of updating the view is SecretContactsViewController.
     So I have made SecretContactsViewController conform to ContactsViewModelObserver and implemented
     this method.
     */
    func viewModelDidUpdate(contacts: [Contact])
}

class ContactsViewModel {
    var token: String?

    private let repository = ContactsRepository()

    private var observer: ContactsViewModelObserver? = nil {
        didSet {
            observer?.viewModelDidUpdate(contacts: contacts)
        }
    }

    private var contacts: [Contact] = [] {
        didSet {
            observer?.viewModelDidUpdate(contacts: contacts)
        }
    }

    func reloadData() {
        self.contacts = repository.fetch(token: self.token)
    }

    func fetchSortedResponses() {
        self.contacts = repository.fetchSortedResponses(token: self.token)
    }

    func addObserver(_ observer: ContactsViewModelObserver) {
        self.observer = observer
    }

    func addContact(firstName: String?, lastName: String?, phoneNumber: String?, contactImage: Data?, token: String) {
        let contact = Contact(firstName: firstName, lastName: lastName, phoneNumber: phoneNumber, contactImage: nil, token: token)
        repository.addContact(contact)
        reloadData()
    }

    func deleteContact(at index: Int) {
        let contact = contacts[index]
        repository.deleteContact(contact)
        reloadData()
    }

    func updateContact(at index: Int, firstName: String?, lastName: String?, phoneNumber: String?, contactImage: Data?, token: String) {
        let contact = contacts[index]
        contact.update(firstName: firstName, lastName: lastName, phoneNumber: phoneNumber, contactImage: nil, token: token)
        repository.save()
        reloadData()
    }
}
