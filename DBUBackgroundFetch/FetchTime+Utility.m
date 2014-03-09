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
    
    NSDateFormatter *_dateFormatter = [[NSDateFormatter alloc] init];
    [_dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [_dateFormatter setLocale:[NSLocale currentLocale]];
    NSDateFormatter *_intervalFormatter = [[NSDateFormatter alloc] init];
    [_intervalFormatter setDateFormat:@"HH:mm:ss"];
    [_intervalFormatter setLocale:[NSLocale currentLocale]];
    
    NSCalendar *_currentCalendar = [NSCalendar currentCalendar];
    [_currentCalendar setLocale:[NSLocale currentLocale]];
    NSCalendarUnit _calendarFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *intervalComponents;
    for (int i = 0; i < [times count]; i++) {
        FetchTime *fTime = [times objectAtIndex:i];
        
        NSString *timeString;
        if( i == 0 || [fTime.title hasPrefix:@"Background"]){
            timeString = fTime.title;
        }else{
            //Fetch Success인 경우, 이전 시간에서 얼마나 지난 후에, 패치가 이뤄졌는지 계산한다.
            FetchTime *prevTime = [times objectAtIndex:i-1];
            NSTimeInterval interval = [fTime.time timeIntervalSinceDate:prevTime.time];
            NSDate *d1 = [NSDate date];
            NSDate *d2 = [NSDate dateWithTimeInterval:interval sinceDate:d1];
            intervalComponents = [_currentCalendar components:_calendarFlags fromDate:d1 toDate:d2 options:0];
            NSDate *d3 = [_currentCalendar dateFromComponents:intervalComponents];
            timeString = [_intervalFormatter stringFromDate:d3];
        }
        // NSDateComponents *components = [_currentCalendar components:_calendarFlags fromDate:fTime.time];
        NSLog(@"%@ (%@)", [_dateFormatter stringFromDate:fTime.time], timeString);
        
    }
    return times;
}
@end
