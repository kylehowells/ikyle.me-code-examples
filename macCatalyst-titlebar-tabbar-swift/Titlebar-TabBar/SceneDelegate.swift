//
//  SceneDelegate.swift
//  Titlebar-TabBar
//
//  Created by Kyle Howells on 31/05/2020.
//  Copyright © 2020 Kyle Howells. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate, NSToolbarDelegate {

	var window: UIWindow?
	var tabBarController: UITabBarController!

	func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
		guard let windowScene = (scene as? UIWindowScene) else { return }
		
		let window = UIWindow(windowScene: windowScene)
		
		tabBarController = UITabBarController()
		tabBarController.viewControllers = [FirstViewController(), SecondViewController()]
		window.rootViewController = tabBarController
		self.window = window
		window.makeKeyAndVisible()
		
		
		#if targetEnvironment(macCatalyst)
		let toolbar = NSToolbar(identifier: "mainToolbar")
		toolbar.centeredItemIdentifier = NSToolbarItem.Identifier(rawValue: "mainTabsToolbarItem")
		toolbar.delegate = self
		
		windowScene.titlebar?.titleVisibility = .hidden
		windowScene.titlebar?.toolbar = toolbar
		
		tabBarController.tabBar.isHidden = true
        #endif
	}

	func sceneDidDisconnect(_ scene: UIScene) {
		// Called as the scene is being released by the system.
		// This occurs shortly after the scene enters the background, or when its session is discarded.
		// Release any resources associated with this scene that can be re-created the next time the scene connects.
		// The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
	}

	func sceneDidBecomeActive(_ scene: UIScene) {
		// Called when the scene has moved from an inactive state to an active state.
		// Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
	}

	func sceneWillResignActive(_ scene: UIScene) {
		// Called when the scene will move from an active state to an inactive state.
		// This may occur due to temporary interruptions (ex. an incoming phone call).
	}

	func sceneWillEnterForeground(_ scene: UIScene) {
		// Called as the scene transitions from the background to the foreground.
		// Use this method to undo the changes made on entering the background.
	}

	func sceneDidEnterBackground(_ scene: UIScene) {
		// Called as the scene transitions from the foreground to the background.
		// Use this method to save data, release shared resources, and store enough scene-specific state information
		// to restore the scene back to its current state.
	}
	
	
	// MARK: - NSToolbarDelegate

	func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem?
	{
		if (itemIdentifier.rawValue == "mainTabsToolbarItem")
		{
			let group = NSToolbarItemGroup.init(itemIdentifier: itemIdentifier,
												titles: ["First", "Second"],
												selectionMode: .selectOne,
												labels: ["First view", "Second view"],
												target: self, action: #selector(toolbarGroupSelectionChanged))
			group.setSelected(true, at: 0)
			return group
		}
		
		return nil
	}

	func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
		return [NSToolbarItem.Identifier(rawValue: "mainTabsToolbarItem")]
	}

	func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
		return self.toolbarDefaultItemIdentifiers(toolbar)
	}


	@objc func toolbarGroupSelectionChanged(_ sender: NSToolbarItemGroup) {
		print("toolbarGroupSelectionChanged( \(sender.selectedIndex) )")
		tabBarController.selectedIndex = sender.selectedIndex
	}
}
