//
//  FetchTime+Utility.m
//  DBUBackgroundFetch
//
//  Created by David Bae on 2014. 3. 9..
//  Copyright (c) 2014년 David Bae. All rights reserved.
//

#import "FetchTime+Utility.h"

@implementation FetchTime (Utility)

+ (FetchTime *)addFetchTime:(NSString *)string
{
    NSArray *times = nil;
    NSError *error = nil;
    DBUAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *managedContext = [appDelegate managedObjectContext];
    
    NSFetchRequest *request;
    
    request = [NSFetchRequest fetchRequestWithEntityName:@"FetchTime"];
    request.predicate = [NSPredicate predicateWithFormat:@"time = %@", [NSDate date]];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"time" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    
    times = [managedContext executeFetchRequest:request error:&error];
    
    FetchTime *fetchTime = nil;
    if( [times count] == 0 )
    {   //처음 실행하는 것이므로, Date와 time을 만들어서 넣는다.
        //NSLog(@"There is no FetchTime. so add one");
        fetchTime = [NSEntityDescription insertNewObjectForEntityForName:@"FetchTime" inManagedObjectContext:managedContext];
        fetchTime.time = [NSDate date];
        fetchTime.title = string;
    }else{//아미 안에 있다.
        fetchTime = times[0];
        //NSLog(@"Found :%d, %@", (int)[times count], fetchTime.time);
    }

    [managedContext save:&error];
    return fetchTime;
}

+ (NSArray *)allFetchTime
{
    NSArray *times = nil;
    NSError *error = nil;
    DBUAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *managedContext = [appDelegate managedObjectContext];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"FetchTime"];
    times = [managedContext executeFetchRequest:request error:&error];
    for (FetchTime *fetchTime in times) {
        NSLog(@"%@, %@", fetchTime.time, fetchTime.title);
    }
    return times;
}
@end
