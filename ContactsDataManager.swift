//
//  ContactsDataManager.swift
//  secretContactsBook
//
//  Created by Jai Telang on 02/07/23.
//

import CoreData

class ContactsDataManager {
    static let shared = ContactsDataManager()
    private lazy var persistenceContainer: NSPersistentContainer = {
        let persistenceContainer = NSPersistentContainer(name: "ContactData")
        persistenceContainer.loadPersistentStores { (storeDescription, error) in
            if let error = error as? NSError {

                // I must actually add support to show the error disallowing persistentContainer to load
                // instead of fatalError that could the application to crash.
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return persistenceContainer
    }()

    private lazy var context = persistenceContainer.viewContext

    private init() {}

    // MARK: Public Helpers

    func save() {
        do {
            try context.save()
        } catch {
            let nserror = error as NSError
            fatalError("Save error occurred \(nserror), \(nserror.userInfo)")
        }
    }

    func fetch(token: String?) -> [Contact] {
        do {
            let request = Contact.fetchRequest()
            request.predicate = NSPredicate(format: "token LIKE %@", token!)
            return try context.fetch(request)
        } catch {
            let nserror = error as NSError
            fatalError("Fetch error occurred \(nserror), \(nserror.userInfo)")
        }
    }

    // Fetches responses sorted as per their firstName and lastName
    func fetchSortedResponses(token: String?) -> [Contact] {
        do {
            let request = Contact.fetchRequest()
            request.predicate = NSPredicate(format: "token LIKE %@", token!)
            request.sortDescriptors = [NSSortDescriptor(key: "firstName", ascending: true), NSSortDescriptor(key: "lastName", ascending: true)]
            return try context.fetch(request)
        } catch {
            let nserror = error as NSError
            fatalError("Fetch error occurred \(nserror), \(nserror.userInfo)")
        }
    }

    func insert(_ contact: Contact) {
        context.insert(contact)
        save()
    }

    func delete(_ contact: Contact) {
        context.delete(contact)
        save()
    }

    func printDefaultDirectoryPath() {
        debugPrint(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0])
    }
}
