//
//  SceneDelegate.swift
//  EMTodo
//
//  Created by Данила Бондарь on 16.05.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    static let taskLoadedNotificationName = Notification.Name("TaskLoadedNotification")
    static let isInitialTaskLoadaedKey = "isInitialTaskLoadaed"
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        let taskManager = CoreDataTaskManager()
        let modelFactory = BaseModelsFactory(taskManager: taskManager)
        let viewControllerFabric = BaseViewControllerFactory(modelsFactory: modelFactory)
        
        let coordinator = BaseCoordinator(viewControllersFabric: viewControllerFabric)
        
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        window?.rootViewController = coordinator.mainViewController
        window?.makeKeyAndVisible()
        
        loadInitialTasksIfNeeded(taskManager: taskManager)
    }
    
    private func loadInitialTasksIfNeeded(taskManager: TaskManager) {
        let userDefaults = UserDefaults.standard
        if userDefaults.bool(forKey: SceneDelegate.isInitialTaskLoadaedKey) == false {
            loadInitialTasks(taskManager: taskManager)
            userDefaults.set(true, forKey: SceneDelegate.isInitialTaskLoadaedKey)
        }
    }
    
    private func loadInitialTasks(taskManager: TaskManager) {
        //Решил обойтись без протокола, ибо в этом месте лишнее уже.
        //Вряд-ли будет много разных загрузчиков. И нигде кроме этого места он точно не будет использоваться
        let initial = InitialTaskLoader()
        initial.loadInitialTasks(completion: { tasks in
            var addedCount = 0
            for task in tasks {
                taskManager.add(task) { _ in
                    addedCount += 1
                    if addedCount == tasks.count {
                        NotificationCenter.default.post(name: SceneDelegate.taskLoadedNotificationName, object: nil)
                    }
                }
            }
        })
    }
    
}

