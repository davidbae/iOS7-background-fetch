//
//  DBUViewController.m
//  DBUBackgroundFetch
//
//  Created by David Bae on 2014. 3. 7..
//  Copyright (c) 2014년 David Bae. All rights reserved.
//

#import "DBUViewController.h"
#import "DBUAppDelegate.h"

@interface DBUViewController ()

@property (strong, nonatomic) IBOutlet UISwitch *fetchSwitch;
@end

@implementation DBUViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    DBUAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    self.fetchSwitch.on = appDelegate.backgroundFetchOn;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)fetchSwitchChanged:(UISwitch *)sender
{
    DBUAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate setBackgroundFetchOn:sender.on];
}
@end
