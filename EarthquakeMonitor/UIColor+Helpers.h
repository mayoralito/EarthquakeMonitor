//
//  UIColor+Helpers.h
//  EarthquakeMonitor
//
//  Created by amayoral on 1/14/15.
//  Copyright (c) 2015 vRoutes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Helpers)

/** Return color depends of his range...*/
+ (UIColor *)colorByRange:(NSInteger )number;

@end
