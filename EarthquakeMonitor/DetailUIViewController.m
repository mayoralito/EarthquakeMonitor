//
//  DetailUIViewController.m
//  EarthquakeMonitor
//
//  Created by amayoral on 1/13/15.
//  Copyright (c) 2015 vRoutes. All rights reserved.
//

#import "DetailUIViewController.h"

#import "Constants.h"
#import "EarthquakeHandler.h"
#import "EarthquakeLocation.h"
#import "MBProgressHUD.h"

#define METERS_PER_MILE 11609.344
#define KMS_MILES_DIFF  0.62137

@implementation DetailUIViewController
{
    NSMutableArray*         __objData;
}


@synthesize infoEartquake;
@synthesize titleLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Detail";
    self.titleLabel.text = infoEartquake.properties.title;
    
    [self requestDetailService];
    
    [self setupTitleView];
    
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
}

- (void)viewWillAppear:(BOOL)animated {
    // Setup zoom of map
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = infoEartquake.geo.lat;
    zoomLocation.longitude= infoEartquake.geo.lon;
    
    
    // add zoom on region map
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 50.5*METERS_PER_MILE, 50.5*METERS_PER_MILE);
    
    [_mapView setRegion:viewRegion animated:YES];
    
    EarthquakeLocation *annotation = [[EarthquakeLocation alloc] initWithPlace:infoEartquake.properties.place
                                                                           mag:infoEartquake.properties.mag
                                                                    coordinate:zoomLocation];
    [_mapView addAnnotation:annotation];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - MKMapViewDelegate
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    static NSString *identifier = @"EarthquakeLocation";
    if ([annotation isKindOfClass:[EarthquakeLocation class]]) {
        
        MKAnnotationView *annotationView = (MKAnnotationView *) [_mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            annotationView.enabled = YES;
            annotationView.canShowCallout = YES;
            //annotationView.image = [UIImage imageNamed:@"pin.png"]; // custom pin image...
        } else {
            annotationView.annotation = annotation;
        }
        
        return annotationView;
    }
    
    return nil;
}

#pragma mark - Life Cycle

- (void)requestDetailService {
    
    __objData = [[NSMutableArray alloc] init];
    
    NSString *target_string = [NSString stringWithFormat:@"%@%@", API_URL, API_VERSION];
    NSString* api_call = [self.infoEartquake.properties.detail stringByReplacingOccurrencesOfString:target_string
                                                                                         withString:@""];
    
    //main thread
    [self showSnipper];
    
    // Request to server server
    [EarthquakeHandler getDetailSummary:api_call success:^(NSDictionary *data, NSHTTPURLResponse *urlResponse) {
        
        // Information from response
        NSDictionary *__data = [[data valueForKey:@"properties"] valueForKey:@"products"];
        
        // Event Time
        NSArray *__origin = [__data valueForKey:@"origin"];
        [self setupEventTimeView:__origin];
        
        // Location
        [self setupLocationView];
        
        // Nearby Cities
        NSArray *__nearby_cities = [__data valueForKey:@"nearby-cities"];
        NSString *url = [[[[__nearby_cities objectAtIndex:0]
                           valueForKey:@"contents"]
                          valueForKey:@"nearby-cities.json"]
                         valueForKey:@"url"];
        
        [self requestNearbyCitiesWithURL:url];
        
    } fail:^(NSDictionary *data, NSHTTPURLResponse *urlResponse) {
        NSLog(@"Fail: %@ \n at url response: %@", data, urlResponse);
        
        [self hideSpinner];
        
    }];
    
}

- (void)requestNearbyCitiesWithURL:(NSString *)url_api {
    
    NSString *target_string = [NSString stringWithFormat:@"%@%@", API_URL, API_VERSION];
    NSString* api_call = [url_api stringByReplacingOccurrencesOfString:target_string
                                                                                         withString:@""];
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        [EarthquakeHandler getNearbyCities:api_call success:^(NSDictionary *data, NSHTTPURLResponse *urlResponse) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self hideSpinner];
                
                [self setupNearbyCitiesView:(NSArray *)data];
            });
            
            
        } fail:^(NSDictionary *data, NSHTTPURLResponse *urlResponse) {
            NSLog(@"getNearbyCities->fail: %@  \n\n %@", api_call, urlResponse);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self hideSpinner];
            });
            
        }];
    });
    
    
}

- (void)setupEventTimeView:(NSArray *)obj {
    
    // 2015-01-14 03:16:28 UTC
    self.eventLabel.text = @"";
    
    if([obj count] > 0) {
        
        NSDictionary *properties = [[obj objectAtIndex:0] valueForKey:@"properties"];
        NSString *str_date = [properties valueForKey:@"eventtime"];
        
        // 2015-01-14T04:02:56.120Z
        NSString *str_formatted = [str_date stringByReplacingOccurrencesOfString:@"T" withString:@" "];
        str_formatted = [str_formatted stringByReplacingOccurrencesOfString:@"." withString:@" +"];
        
        //
        // Get current TIME
        NSDate *today = [[NSDate alloc] init];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss zzz"];
        NSString *timeString = [dateFormatter stringFromDate:today];
        
        self.eventLabel.text = [NSString stringWithFormat:@"%@\n%@ at epicenter", timeString, str_formatted];
        self.eventLabel = [self fixMultiline:self.eventLabel];
        
    }
    
}

