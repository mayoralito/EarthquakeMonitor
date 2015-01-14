//
//  Helpers.h
//  EarthquakeMonitor
//
//  Created by amayoral on 1/14/15.
//  Copyright (c) 2015 vRoutes. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "EarthquakeEvent.h"
#import "EarthquakeProp.h"
#import "EarthquakeGeometry.h"


@interface Helpers : NSObject

- (EarthquakeEvent *)parseEarthquakeItems:(NSDictionary *)item;

@end
