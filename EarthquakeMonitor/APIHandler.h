//
//  APIHandler.h
//  EarthquakeMonitor
//
//  Created by amayoral on 1/12/15.
//  Copyright (c) 2015 vRoutes. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^APIRequestSuccess) (NSDictionary * data, NSHTTPURLResponse *urlResponse);
typedef void (^APIRequestFail) (NSDictionary * data, NSHTTPURLResponse *urlResponse);
typedef void (^APIRequestError) (NSDictionary * data, NSString *errorMesssage);

@interface APIHandler : NSObject

- (void)get:(NSString *)restful params:(NSDictionary *)params success:(APIRequestSuccess)success fail:(APIRequestFail)fail;

@end
