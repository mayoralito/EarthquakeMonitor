//
//  DetailUIViewController.h
//  EarthquakeMonitor
//
//  Created by amayoral on 1/13/15.
//  Copyright (c) 2015 vRoutes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapKit/MapKit.h"

#import "EarthquakeEvent.h"
#import "EarthquakeProp.h"
#import "EarthquakeGeometry.h"

@interface DetailUIViewController : UIViewController <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) EarthquakeEvent *infoEartquake;
@end
