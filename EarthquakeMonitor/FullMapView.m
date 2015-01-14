//
//  FullMapView.m
//  EarthquakeMonitor
//
//  Created by amayoral on 1/14/15.
//  Copyright (c) 2015 vRoutes. All rights reserved.
//

#import "FullMapView.h"
#import <AddressBook/AddressBook.h>

@implementation FullMapView

- (id)initWithTitle:(NSString*)title subtitle:(NSString*)subtitle coordinate:(CLLocationCoordinate2D)coordinate {
    if ((self = [super init])) {
        title = [NSString stringWithFormat:@"%@", title];
        subtitle = [NSString stringWithFormat:@"%@", subtitle];
        
        if ([title isKindOfClass:[NSString class]]) {
            self.title = title;
        } else {
            self.title = @"Unknown title";
        }
        
        if ([subtitle isKindOfClass:[NSString class]]) {
            self.subtitle = subtitle;
        } else {
            self.subtitle = @"Unknown subtitle";
        }
        
        self.theCoordinate = coordinate;
    }
    return self;
}

- (NSString *)title {
    return _title;
}

- (NSString *)subtitle {
    return _subtitle;
}

- (CLLocationCoordinate2D)coordinate {
    return _theCoordinate;
}

- (MKMapItem*)mapItem {
    // Import AddressBook.h
    NSDictionary *subDict = @{(NSString *) kABPersonAddressStreetKey : _subtitle};
    
    MKPlacemark *placemark = [[MKPlacemark alloc]
                              initWithCoordinate:self.coordinate
                              addressDictionary:subDict];
    
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
    mapItem.name = self.title;
    
    return mapItem;
}

@end
