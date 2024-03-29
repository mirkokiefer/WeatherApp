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

#define LCRadius 10

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
  locationManager.distanceFilter = 1000;
  locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
  [locationManager startUpdatingLocation];
  _locationManager = locationManager;
}

- (void)updateWeatherDataWithCoordinates:(CLLocationCoordinate2D)coords {
  NSLog(@"update");
  [LCCityStore citiesAtCoordinates:coords withRadius:LCRadius result:^(NSArray *array) {
    _cities = array;
    [self.tableView reloadData];
  }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return _cities.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  LCWeatherCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
  LCCity *city = [_cities objectAtIndex:indexPath.row];
  cell.cityLabel.text = city.name;
  cell.temperatureLabel.text = [NSString stringWithFormat: @"%@ °C", city.temperature];
  NSString *iconName = [NSString stringWithFormat:@"%@.PNG", city.conditionIcon];
  cell.conditionIcon.image = [UIImage imageNamed:iconName];
  return cell;
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
  CLLocation *location = locations.lastObject;
  [self updateWeatherDataWithCoordinates:location.coordinate];
}

@end
