//
//  EarthquakeEvent.h
//  EarthquakeMonitor
//
//  Created by amayoral on 1/13/15.
//  Copyright (c) 2015 vRoutes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EarthquakeGeometry.h"
#import "EarthquakeProp.h"

@interface EarthquakeEvent : NSObject

/** EarthquakeProp instance */
@property (nonatomic, strong) EarthquakeProp        *properties;
/** EarthquakeGeometry instance */
@property (nonatomic, strong) EarthquakeGeometry    *geo;
/** ID of FeatureCollection */
@property (nonatomic, readwrite) NSInteger          _id;
/** Type of FeatureCollection */
@property (nonatomic, readwrite) NSString           *type;

@end
