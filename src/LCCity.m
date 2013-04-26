//
//  LCCity.m
//  WeatherApp
//
//  Created by Mirko on 4/25/13.
//  Copyright (c) 2013 LivelyCode. All rights reserved.
//

#import "LCCity.h"

@implementation LCCity

+ (id)cityWithName:(NSString *)name temperature:(NSString *)temperature condition:(NSString *)condition {
  LCCity *city = [[self alloc] init];
  city.name = name;
  city.temperature = temperature;
  city.condition = condition;
  return city;
}

@end
