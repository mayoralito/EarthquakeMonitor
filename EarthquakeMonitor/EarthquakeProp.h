//
//  EarthquakeProp.h
//  EarthquakeMonitor
//
//  Created by amayoral on 1/12/15.
//  Copyright (c) 2015 vRoutes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EarthquakeProp : NSObject

@property (nonatomic, strong) NSString      *alert;
@property (nonatomic, strong) NSString      *cdi;
@property (nonatomic, strong) NSString      *code;
@property (nonatomic, strong) NSString      *detail;
@property (nonatomic, strong) NSString      *dmin;
@property (nonatomic, strong) NSString      *felt;
@property (nonatomic, strong) NSString      *gap;
@property (nonatomic, strong) NSString      *ids;

/** Magnitud of hearthquake */
@property (nonatomic, strong) NSString      *mag;
@property (nonatomic, strong) NSString      *magType;
@property (nonatomic, strong) NSString      *mmi;
@property (nonatomic, strong) NSString      *net;
@property (nonatomic, strong) NSString      *nst;
@property (nonatomic, strong) NSString      *place;
@property (nonatomic, strong) NSString      *rms;
@property (nonatomic, strong) NSString      *sig;
@property (nonatomic, strong) NSString      *source;
@property (nonatomic, strong) NSString      *status;
@property (nonatomic, strong) NSString      *time;
@property (nonatomic, strong) NSString      *title;
@property (nonatomic, strong) NSString      *tsunami;
@property (nonatomic, strong) NSString      *type;
@property (nonatomic, strong) NSString      *types;
@property (nonatomic, strong) NSString      *tz;
@property (nonatomic, strong) NSString      *updated;
@property (nonatomic, strong) NSString      *url;

@end
