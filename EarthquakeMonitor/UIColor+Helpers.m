//
//  UIColor+Helpers.m
//  EarthquakeMonitor
//
//  Created by amayoral on 1/14/15.
//  Copyright (c) 2015 vRoutes. All rights reserved.
//

#import "UIColor+Helpers.h"

@implementation UIColor (Helpers)

+ (UIColor *)colorByRange:(NSInteger )number{
    
    UIColor *colour = [UIColor colorWithRed:0.0f
                                      green:153.0f
                                       blue:0.0f alpha:1];
    
    if(number > 2) {
        colour = [UIColor colorWithRed:76.0f
                                 green:153.0f
                                  blue:0.0f alpha:1];
    }else if(number > 4) {
        colour = [UIColor colorWithRed:153.0f
                                 green:153.0f
                                  blue:0.0f alpha:1];
    }else if(number > 6) {
        colour = [UIColor colorWithRed:202.0f
                                 green:204.0f
                                  blue:0.0f alpha:1];
    }else if(number > 8) {
        colour = [UIColor colorWithRed:153.0f
                                 green:76.0f
                                  blue:0.0f alpha:1];
    }else if(number > 9) {
        colour = [UIColor colorWithRed:155.0f
                                 green:0.0f
                                  blue:0.0f alpha:1];
    }
    
    
    return colour;
}

@end
