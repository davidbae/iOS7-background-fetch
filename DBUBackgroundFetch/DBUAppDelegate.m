//
//  DBUAppDelegate.m
//  DBUBackgroundFetch
//
//  Created by David Bae on 2014. 3. 7..
//  Copyright (c) 2014년 David Bae. All rights reserved.
//

#import "DBUAppDelegate.h"

@implementation DBUAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    //Background Fetch 초기화 함.
    // 가장 짧은 주기로 계속해서 패치하도록 옵션 설정
    [[UIApplication sharedApplication] setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
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
    UILocalNotification *noti = [[UILocalNotification alloc] init];
    if(noti)
    {
        noti.repeatInterval = 0.0f;
        noti.alertBody = [NSString stringWithFormat:@"Backgournd:%@", [NSDate date]];
        NSLog(@"%@", noti.alertBody);
        [[UIApplication sharedApplication] presentLocalNotificationNow:noti];
    }
    [[UIApplication sharedApplication] setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
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
            //배지로 숫자를 올려줌. 백그라운드에서 실행되기 때문에
            //배지로 뭔가 실행이 되엇다는 것을 알게 해줌.
            [UIApplication sharedApplication].applicationIconBadgeNumber++;
            
            //사용자에게 notification을 보냄.
            UILocalNotification *noti = [[UILocalNotification alloc] init];
            if(noti)
            {
                noti.repeatInterval = 0.0f;
                noti.alertBody = [NSString stringWithFormat:@"Fetch Success:(%d):%@",
                                  (int)data.length, [NSDate date]];
                [[UIApplication sharedApplication] presentLocalNotificationNow:noti];
            }
            //중복체크를 위해서, 데이터를 저장함.
            
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
