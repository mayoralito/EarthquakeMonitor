//
//  MapViewController.m
//  EarthquakeMonitor
//
//  Created by amayoral on 1/14/15.
//  Copyright (c) 2015 vRoutes. All rights reserved.
//

#import "MapViewController.h"

#import "EarthquakeHandler.h"
#import "Helpers.h"
#import "EarthquakeEvent.h"

#import "ViewController.h"
#import "DetailUIViewController.h"
#import "MBProgressHUD.h"
#import "UIColor+Helpers.h"

#import "Constants.h"
#import "FullMapView.h"

#define METERS_PER_MILE 111609.344
#define KMS_MILES_DIFF  0.62137


@interface MapViewController ()
{
    Helpers*                __helpers;
    NSMutableArray*         __objData;
}
@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Map Summary";
    
    __helpers = [[Helpers alloc] init];
    
    // Init NSMutableArray
    __objData = [[NSMutableArray alloc] init];
    
    // UI - Add Right button
    [self addRightButton];
    
    // UI - Add Left button
    [self addLeftButton];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // Call json-service of Earthqare
    [self restfulServices];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - MKMapViewDelegate
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    // Create pin view for all annotations.
    static NSString *identifier = @"FullMapView";
    if ([annotation isKindOfClass:[FullMapView class]]) {
        
        //if annotation is the user location, return nil to get default blue-dot...
        if ([annotation isKindOfClass:[MKUserLocation class]])
            return nil;
        
        
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil)
        {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            annotationView.pinColor = MKPinAnnotationColorGreen;
            annotationView.canShowCallout = YES;
            annotationView.enabled = YES;
            
            annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeInfoDark];
        }
        else
        {
            // re-using view from annotations
            annotationView.annotation = annotation;
        }
        
        return annotationView;
    }
    
    return nil;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    //[self performSegueWithIdentifier:@"DetailsIphone" sender:view];
    NSLog(@"Go to some place");
    
}

#pragma mark - Helpers
- (void)addRightButton {
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]
                                    initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                    target:self
                                    action:@selector(restfulServices)];
    
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
    ViewController* vc = [storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)restfulServices {
    
    __objData = [[NSMutableArray alloc] init];
    
    //main thread
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        // Request to server server
        [EarthquakeHandler getFeedSummary:@"summary/all_hour.geojson" success:^(NSDictionary *data, NSHTTPURLResponse *urlResponse) {
            
            NSArray *__data = [data valueForKey:@"features"];
            for(int i = 0; i < [__data count]; i ++) {
                NSDictionary *item = [__data objectAtIndex:i];
                
                //
                // Parse our Dictionary into a NSObject and set objetct into array
                [__objData addObject:[__helpers parseEarthquakeItems:item]];
                
                EarthquakeEvent *p = [__objData objectAtIndex:i];
                
                UIColor *colored = [UIColor colorByRange:[p.properties.mag doubleValue]];
                [self displayPinIntoMapWithLat:p.geo.lat
                                           lon:p.geo.lon
                                         color:colored
                                         title:p.properties.place
                                      subtitle:[NSString stringWithFormat:@"%f", [p.properties.mag floatValue]]];
            }
            
            // Reload data on tableview!
            // REFRESH MAP VIEW
            
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

- (void)displayPinIntoMapWithLat:(double)lat lon:(double)lon color:(UIColor *)color title:(NSString *)title subtitle:(NSString *)subtitle {
    // Setup zoom of map
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = lat;
    zoomLocation.longitude= lon;
    
    
    // add zoom on region map
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 50.5*METERS_PER_MILE, 50.5*METERS_PER_MILE);
    
    [_mapView setRegion:viewRegion animated:YES];
    
    FullMapView *annotation = [[FullMapView alloc] initWithTitle:title
                                                        subtitle:[NSString stringWithFormat:@"%0.2f", [subtitle doubleValue]]
                                                      coordinate:zoomLocation];
    [_mapView addAnnotation:annotation];
}

@end
