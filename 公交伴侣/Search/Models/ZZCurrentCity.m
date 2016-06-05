//
//  CurrentCity.m
//  MyBus
//
//  Created by Tarena on 16/5/13.
//  Copyright © 2016年 Tarena. All rights reserved.
//

#import "ZZCurrentCity.h"
#import <CoreLocation/CoreLocation.h>
@implementation ZZCurrentCity
+ (id)sharedCurrentName{
    static ZZCurrentCity *city = nil;
    if (!city) {
        city = [ZZCurrentCity new];
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)lastObject];
        NSString *newPath = [path stringByAppendingPathComponent:@"Caches/currentCity.txt"];
        city.currentCityName = [[NSString stringWithContentsOfFile:newPath encoding:NSUTF8StringEncoding error:nil] copy];
        if (!city.currentCityName) {
            city.currentCityName = @"重庆市";
        }
        }
    return city;
}
@end
