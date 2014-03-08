//
//  FetchTime.h
//  DBUBackgroundFetch
//
//  Created by David Bae on 2014. 3. 9..
//  Copyright (c) 2014년 David Bae. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface FetchTime : NSManagedObject

@property (nonatomic, retain) NSDate * time;
@property (nonatomic, retain) NSString * title;

@end
