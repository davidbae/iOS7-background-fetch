//
//  DBUAppDelegate.h
//  DBUBackgroundFetch
//
//  Created by David Bae on 2014. 3. 7..
//  Copyright (c) 2014년 David Bae. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DBUAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, assign) BOOL backgroundFetchOn;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
