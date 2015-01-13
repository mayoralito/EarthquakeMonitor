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

+ (instancetype)sharedInstance;
+ (void)getFeedSumary:(NSString *)api_url success:(APIRequestSuccess)success fail:(APIRequestFail)fail;

@end
