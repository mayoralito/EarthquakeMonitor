//
//  ViewController.m
//  EarthquakeMonitor
//
//  Created by amayoral on 1/12/15.
//  Copyright (c) 2015 vRoutes. All rights reserved.
//

#import "ViewController.h"
#import "EarthquakeCell.h"
#import "EarthquakeHandler.h"

#import "Helpers.h"
#import "EarthquakeEvent.h"

#import "MapViewController.h"
#import "DetailUIViewController.h"
#import "MBProgressHUD.h"
#import "UIColor+Helpers.h"
#import "SVPullToRefresh.h"
#import "Constants.h"

@interface ViewController ()
{
    Helpers*                __helpers;
}

@end

@implementation ViewController

@synthesize __objData;
@synthesize tableView = _tableView;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"Summary";
    
    __helpers = [[Helpers alloc] init];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.rowHeight = 70.0f;
    
    // Register NIB
    [_tableView registerNib:[UINib nibWithNibName:@"EarthquakeCell" bundle:[NSBundle mainBundle]]
     forCellReuseIdentifier:[EarthquakeCell reuseIdentifier]];
    
    // Init NSMutableArray
    __objData = [[NSMutableArray alloc] init];
    
    // Call json-service of Earthquake
    [self restfulServices:^{
        
    }];
    
    // UI - Add Right button
    [self addRightButton];
    
    // UI - Add Left button
    [self addLeftButton];
    
    
    // weak reference of our current ViewController to use with Pull to Refresh
    __weak ViewController *weakSelf = self;
    
    // setup pull-to-refresh
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf insertRowAtTop];
    }];
    
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -  Helpers to Pull Refresh
- (void)insertRowAtTop {
    __weak ViewController *weakSelf = self;
    
    int64_t delayInSeconds = 0.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        //[weakSelf.tableView beginUpdates];
        // Insert handle thing...
        //[weakSelf.__objData insertObject:[NSDate date] atIndex:0];
        //[weakSelf.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationBottom];
        //[weakSelf.tableView endUpdates];
        
        [weakSelf restfulServices:^{
            
            [weakSelf.tableView.pullToRefreshView stopAnimating];
            
            CGRect frame = weakSelf.tableView.frame;
            frame.origin.y = GLOBAL_HEIGHT_NAV;
            [weakSelf.tableView setFrame:frame];
            
        }];
    });
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [__objData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // EarthquakeEvent instance
    EarthquakeEvent *p = [__objData objectAtIndex:indexPath.row];
    
    // The trick, to use reusable!
    EarthquakeCell *cell = [tableView dequeueReusableCellWithIdentifier:[EarthquakeCell reuseIdentifier]];
    
    // Configuration
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    UIColor *colored = [UIColor colorByRange:[p.properties.mag doubleValue]];
    
    cell.backgroundColor = colored;
    
    // Custom UI
    cell.placeLabel.text = p.properties.place;
    cell.magLabel.text = [NSString stringWithFormat:@"%0.2f", [p.properties.mag floatValue]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 
    // EarthquakeEvent instance
    EarthquakeEvent *p = [__objData objectAtIndex:indexPath.row];
    
    // Deselect item
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    //the storyboard
    UIStoryboard *storyboard = self.navigationController.storyboard;
    
    // Open view controller
    DetailUIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"DetailUIViewController"];
    
    //set the info
    [vc setInfoEartquake:p];
    
    //Push to detail View
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - UITableViewDelegate


#pragma mark - Helpers
- (void)addRightButton {
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]
                                    initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                    target:self
                                    action:@selector(callFromButtonRefresh)];
    
    self.navigationItem.rightBarButtonItem = doneButton;
}

- (void)addLeftButton {
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]
                                    initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                    target:self
                                    action:@selector(switchView)];
    
    self.navigationItem.leftBarButtonItem = doneButton;
}

- (void)switchView {
    UIStoryboard *storyboard = self.navigationController.storyboard;
    MapViewController* vc = [storyboard instantiateViewControllerWithIdentifier:@"MapViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)callFromButtonRefresh {
    // Call json-service of Earthquake
    [self restfulServices:^{
        
    }];
}

- (void)restfulServices:(void (^)(void))customAction {
    //void (^APIRequestSuccess) (NSDictionary * data, NSHTTPURLResponse *urlResponse)
    
    __objData = [[NSMutableArray alloc] init];
    
    //main thread
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
       
        // Request to server server
        [EarthquakeHandler getFeedSummary:@"summary/all_hour.geojson" success:^(NSDictionary *data, NSHTTPURLResponse *urlResponse) {
            
            NSArray *__data = [data valueForKey:@"features"];
            for(int i = 0; i < [__data count]; i ++) {
                NSDictionary *item = [__data objectAtIndex:i];
                
                //
                // Parse our Dictionary into a NSObject and set objetct into array
                [__objData addObject:[__helpers parseEarthquakeItems:item]];
                
            }
            
            // Reload data on tableview!
            [_tableView reloadData];
            
            //back to the main thread for the UI call
            //dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                if(customAction){
                    customAction();
                }
            //});
            
            
        } fail:^(NSDictionary *data, NSHTTPURLResponse *urlResponse) {
            NSLog(@"Fail: %@ \n at url response: %@", data, urlResponse);
            
            
            //dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            //});
            
        }];
        
        
    //});
    
}

@end
