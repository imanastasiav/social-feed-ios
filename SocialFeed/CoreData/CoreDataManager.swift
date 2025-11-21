//
//  CoreManager.swift
//  SocialFeed
//
//  Created by Анастасия on 20.11.2025.
//

import CoreData
import UIKit

final class CoreDataManager {

    static let shared = CoreDataManager()
    private init() {}

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores { _, error in
            if let error = error { fatalError("CoreData error: \(error)") }
        }
        return container
    }()

    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    func savePosts(_ dtos: [Post]) {

        let fetch = Entity.fetchRequest()
        if let old = try? context.fetch(fetch) {
            old.forEach { context.delete($0) }
        }

        for dto in dtos {
            let post = Entity(context: context)
            post.id = Int64(dto.id ?? 0)
            post.userId = Int64(dto.userId ?? 0)
            post.title = dto.title
            post.body = dto.body
        }

        saveContext()
    }

    func fetchPosts() -> [Entity] {
        let request = Entity.fetchRequest()
        return (try? context.fetch(request)) ?? []
    }

    func saveContext() {
        if context.hasChanges {
            try? context.save()
        }
    }
}
