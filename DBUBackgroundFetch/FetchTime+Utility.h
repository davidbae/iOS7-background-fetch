//
//  FetchTime+Utility.h
//  DBUBackgroundFetch
//
//  Created by David Bae on 2014. 3. 9..
//  Copyright (c) 2014년 David Bae. All rights reserved.
//

#import "FetchTime.h"
#import "DBUAppDelegate.h"

@interface FetchTime (Utility)

+ (FetchTime *)addFetchTime:(NSString *)string;
+ (NSArray *)allFetchTime;

@end
