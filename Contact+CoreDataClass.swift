//
//  Contact+CoreDataClass.swift
//  secretContactsBook
//
//  Created by Jai Telang on 02/07/23.
//
//

import Foundation
import CoreData

@objc(Contact)
public class Contact: NSManagedObject {
    convenience init(firstName: String?, lastName: String?, phoneNumber: String?, contactImage: Data?, token: String?) {
        self.init(entity: Self.entity(), insertInto: nil)
        self.firstName = firstName?.isEmpty == false ? firstName : nil
        self.lastName = lastName?.isEmpty == false ? lastName : nil
        self.phoneNumber = phoneNumber?.isEmpty == false ? phoneNumber : nil
        self.contactImage = contactImage?.isEmpty == false ? contactImage : nil
        self.token = token?.isEmpty == false ? token : nil
    }

    func update(firstName: String?, lastName: String?, phoneNumber: String?, contactImage: Data?, token: String?) {
        self.firstName = firstName?.isEmpty == false ? firstName : nil
        self.lastName = lastName?.isEmpty == false ? lastName : nil
        self.phoneNumber = phoneNumber?.isEmpty == false ? phoneNumber : nil
        self.contactImage = contactImage?.isEmpty == false ? contactImage : nil
        self.token = token?.isEmpty == false ? token : nil
    }
}
