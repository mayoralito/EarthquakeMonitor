//
//  EartquakeHandler.h
//  EarthquakeMonitor
//
//  Created by amayoral on 1/12/15.
//  Copyright (c) 2015 vRoutes. All rights reserved.
//

#import "APIHandler.h"

typedef void (^APIRequestSuccess) (NSDictionary * data, NSHTTPURLResponse *urlResponse);
typedef void (^APIRequestFail) (NSDictionary * data, NSHTTPURLResponse *urlResponse);
typedef void (^APIRequestError) (NSDictionary * data, NSString *errorMesssage);

@interface EarthquakeHandler : APIHandler

/** Shared instance of this class. */
+ (instancetype)sharedInstance;

/** Get Feed Summary */
+ (void)getFeedSummary:(NSString *)api_url success:(APIRequestSuccess)success fail:(APIRequestFail)fail;

/** Get Detail Summary of Heartquake */
+ (void)getDetailSummary:(NSString *)api_url success:(APIRequestSuccess)success fail:(APIRequestFail)fail;

/** Get Nearby Cities of Hearquake */
+ (void)getNearbyCities:(NSString *)api_url success:(APIRequestSuccess)success fail:(APIRequestFail)fail;


@end
