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

/*
 MISC
 */
// top section height
#define DETAIL_VIEW_MAX_HEIGHT  577
#define IPHONE4INCH_HEIGHT      568
#define STATUS_BAR_HEIGHT       20
#define NAVIGATION_BAR_HEIGHT   44
#define TOP_SECTION_HEIGHT      (STATUS_BAR_HEIGHT + NAVIGATION_BAR_HEIGHT)
#define TABBAR_SECTION_HEIGHT   49

#define GLOBAL_HEIGHT_NAV      (IS_OS_7_OR_LATER) ? TOP_SECTION_HEIGHT : NAVIGATION_BAR_HEIGHT

#endif
