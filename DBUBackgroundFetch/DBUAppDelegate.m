//
//  DBUAppDelegate.m
//  DBUBackgroundFetch
//
//  Created by David Bae on 2014. 3. 7..
//  Copyright (c) 2014년 David Bae. All rights reserved.
//

#import "DBUAppDelegate.h"
#import "FetchTime+Utility.h"

#define DATAMODEL_NAME @"DBULog"
#define SQLITE_NAME @"DBULog.sqlite"

@implementation DBUAppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

//@synthesize backgroundFetchOn = _backgroundFetchOn;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    //Background Fetch 초기화 함.
    // 가장 짧은 주기로 계속해서 패치하도록 옵션 설정
    //[[UIApplication sharedApplication] setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    NSArray *fetchTimes = [FetchTime allFetchTime];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    FetchTime *fTime;
    if (self.backgroundFetchOn) {
        [[UIApplication sharedApplication] setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
        fTime = [FetchTime addFetchTime:@"Background Fetch Start"];
        //백그라운드로 들어가면서 언제 들어 갔는지 Local Notification으로 남긴다.
        UILocalNotification *noti = [[UILocalNotification alloc] init];
        if(noti)
        {
            noti.repeatInterval = 0.0f;
            noti.alertBody = [NSString stringWithFormat:@"%@:%@", fTime.title, fTime.time];
            NSLog(@"%@", noti.alertBody);
            [[UIApplication sharedApplication] presentLocalNotificationNow:noti];
        }
    }else{
        //Fetch를 Off이면 패치를 하지 않도록 한다.
        [[UIApplication sharedApplication] setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalNever];
        fTime = [FetchTime addFetchTime:@"Background Fetch Off"];
        
    }
    
    //백그라운드로 들어가면서 언제 들어 갔는지 Local Notification으로 남긴다.
    UILocalNotification *noti = [[UILocalNotification alloc] init];
    if(noti)
    {
        noti.repeatInterval = 0.0f;
        noti.alertBody = [NSString stringWithFormat:@"%@:%@", fTime.title, fTime.time];
        NSLog(@"%@", noti.alertBody);
        [[UIApplication sharedApplication] presentLocalNotificationNow:noti];
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void) addTimeWithString:(NSString *)str
{
    NSManagedObjectContext *context = self.managedObjectContext;
    
//    UsageStatisticDate *usageDate = [NSEntityDescription insertNewObjectForEntityForName:@"UsageStatisticDate" inManagedObjectContext:context];
//    usageDate.executedate = @"2013-12-26 using UsageStatisticDate class";
    
    NSError *error;
    [context save:&error];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (void) setBackgroundFetchOn:(BOOL)backgroundFetchOn
{
    [[NSUserDefaults standardUserDefaults] setObject:(backgroundFetchOn?@"YES":@"NO") forKey:@"backgroundFetchOn"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSLog(@"backgroundFetch : %@", (backgroundFetchOn)?@"ON":@"OFF");
}
- (BOOL) backgroundFetchOn
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"backgroundFetchOn"];
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:DATAMODEL_NAME withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:SQLITE_NAME];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


#pragma mark - Background Fetch
- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    NSLog(@"Received Background Fetch");
    //데이터를 받아오거나 호출할 URL
    NSURL *url = [NSURL URLWithString:@"http://hidavidbae.blogspot.kr"];
    
    //URL객체가 잘 만들어졌을 경우
    if (url != nil) {
        // URL로 호출할 때 사용할 request객체임.
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        //데이터 로드 실패 시 주소를 받아올 에러 포인터
        NSError *error = nil;
        //해당 URL의 데이터를 가져옴
        NSData *data = [NSURLConnection sendSynchronousRequest:request
                                             returningResponse:nil error:&error];
        //데이터가 로딩이 되었을 경우
        if (data != nil) {
            
            //사용자에게 local notification을 보냄.
            UILocalNotification *noti = [[UILocalNotification alloc] init];
            if(noti)
            {
                noti.repeatInterval = 0.0f;
                noti.alertBody = [NSString stringWithFormat:@"Fetch Success:(%d):%@",
                                  (int)data.length, [NSDate date]];
                [[UIApplication sharedApplication] presentLocalNotificationNow:noti];
            }
            [FetchTime addFetchTime:@"Fetch Success"];
            
            //성공했음을 알림
            completionHandler(UIBackgroundFetchResultNewData);
        }else{
            //에러를 로그로 찍음.
            NSLog(@"%@", error);
            //실패했음을 알림.
            completionHandler(UIBackgroundFetchResultFailed);
        }
    }else{
        //실패했음을 알림.
        completionHandler(UIBackgroundFetchResultFailed);
    }
}

@end
