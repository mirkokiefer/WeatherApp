//
//  LCCityStore.m
//  WeatherApp
//
//  Created by Mirko on 4/25/13.
//  Copyright (c) 2013 LivelyCode. All rights reserved.
//

#import "LCCityStore.h"
#import "LCCity.h"

#define LCWeatherAPI @"http://api.openweathermap.org/data/2.1/find/city?lat=%f&lon=%f&radius=%i&lang=en"
//#define LCUseTestData

@implementation LCCityStore

+ (NSArray *)testData {
  return @[
    [LCCity cityWithName:@"Heidelberg" temperature:@"12" conditionIcon:@"04d"],
    [LCCity cityWithName:@"Mannheim" temperature:@"13" conditionIcon:@"05d"],
    [LCCity cityWithName:@"Karlsruhe" temperature:@"11" conditionIcon:@"09d"]
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
    NSString *conditionIcon = obj[@"weather"][0][@"icon"];
    return [LCCity cityWithName:name temperature:temperature conditionIcon:conditionIcon];
  }];
}

+ (NSDictionary *)fetchCitiesFromAPIWithCoordinates:(CLLocationCoordinate2D)coords radius:(int)radius {
  NSString *urlString = [NSString stringWithFormat: LCWeatherAPI, coords.latitude, coords.longitude, radius];
  NSURL *url = [NSURL URLWithString: urlString];
  NSData *json = [NSData dataWithContentsOfURL:url];
  return [NSJSONSerialization JSONObjectWithData:json options:0 error:nil];
}

+ (void)citiesAtCoordinates:(CLLocationCoordinate2D)coords withRadius:(int)kmRadius result:(ArrayBlock)result {
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
    #ifdef LCUseTestData
    NSArray *cities = self.testData;
    #else
    NSDictionary *data = [self fetchCitiesFromAPIWithCoordinates:coords radius:kmRadius];
    NSArray *cities = [self parseCities:data[@"list"]];
    #endif
    
    dispatch_async(dispatch_get_main_queue(), ^{
      result(cities);
    });
  });
}

@end
