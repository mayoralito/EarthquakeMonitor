//
//  EarthquakeProp.h
//  EarthquakeMonitor
//
//  Created by amayoral on 1/12/15.
//  Copyright (c) 2015 vRoutes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EarthquakeProp : NSObject

/** String to alert app if has a real-time catastrofe (i guess) */
@property (nonatomic, strong) NSString      *alert;
/** code of event. */
@property (nonatomic, strong) NSString      *code;
/** url for detail API */
@property (nonatomic, strong) NSString      *detail;
/** Magnitud of hearthquake */
@property (nonatomic, strong) NSString      *mag;
/** Place of earthquake happen */
@property (nonatomic, strong) NSString      *place;
/** unixtime when earthquake happen */
@property (nonatomic, strong) NSString      *time;
/** unixtime when earthquake happen stored in the server */
@property (nonatomic, strong) NSString      *updated;
/** Title of event */
@property (nonatomic, strong) NSString      *title;
/** Tsunami string to indicate... */
@property (nonatomic, strong) NSString      *tsunami;
/** Type of event... */
@property (nonatomic, strong) NSString      *type;


@end
