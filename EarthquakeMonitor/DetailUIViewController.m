//
//  DetailUIViewController.m
//  EarthquakeMonitor
//
//  Created by amayoral on 1/13/15.
//  Copyright (c) 2015 vRoutes. All rights reserved.
//

#import "DetailUIViewController.h"
#import "EarthquakeLocation.h"

#define METERS_PER_MILE 1609.344

@implementation DetailUIViewController

@synthesize infoEartquake;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Detail";
    
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
}

- (void)viewWillAppear:(BOOL)animated {
    // 1
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = infoEartquake.geo.lat;
    zoomLocation.longitude= infoEartquake.geo.lon;
    
    
    // 2
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
    
    // 3
    [_mapView setRegion:viewRegion animated:YES];
    
    EarthquakeLocation *annotation = [[EarthquakeLocation alloc] initWithPlace:infoEartquake.properties.place
                                                                           mag:infoEartquake.properties.mag
                                                                    coordinate:zoomLocation];
    [_mapView addAnnotation:annotation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    static NSString *identifier = @"EarthquakeLocation";
    if ([annotation isKindOfClass:[EarthquakeLocation class]]) {
        
        MKAnnotationView *annotationView = (MKAnnotationView *) [_mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            annotationView.enabled = YES;
            annotationView.canShowCallout = YES;
            //annotationView.image = [UIImage imageNamed:@"arrest.png"];//here we use a nice image instead of the default pins
        } else {
            annotationView.annotation = annotation;
        }
        
        return annotationView;
    }
    
    return nil;
}

@end
