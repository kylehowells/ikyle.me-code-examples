//
//  SceneDelegate.m
//  Titlebar-TabBar
//
//  Created by Kyle Howells on 31/05/2020.
//  Copyright © 2020 Kyle Howells. All rights reserved.
//

#import "SceneDelegate.h"
#import "FirstViewController.h"
#import "SecondViewController.h"

#if TARGET_OS_MACCATALYST
#import <AppKit/AppKit.h>

@interface SceneDelegate () <NSToolbarDelegate>
#else
@interface SceneDelegate ()
#endif
@property (nonatomic, strong) UITabBarController *tabbarController;
@end



@implementation SceneDelegate

- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions
{
    self.window = [[UIWindow alloc] initWithWindowScene:(UIWindowScene*)scene];
	_tabbarController = [[UITabBarController alloc] init];
	_tabbarController.viewControllers = @[ [[FirstViewController alloc] init], [[SecondViewController alloc] init] ];
	
	#if TARGET_OS_MACCATALYST
	NSToolbar *toolbar = [[NSToolbar alloc] initWithIdentifier:@"mainToolbar"];
	toolbar.centeredItemIdentifier = @"mainTabsToolbarItem";
	toolbar.delegate = self;
	
	[(UIWindowScene*)scene titlebar].toolbar = toolbar;
	[(UIWindowScene*)scene titlebar].titleVisibility = UITitlebarTitleVisibilityHidden;
	
	_tabbarController.tabBar.hidden = YES;
	#endif
	
	self.window.rootViewController = _tabbarController;
    [self.window makeKeyAndVisible];
}


- (void)sceneDidDisconnect:(UIScene *)scene {
	// Called as the scene is being released by the system.
	// This occurs shortly after the scene enters the background, or when its session is discarded.
	// Release any resources associated with this scene that can be re-created the next time the scene connects.
	// The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
}


- (void)sceneDidBecomeActive:(UIScene *)scene {
	// Called when the scene has moved from an inactive state to an active state.
	// Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
}


- (void)sceneWillResignActive:(UIScene *)scene {
	// Called when the scene will move from an active state to an inactive state.
	// This may occur due to temporary interruptions (ex. an incoming phone call).
}


- (void)sceneWillEnterForeground:(UIScene *)scene {
	// Called as the scene transitions from the background to the foreground.
	// Use this method to undo the changes made on entering the background.
}


- (void)sceneDidEnterBackground:(UIScene *)scene {
	// Called as the scene transitions from the foreground to the background.
	// Use this method to save data, release shared resources, and store enough scene-specific state information
	// to restore the scene back to its current state.
}


#pragma mark - NSToolbarDelegate

#if TARGET_OS_MACCATALYST

- (nullable NSToolbarItem *)toolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSToolbarItemIdentifier)itemIdentifier willBeInsertedIntoToolbar:(BOOL)flag
{
	if ([itemIdentifier isEqualToString:@"mainTabsToolbarItem"]) {
		NSToolbarItemGroup *group = [NSToolbarItemGroup groupWithItemIdentifier:itemIdentifier
																		 titles:@[@"First", @"Second"]
																  selectionMode:NSToolbarItemGroupSelectionModeSelectOne
																		 labels:@[@"First view", @"Second view"]
																		 target:self
																		 action:@selector(toolbarGroupSelectionChanged:)];
		[group setSelectedIndex:0];
		return group;
	}
	
	return nil;
}
    
/* Returns the ordered list of items to be shown in the toolbar by default.   If during initialization, no overriding values are found in the user defaults, or if the user chooses to revert to the default items this set will be used. */
- (NSArray<NSToolbarItemIdentifier> *)toolbarDefaultItemIdentifiers:(NSToolbar *)toolbar{
	return @[@"mainTabsToolbarItem"];
}

/* Returns the list of all allowed items by identifier.  By default, the toolbar does not assume any items are allowed, even the separator.  So, every allowed item must be explicitly listed.  The set of allowed items is used to construct the customization palette.  The order of items does not necessarily guarantee the order of appearance in the palette.  At minimum, you should return the default item list.*/
- (NSArray<NSToolbarItemIdentifier> *)toolbarAllowedItemIdentifiers:(NSToolbar *)toolbar{
	return [self toolbarDefaultItemIdentifiers:toolbar];
}


-(void)toolbarGroupSelectionChanged:(NSToolbarItemGroup*)sender{
	self.tabbarController.selectedIndex = sender.selectedIndex;
}
#endif

@end
