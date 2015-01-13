//
//  APIHandler.m
//  EarthquakeMonitor
//
//  Created by amayoral on 1/12/15.
//  Copyright (c) 2015 vRoutes. All rights reserved.
//

#import "APIHandler.h"
#import "AFNetworking.h"
#import "Constants.h"

@interface APIHandler ()
{
    AFHTTPRequestOperationManager *manager;
}

@end

@implementation APIHandler 


- (id)init {
    self = [super init];
    if(self) {
        manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:BASE_API_URL];
        manager.securityPolicy.allowInvalidCertificates = YES;
    }
    return self;
}

- (void)get:(NSString *)restful params:(NSDictionary *)params success:(APIRequestSuccess)success fail:(APIRequestFail)fail {
    
    [manager GET:restful
      parameters:params
         success:^(AFHTTPRequestOperation *operation, NSDictionary* responseObject) {
             
             if(success) {
                 success(responseObject, operation.response);
             }
             
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *_error) {
             
             if(fail) {
                 fail(nil, operation.response);
             }
             
         }];
    
}

@end
