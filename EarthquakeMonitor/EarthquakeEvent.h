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

@property (nonatomic, strong) EarthquakeProp        *properties;
@property (nonatomic, strong) EarthquakeGeometry    *geo;
@property (nonatomic, readwrite) NSInteger          _id;
@property (nonatomic, readwrite) NSString           *type;

@end
