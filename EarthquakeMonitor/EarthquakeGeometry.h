//
//  Earthquake.h
//  EarthquakeMonitor
//
//  Created by amayoral on 1/12/15.
//  Copyright (c) 2015 vRoutes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EarthquakeGeometry : NSObject

@property (nonatomic, readwrite) double     lat;
@property (nonatomic, readwrite) double     lon;
@property (nonatomic, readwrite) double     depth;
@property (nonatomic, readwrite) NSString   *type;

@end