- (void)setupLocationView {
    
    NSString *res1 = [self dmsFromDecimalDegrees:[NSNumber numberWithDouble:infoEartquake.geo.lat] isLatitude:YES];
    NSString *res2 = [self dmsFromDecimalDegrees:[NSNumber numberWithDouble:infoEartquake.geo.lon] isLatitude:NO];
    NSString *degrees = [NSString stringWithFormat:@"%@%@\ndepth=%0.1fkm (%0.2fmi)",
                         res1,
                         res2,
                         infoEartquake.geo.depth,
                         [self kmsToMiles:infoEartquake.geo.depth]];
    
    self.locationLabel.text = degrees;
    self.locationLabel = [self fixMultiline:self.locationLabel];
}

- (void)setupNearbyCitiesView:(NSArray *)obj {
    
    NSMutableString *row_city = [[NSMutableString alloc] init];
    for(int i = 0; i < [obj count]; i ++) {
        [row_city appendFormat:@"%@\n", [self cityWithFormat: [obj objectAtIndex:i]]];
    }
    
    self.nearbyCitiesLabel.text = row_city;
    self.nearbyCitiesLabel = [self fixMultiline:self.nearbyCitiesLabel];
    
}

- (void)setupTitleView {
    
    NSDictionary *underlineAttribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
    self.titleLabel.attributedText = [[NSAttributedString alloc] initWithString:self.titleLabel.text
                                                                     attributes:underlineAttribute];
    
    
}

- (void)showSnipper {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)hideSpinner {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

// http://kb.tableausoftware.com/articles/knowledgebase/convert-latitude-longitude?lang=es
// http://www.geomidpoint.com/example.html
// http://transition.fcc.gov/mb/audio/bickel/DDDMMSS-decimal.html
// http://www.geomidpoint.com/calculation.html

/**
 All latitude and longitude data must be converted into radians. If the coordinates are in degrees.minutes.seconds format, they must first be converted into decimal format. Then convert each decimal latitude and longitude into radians by multiplying each one by PI/180 as in the table below.
 */

/**
 * Objective-C method to convert a decimal degree coordinate into degree, minutes, seconds
 * reference: https://gist.github.com/bradcochran/10937378
 */
- (NSString *)dmsFromDecimalDegrees:(NSNumber *)decimalDegrees isLatitude:(BOOL)isLatitude
{
    NSNumber *degrees = decimalDegrees;
    NSNumber *minutes = [NSNumber numberWithDouble:(degrees.doubleValue - degrees.intValue) * 60];
    NSNumber *seconds = [NSNumber numberWithDouble:(minutes.doubleValue - minutes.intValue) * 60];
    NSString *direction;
    
    if (isLatitude) {
        if (decimalDegrees.doubleValue < 0) { direction = @"S"; } else { direction = @"N"; }
        return [NSString stringWithFormat:@"%i° %i' %.2f\" %@", abs(degrees.intValue), abs(minutes.intValue), fabs(seconds.doubleValue), direction];
    } else {
        //NSLog(@"%f", decimalDegrees.doubleValue);
        if (decimalDegrees.doubleValue < 0) { direction = @"W"; } else { direction = @"E"; }
        //NSLog(@"%@", direction);
        return [NSString stringWithFormat:@"%i° %i' %.2f\" %@", abs(degrees.intValue), abs(minutes.intValue), fabs(seconds.doubleValue), direction];
    }
}

- (double)kmsToMiles:(double)kms {
    return kms * KMS_MILES_DIFF;
}

- (UILabel *)fixMultiline:(UILabel *)label {
    
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.numberOfLines = 0;
    CGRect currentFrame = label.frame;
    CGSize max = CGSizeMake(label.frame.size.width, 500);
    CGRect textRect = [label.text boundingRectWithSize:max
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                            attributes:@{NSFontAttributeName:label.font}
                                               context:nil];
    
    CGSize size = textRect.size;
    currentFrame.size.height = size.height;
    
    label.frame = currentFrame;
    
    return label;
}

- (NSString *)cityWithFormat:(NSDictionary *)data {
    
    double kms = [[data valueForKey:@"distance"] doubleValue];
    double mi = [self kmsToMiles:kms];
    NSString *direction = [data valueForKey:@"direction"];
    NSString *name = [data valueForKey:@"name"];
    
    return [NSString stringWithFormat:@"%0.0fkm (%0.0fmi) %@ of %@", kms, mi, direction, name];
    
}

@end
