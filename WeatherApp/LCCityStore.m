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

+ (float)kelvinToCelsius:(float)kelvinValue {
  return kelvinValue - 273.15;
}

+ (NSArray *)parseCities:(NSArray *)json {
  return [json map:^id(NSDictionary *obj) {
    NSString *name = obj[@"name"];
    NSNumber *temperatureKelvin = obj[@"main"][@"temp"];
    int temperatureCelsius = [self kelvinToCelsius:temperatureKelvin.floatValue];
    NSString *temperature = [NSString stringWithFormat:@"%i", temperatureCelsius];
    NSString *condition = obj[@"weather"][0][@"description"];
    return [LCCity cityWithName:name temperature:temperature condition:condition];
  }];
}

+ (void)citiesAtLocation:(CLLocation *)location withRadius:(double)kmRadius result:(ArrayBlock)result {
  float lat = location.coordinate.latitude;
  float lon = location.coordinate.longitude;
  
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    NSString *urlString = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.1/find/city?lat=%f&lon=%f&radius=100&lang=en", lat, lon];
    NSURL *url = [NSURL URLWithString: urlString];
    NSData *json = [NSData dataWithContentsOfURL:url];
    NSDictionary *data = [NSJSONSerialization JSONObjectWithData:json options:0 error:nil];
    
    NSArray *cities = [self parseCities:data[@"list"]];
    
    dispatch_async(dispatch_get_main_queue(), ^{
      result(cities);
    });
  });
}

@end
