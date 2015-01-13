//
//  EartquakeLocation.m
//  EarthquakeMonitor
//
//  Created by amayoral on 1/13/15.
//  Copyright (c) 2015 vRoutes. All rights reserved.
//

#import "EarthquakeLocation.h"
#import <AddressBook/AddressBook.h>

@implementation EarthquakeLocation

- (id)initWithPlace:(NSString*)place mag:(NSString*)mag coordinate:(CLLocationCoordinate2D)coordinate {
    if ((self = [super init])) {
        place = [NSString stringWithFormat:@"%@", place];
        mag = [NSString stringWithFormat:@"%@", mag];
        
        if ([place isKindOfClass:[NSString class]]) {
            self.place = place;
        } else {
            self.place = @"Unknown place";
        }
        
        if ([mag isKindOfClass:[NSString class]]) {
            self.mag = mag;
        } else {
            self.mag = @"Unknown mag";
        }
        
        self.theCoordinate = coordinate;
    }
    return self;
}

- (NSString *)title {
    return _place;
}

- (NSString *)subtitle {
    return _mag;
}

- (CLLocationCoordinate2D)coordinate {
    return _theCoordinate;
}

- (MKMapItem*)mapItem {
    NSDictionary *magDict = @{(NSString *) kABPersonAddressStreetKey : _mag};
    
    MKPlacemark *placemark = [[MKPlacemark alloc]
                              initWithCoordinate:self.coordinate
                              addressDictionary:magDict];
    
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
    mapItem.name = self.title;
    
    return mapItem;
}


@end
