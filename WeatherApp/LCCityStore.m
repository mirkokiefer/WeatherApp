//
//  LCCityStore.m
//  WeatherApp
//
//  Created by Mirko on 4/25/13.
//  Copyright (c) 2013 LivelyCode. All rights reserved.
//

#import "LCCityStore.h"
#import "LCCity.h"

@implementation LCCityStore

+ (NSArray *)testData {
  return @[
    [LCCity cityWithName:@"Heidelberg" temperature:@"12" condition:@"light rain"],
    [LCCity cityWithName:@"Mannheim" temperature:@"13" condition:@"rain"],
    [LCCity cityWithName:@"Karlsruhe" temperature:@"11" condition:@"cloudy"]
  ];
}

+ (void)citiesAtLocation:(CLLocation *)location withRadius:(double)kmRadius result:(ArrayBlock)result {
  result([self testData]);
}

@end
