//
//  EartquakeLocation.h
//  EarthquakeMonitor
//
//  Created by amayoral on 1/13/15.
//  Copyright (c) 2015 vRoutes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface EarthquakeLocation : NSObject <MKAnnotation>

@property (nonatomic, copy) NSString *place;
@property (nonatomic, copy) NSString *mag;
@property (nonatomic, assign) CLLocationCoordinate2D theCoordinate;

- (id)initWithPlace:(NSString*)place mag:(NSString*)mag coordinate:(CLLocationCoordinate2D)coordinate;
- (MKMapItem*)mapItem;


@end
