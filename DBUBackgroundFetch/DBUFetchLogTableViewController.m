//
//  DBUFetchLogTableViewController.m
//  DBUBackgroundFetch
//
//  Created by David Bae on 2014. 3. 8..
//  Copyright (c) 2014년 David Bae. All rights reserved.
//

#import "DBUFetchLogTableViewController.h"
#import "FetchTime+Utility.h"

@interface DBUFetchLogTableViewController ()
{
    NSDateFormatter *_dateFormatter;
    NSDateFormatter *_intervalFormatter;
    NSCalendar *_currentCalendar;
    NSCalendarUnit _calendarFlags;
}
@property (nonatomic, strong) NSArray *fetchTimes;
@end

@implementation DBUFetchLogTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.fetchTimes = [FetchTime allFetchTime];
    
    
    
    if(_dateFormatter == nil)
    {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        [_dateFormatter setLocale:[NSLocale currentLocale]];
    }
    if(_intervalFormatter == nil)
    {
        _intervalFormatter = [[NSDateFormatter alloc] init];
        [_intervalFormatter setDateFormat:@"HH:mm:ss"];
        [_intervalFormatter setLocale:[NSLocale currentLocale]];
    }
    if (_currentCalendar == nil)
    {
        _currentCalendar = [NSCalendar currentCalendar];
        [_currentCalendar setLocale:[NSLocale currentLocale]];
        //[_currentCalendar setLocale:[NSLocale localeWithLocaleIdentifier:@"ko_KR"]];
        _calendarFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.fetchTimes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"fetchCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSString *timeString;
    // Configure the cell...
    FetchTime *fTime = [self.fetchTimes objectAtIndex:indexPath.row];
    if( indexPath.row == 0 || [fTime.title hasPrefix:@"Background"]){
        timeString = @"";
    }else{
        //Fetch Success인 경우, 이전 시간에서 얼마나 지난 후에, 패치가 이뤄졌는지 계산한다.
        FetchTime *prevTime = [self.fetchTimes objectAtIndex:indexPath.row-1];
        NSTimeInterval interval = [fTime.time timeIntervalSinceDate:prevTime.time];

        NSDate *d1 = [NSDate date];
        NSDate *d2 = [NSDate dateWithTimeInterval:interval sinceDate:d1];
        NSDateComponents *intervalComponents = [_currentCalendar components:_calendarFlags fromDate:d1 toDate:d2 options:0];
        NSDate *d3 = [_currentCalendar dateFromComponents:intervalComponents];
        timeString = [_intervalFormatter stringFromDate:d3];

    }
    //NSDateComponents *components = [_currentCalendar components:_calendarFlags fromDate:fTime.time];
    
    
    
    //cell.textLabel.text = [NSString stringWithFormat:@"%@", fTime.time ];
    cell.textLabel.text = [_dateFormatter stringFromDate:fTime.time];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@, %@", fTime.title, timeString];
    
    
    //이전과 비교해서, 지난 시간을 표시해 준다.)
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
