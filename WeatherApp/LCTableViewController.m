//
//  LCTableViewController.m
//  WeatherApp
//
//  Created by Mirko on 4/25/13.
//  Copyright (c) 2013 LivelyCode. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

#import "LCTableViewController.h"
#import "LCWeatherCell.h"
#import "LCCityStore.h"
#import "LCCity.h"

@interface LCTableViewController () {
  NSArray *_cities;
  CLLocationManager *_locationManager;
}
@end

@implementation LCTableViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self setupLocationManager];
}

- (void)setupLocationManager {
  CLLocationManager *locationManager = [[CLLocationManager alloc] init];
  locationManager.delegate = self;
  locationManager.distanceFilter = kCLDistanceFilterNone;
  locationManager.desiredAccuracy = kCLLocationAccuracyBest;
  [locationManager startUpdatingLocation];
  _locationManager = locationManager;
}

- (void)updateWeatherDataWithLocation:(CLLocation *)location {
  [LCCityStore citiesAtLocation:location withRadius:10 result:^(NSArray *array) {
    _cities = array;
    [self.tableView reloadData];
  }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  NSLog(@"count %i", _cities.count);
  return _cities.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  LCWeatherCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
  LCCity *city = [_cities objectAtIndex:indexPath.row];
  cell.cityLabel.text = city.name;
  cell.temperatureLabel.text = [NSString stringWithFormat: @"%@ °C", city.temperature];
  cell.conditionLabel.text = city.condition;
  return cell;
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
  CLLocation *location = locations.lastObject;
  [self updateWeatherDataWithLocation:location];
}

@end
