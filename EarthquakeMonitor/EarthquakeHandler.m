//
//  EartquakeHandler.m
//  EarthquakeMonitor
//
//  Created by amayoral on 1/12/15.
//  Copyright (c) 2015 vRoutes. All rights reserved.
//

#import "EarthquakeHandler.h"

@implementation EarthquakeHandler

static id shared;
+ (instancetype)sharedInstance {
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

- (id)init {
    self = [super init];
    if(self) {
        
    }
    
    return self;
}

+ (void)getFeedSummary:(NSString *)api_url success:(APIRequestSuccess)success fail:(APIRequestFail)fail {
    [[self sharedInstance] getRequest:api_url success:success fail:fail];
}

+ (void)getDetailSummary:(NSString *)api_url success:(APIRequestSuccess)success fail:(APIRequestFail)fail {
    [[self sharedInstance] getRequest:api_url success:success fail:fail];
}

+ (void)getNearbyCities:(NSString *)api_url success:(APIRequestSuccess)success fail:(APIRequestFail)fail {
    [[self sharedInstance] getRequest:api_url success:success fail:fail];
}

- (void)getRequest:(NSString *)api_url success:(APIRequestSuccess)success fail:(APIRequestFail)fail{
    
    [self get:api_url
       params:nil
      success:^(NSDictionary *data, NSHTTPURLResponse *urlResponse) {
          if(success){
              success(data, urlResponse);
          }
      } fail:^(NSDictionary *data, NSHTTPURLResponse *urlResponse) {
          if(fail){
              fail(nil, urlResponse);
          }
      }];
}

@end
