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
        let container = NSPersistentContainer(name: "SocialFeed2") // твое имя модели!
        container.loadPersistentStores { _, error in
            if let error = error { fatalError("CoreData error: \(error)") }
        }
        return container
    }()

    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    // MARK: Save
    func savePosts(_ dtos: [Post]) {

        // Очищаем старые
        let fetch = Entity.fetchRequest()
        if let old = try? context.fetch(fetch) {
            old.forEach { context.delete($0) }
        }

        // Добавляем новые
        for dto in dtos {
            let post = Entity(context: context)
            post.id = Int64(dto.id ?? 0)
            post.userId = Int64(dto.userId ?? 0)
            post.title = dto.title
            post.body = dto.body
        }

        saveContext()
    }

    // MARK: Fetch
    func fetchPosts() -> [Entity] {
        let request = Entity.fetchRequest()
        return (try? context.fetch(request)) ?? []
    }

    // MARK: Save Context
    func saveContext() {
        if context.hasChanges {
            try? context.save()
        }
    }
}
