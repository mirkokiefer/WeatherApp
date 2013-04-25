//
//  LCCity.h
//  WeatherApp
//
//  Created by Mirko on 4/25/13.
//  Copyright (c) 2013 LivelyCode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCCity : NSObject
@property (readwrite, strong) NSString *name;
@property (readwrite, strong) NSString *temperature;
@property (readwrite, strong) NSString *condition;
+ (id)cityWithName:(NSString *)name temperature:(NSString *)temperature condition:(NSString *)condition;
@end
