//
//  SignUpViewController.swift
//  secretContactsBook
//
//  Created by Jai Telang on 01/07/23.
//

import Foundation
import UIKit

class SecretContactsViewController: UIViewController {

    // MARK: Public Variable
    /*
     Unique token to isolate the information of users from each other.
     */
    var token: String?

    // MARK: IBOutlets

    @IBOutlet weak var tableView: UITableView!

    @IBAction func didTapSortButton(_ sender: Any) {
        self.viewModel.fetchSortedResponses()
    }

    @IBAction func didTapDone(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let welcomeScreen = storyboard.instantiateViewController(withIdentifier: "WelcomeViewController")
        welcomeScreen.modalPresentationStyle = .overFullScreen
        self.present(welcomeScreen, animated: true)
    }

    @IBAction func didTapAddButton(_ sender: Any) {
        showAddContactDialog()
    }

    // MARK: Private Properties

    private lazy var viewModel = ContactsViewModel()

    private var contact: [Contact] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    // MARK: Lifecycle Method

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "contactListCellReuseId")
        setupTableView()
        viewModel.token = self.token
        viewModel.addObserver(self)
        viewModel.reloadData()
    }
    
    // MARK: Private Helpers

    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }

    private func showAddContactDialog() {
        guard let uniqueToken = self.token else {
            fatalError("Every user must have a token assigned to him.")
        }

        let saveActionAlert = UIAlertController(title: "Add Contact", message: "", preferredStyle: .alert)
        
        saveActionAlert.addTextField { (textField) in
            textField.placeholder = "First Name"
        }
        saveActionAlert.addTextField { (textField) in
            textField.placeholder = "Last Name"
        }
        saveActionAlert.addTextField { (textField) in
            textField.placeholder = "Phone Number"
        }
        let saveAction = UIAlertAction(title: "Add", style: .default) { [weak self] _ in
            self?.viewModel.addContact(firstName: saveActionAlert.textFields?[0].text, lastName: saveActionAlert.textFields?[1].text, phoneNumber: saveActionAlert.textFields?[2].text, contactImage: nil, token: uniqueToken)
        }
        let concelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        saveActionAlert.addAction(saveAction)
        saveActionAlert.addAction(concelAction)
        present(saveActionAlert, animated: true)
    }

    private func showEditDialogBox(for indexPath: IndexPath) {
        guard let uniqueToken = self.token else {
            fatalError("Every user must have a token assigned to him.")
        }
        
        let editContactAlert = UIAlertController(title: "Edit Contact", message: "", preferredStyle: .alert)
        let contact = contact[indexPath.row]
        
        editContactAlert.addTextField { (textField) in
            textField.placeholder = "First Name"
            textField.text = contact.firstName
        }
        editContactAlert.addTextField { (textField) in
            textField.placeholder = "Last Name"
            textField.text = contact.lastName
        }
        editContactAlert.addTextField { (textField) in
            textField.placeholder = "Phone Number"
            textField.text = contact.phoneNumber
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self] _ in
            self?.viewModel.updateContact(at: indexPath.row, firstName: editContactAlert.textFields?[0].text, lastName: editContactAlert.textFields?[1].text, phoneNumber: editContactAlert.textFields?[2].text, contactImage: nil, token: uniqueToken)
        }
        editContactAlert.addAction(saveAction)
        editContactAlert.addAction(cancelAction)
        present(editContactAlert, animated: true)
    }
}
    
// MARK: ContactsViewModelObserver
    
extension SecretContactsViewController: ContactsViewModelObserver {
    func viewModelDidUpdate(contacts: [Contact]) {
        self.contact = contacts
    }
}

// MARK: UITableViewDelegate

extension SecretContactsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showEditDialogBox(for: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "delete") { [weak self] (_, _, _) in
            self?.viewModel.deleteContact(at: indexPath.row)
        }
        deleteAction.backgroundColor = UIColor.systemBlue
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
    
    // MARK: UITableViewDataSource

    extension SecretContactsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contact.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactListCellReuseId", for: indexPath)
        var content = cell.defaultContentConfiguration()
        let contact = contact[indexPath.row]
        content.text = [contact.firstName, contact.lastName].compactMap { $0 }.joined(separator: " ")+("\n"+contact.phoneNumber!)
        cell.contentConfiguration = content
        return cell
    }
}
