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

#import "EarthquakeEvent.h"
#import "EarthquakeProp.h"
#import "EarthquakeGeometry.h"

#import "DetailUIViewController.h"
#import "MBProgressHUD.h"

#define REFRESH_BUTTON_ID       101

@interface ViewController ()
{
    EarthquakeHandler*      __manager;
    NSMutableArray*         __objData;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"Summary";
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.rowHeight = 70.0f;
    // Register NIB
    [_tableView registerNib:[UINib nibWithNibName:@"EarthquakeCell" bundle:[NSBundle mainBundle]]
     forCellReuseIdentifier:[EarthquakeCell reuseIdentifier]];
    
    // Init NSMutableArray
    __objData = [[NSMutableArray alloc] init];
    
    // Call json-service of Earthqare
    [self restfulServices];
    
    // UI - Add Right button
    [self addRightButton];
    
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
    
    UIColor *colored = [self colorByRange:[p.properties.mag doubleValue]];
    
    cell.backgroundColor = colored;
    
    // Custom UI
    cell.placeLabel.text = p.properties.place;
    cell.magLabel.text = [NSString stringWithFormat:@"%f", [p.properties.mag floatValue]];
    
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

//
// This helpers allows to iterate between service and put into NSObject.
//
- (EarthquakeEvent *)parseEarthquakeItems:(EarthquakeEvent *)p item:(NSDictionary *)item {
    //NSLog(@"data: %@", [__data objectAtIndex:i]);
    
    // GEOMETRY
    NSDictionary *geo = [item valueForKey:@"geometry"];
    NSArray *coordinates = [geo valueForKey:@"coordinates"];
    p.geo = [[EarthquakeGeometry alloc] init];
    
    p.geo.lon = [[coordinates objectAtIndex:0] doubleValue];
    p.geo.lat = [[coordinates objectAtIndex:1] doubleValue];
    p.geo.other = [[coordinates objectAtIndex:2] doubleValue];
    
    // ID
    p._id = [[item valueForKey:@"id"] doubleValue];
    
    // Properties
    NSDictionary *properties = [item valueForKey:@"properties"];
    p.properties = [[EarthquakeProp alloc] init];
    
    p.properties.mag = [properties valueForKey:@"mag"];
    
    p.properties.alert = [properties valueForKey:@"alert"];
    p.properties.cdi = [properties valueForKey:@"cdi"];
    p.properties.code = [properties valueForKey:@"code"];
    p.properties.detail = [properties valueForKey:@"detail"];
    //            p.properties.dmin = [properties valueForKey:@"dmin"];
    p.properties.felt = [properties valueForKey:@"felt"];
    p.properties.gap = [properties valueForKey:@"gap"];
    p.properties.ids = [properties valueForKey:@"ids"];
    p.properties.magType = [properties valueForKey:@"magType"];
    p.properties.mmi = [properties valueForKey:@"mmi"];
    p.properties.net = [properties valueForKey:@"net"];
    p.properties.nst = [properties valueForKey:@"nst"];
    p.properties.place = [properties valueForKey:@"place"];
    p.properties.rms = [properties valueForKey:@"rms"];
    p.properties.sig = [properties valueForKey:@"sig"];
    p.properties.source = [properties valueForKey:@"source"];
    p.properties.status = [properties valueForKey:@"status"];
    p.properties.time = [properties valueForKey:@"time"];
    p.properties.tsunami = [properties valueForKey:@"tsunami"];
    p.properties.type = [properties valueForKey:@"type"];
    p.properties.types = [properties valueForKey:@"types"];
    p.properties.tz = [properties valueForKey:@"tz"];
    p.properties.updated = [properties valueForKey:@"updated"];
    p.properties.url = [properties valueForKey:@"url"];
    
    // TYPE
    p.type = [item valueForKey:@"type"];
    
    return p;
}

- (UIColor *)colorByRange:(NSInteger )number{
    
    UIColor *colour = [UIColor colorWithRed:0.0f
                                      green:153.0f
                                       blue:0.0f alpha:1];
    
    if(number > 2) {
        colour = [UIColor colorWithRed:76.0f
                                 green:153.0f
                                  blue:0.0f alpha:1];
    }else if(number > 4) {
        colour = [UIColor colorWithRed:153.0f
                                 green:153.0f
                                  blue:0.0f alpha:1];
    }else if(number > 6) {
        colour = [UIColor colorWithRed:202.0f
                                 green:204.0f
                                  blue:0.0f alpha:1];
    }else if(number > 8) {
        colour = [UIColor colorWithRed:153.0f
                                 green:76.0f
                                  blue:0.0f alpha:1];
    }else if(number > 9) {
        colour = [UIColor colorWithRed:155.0f
                                 green:0.0f
                                  blue:0.0f alpha:1];
    }
    
        
    return colour;
}

- (void)addRightButton {
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]
                                    initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                    target:self
                                    action:@selector(restfulServices)];
    
    [doneButton setTag:REFRESH_BUTTON_ID];
    self.navigationItem.rightBarButtonItem = doneButton;
}

- (void)restfulServices {
    
    __objData = [[NSMutableArray alloc] init];
    
    //main thread
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
       
        // Request to server server
        [EarthquakeHandler getFeedSumary:@"summary/all_hour.geojson"
                                 success:^(NSDictionary *data, NSHTTPURLResponse *urlResponse) {
                                     
                                     NSLog(@"data: %@", [data valueForKey:@"metadata"]);
                                     
                                     NSArray *__data = [data valueForKey:@"features"];
                                     for(int i = 0; i < [__data count]; i ++) {
                                         NSDictionary *item = [__data objectAtIndex:i];
                                         EarthquakeEvent *p = [[EarthquakeEvent alloc] init];
                                         
                                         // Parse our Dictionary into a NSObject
                                         p = [self parseEarthquakeItems:p item:item];
                                         
                                         // Set objetct into array
                                         [__objData addObject:p];
                                         
                                     }
                                     
                                     // Reload data on tableview!
                                     [_tableView reloadData];
                                     
                                     //back to the main thread for the UI call
                                     dispatch_async(dispatch_get_main_queue(), ^{
                                         [MBProgressHUD hideHUDForView:self.view animated:YES];
                                     });
                                     
                                     
                                 } fail:^(NSDictionary *data, NSHTTPURLResponse *urlResponse) {
                                     NSLog(@"Fail: %@ \n at url response: %@", data, urlResponse);
                                     
                                     
                                     dispatch_async(dispatch_get_main_queue(), ^{
                                         [MBProgressHUD hideHUDForView:self.view animated:YES];
                                     });
                                     
                                 }];
        
        
    });
    
    
    
}

- (void)doSpinner {
    
}

@end
