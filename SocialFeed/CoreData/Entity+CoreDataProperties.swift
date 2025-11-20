//
//  Entity+CoreDataProperties.swift
//  SocialFeed
//
//  Created by Анастасия on 20.11.2025.
//
//

import Foundation
import CoreData


extension Entity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Entity> {
        return NSFetchRequest<Entity>(entityName: "Entity")
    }

    @NSManaged public var userId: Int64
    @NSManaged public var id: Int64
    @NSManaged public var title: String?
    @NSManaged public var body: String?

}

extension Entity : Identifiable {

}
