//
//  EarthquakeCell.h
//  EarthquakeMonitor
//
//  Created by amayoral on 1/12/15.
//  Copyright (c) 2015 vRoutes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EarthquakeCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *placeLabel;
@property (strong, nonatomic) IBOutlet UILabel *magLabel;

+ (NSString *)reuseIdentifier;

@end
