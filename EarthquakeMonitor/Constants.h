//
//  Constants.h
//  EarthquakeMonitor
//
//  Created by amayoral on 1/12/15.
//  Copyright (c) 2015 vRoutes. All rights reserved.
//

#ifndef EarthquakeMonitor_Constants_h
#define EarthquakeMonitor_Constants_h

#define API_URL         @"http://earthquake.usgs.gov/earthquakes/feed/"
#define API_VERSION     @"v1.0/"
#define BASE_API_URL    [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",API_URL, API_VERSION]]

#endif
