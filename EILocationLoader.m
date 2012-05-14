//
//  LocationLoader.m
//  MyStuff
//
//  Created by 영록 박 on 10. 1. 16..
//  Copyright 2010 ecolemo. All rights reserved.
//

#import "EILocationLoader.h"


@implementation EILocationLoader

@synthesize lastLocation, lastPlacemark;

- (void)load:(EFLocationHandler)aHandler {
	handler = Block_copy(aHandler);
	locationManager = [[CLLocationManager alloc] init];
	locationManager.delegate = self;
	locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
	[locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    if (loaded) {
        [locationManager release];
        locationManager = nil;
        return;
    }
    
    loaded = YES;
    lastLocation = [newLocation retain];
    
    CLGeocoder* coder = [CLGeocoder new];
    
    [coder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error)
            handler(newLocation, @"");
        else {
            lastPlacemark = [placemarks objectAtIndex:0];
            handler(newLocation, [lastPlacemark.addressDictionary objectForKey:@"Street"]);
        }
        [coder release];
    }];
    [manager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"location error %@ %@", error, [error userInfo]);

    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Location Service needed" message:@"Please turn on Location Service in Settings to use this app." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alertView show];
    [alertView autorelease];
    [manager stopUpdatingLocation];
}

- (void)dealloc {
    [super dealloc];
}

@end
