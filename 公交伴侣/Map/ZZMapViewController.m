//
//  ZZMapViewController.m
//  MyBus
//
//  Created by Tarena on 16/5/16.
//  Copyright © 2016年 Tarena. All rights reserved.
//

#import "ZZMapViewController.h"
#import <MapKit/MapKit.h>
#import "ZZCurrentCity.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
@interface ZZMapViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate,UISearchBarDelegate>
@property (nonatomic,strong) BMKMapView *mapView;
@property (nonatomic,strong) BMKLocationService *locationService;
@end

@implementation ZZMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadMapView];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(10, self.mapView.frame.size.height-40, 30, 40);
    [self.mapView addSubview:button];
    [button setBackgroundImage:[UIImage imageNamed:@"map_locate_blue"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(begainLocation) forControlEvents:UIControlEventTouchUpInside];
    self.mapView.userTrackingMode = MKUserTrackingModeFollow;
    self.navigationItem.title = @"地图";
}

- (void)loadMapView {
    self.mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-49)];
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
    self.locationService = [[BMKLocationService alloc]init];
    self.locationService.delegate = self;
    [self.locationService startUserLocationService];
}
- (void)begainLocation {
    [self.locationService startUserLocationService];
    self.mapView.userTrackingMode = BMKUserTrackingModeFollow;
    self.mapView.showsUserLocation = YES;
}
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
    BMKCoordinateSpan span;
    span.latitudeDelta = 0.01;
    span.longitudeDelta = 0.01;
    BMKCoordinateRegion region;
    region.span = span;
    region.center = userLocation.location.coordinate;
    [self.mapView setRegion:region animated:YES];
    [self.mapView updateLocationData:userLocation];
    [self.locationService stopUserLocationService];
}
- (void)didFailToLocateUserWithError:(NSError *)error {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"定位失败" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:action];
    [self.navigationController presentViewController:alert animated:YES completion:nil];

    NSLog(@"定位错误");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
