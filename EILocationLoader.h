//
//  LocationLoader.h
//  MyStuff
//
//  Created by 영록 박 on 10. 1. 16..
//  Copyright 2010 ecolemo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

typedef void (^EFLocationHandler)(CLLocation* location, NSString* placemark);

@interface EILocationLoader : NSObject <CLLocationManagerDelegate> {
    CLLocationManager* locationManager;
    EFLocationHandler handler;
    
    CLLocation* lastLocation;
    CLPlacemark* lastPlacemark;
    
    BOOL loaded;
}

@property (nonatomic, retain) CLLocation* lastLocation;
@property (nonatomic, retain) CLPlacemark* lastPlacemark;

- (void)load:(EFLocationHandler)aHandler;

@end
