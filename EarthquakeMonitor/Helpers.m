//
//  Helpers.m
//  EarthquakeMonitor
//
//  Created by amayoral on 1/14/15.
//  Copyright (c) 2015 vRoutes. All rights reserved.
//

#import "Helpers.h"

@implementation Helpers

//
// This helpers allows to iterate between service and put into NSObject.
//
- (EarthquakeEvent *)parseEarthquakeItems:(NSDictionary *)item {
    //NSLog(@"data: %@", [__data objectAtIndex:i]);
    
    EarthquakeEvent *p = [[EarthquakeEvent alloc] init];
    
    
    // GEOMETRY
    NSDictionary *geo = [item valueForKey:@"geometry"];
    NSArray *coordinates = [geo valueForKey:@"coordinates"];
    p.geo = [[EarthquakeGeometry alloc] init];
    
    p.geo.lon = [[coordinates objectAtIndex:0] doubleValue];
    p.geo.lat = [[coordinates objectAtIndex:1] doubleValue];
    p.geo.depth = [[coordinates objectAtIndex:2] doubleValue];
    
    // ID
    p._id = [[item valueForKey:@"id"] doubleValue];
    
    // Properties
    NSDictionary *properties = [item valueForKey:@"properties"];
    p.properties = [[EarthquakeProp alloc] init];
    
    p.properties.place = [properties valueForKey:@"place"];
    p.properties.mag = [properties valueForKey:@"mag"];
    p.properties.tsunami = [properties valueForKey:@"tsunami"];
    p.properties.alert = [properties valueForKey:@"alert"];
    p.properties.detail = [properties valueForKey:@"detail"];
    
    p.properties.code = [properties valueForKey:@"code"];
    p.properties.time = [properties valueForKey:@"time"];
    p.properties.type = [properties valueForKey:@"type"];
    p.properties.updated = [properties valueForKey:@"updated"];
    p.properties.title = [properties valueForKey:@"title"];
    
    
    // TYPE
    p.type = [item valueForKey:@"type"];
    
    return p;
}

@end
