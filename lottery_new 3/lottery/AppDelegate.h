//
//  AppDelegate.h
//  lottery
//
//  Created by wayne on 17/1/17.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainTabBarController.h"
#import <CoreData/CoreData.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate>
    
    @property (strong, nonatomic) UIWindow *window;
    
    @property (nonatomic,retain)MainTabBarController * maiTabBarController;
    
    @property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
    @property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
    @property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
    
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
    
    
    //- (void)loadLoginViewController;
    //- (void)loadMainViewController;
    //- (void)loadAddBabyViewController;
    
    //- (void)loadMainViewController2;
    
    // 加载3D Touch快捷方式
- (void)loadShortcutItems;
    
    @end

