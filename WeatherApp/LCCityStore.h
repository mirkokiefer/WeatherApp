//
//  LCCityStore.h
//  WeatherApp
//
//  Created by Mirko on 4/25/13.
//  Copyright (c) 2013 LivelyCode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef void (^ArrayBlock)(NSArray *array);

@interface LCCityStore : NSObject

+ (void)citiesAtCoordinates:(CLLocationCoordinate2D)coords withRadius:(int)kmRadius result:(ArrayBlock)result;

@end
