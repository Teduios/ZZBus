//
//  StationList.m
//  MyBus
//
//  Created by Tarena on 16/5/12.
//  Copyright © 2016年 Tarena. All rights reserved.
//

#import "ZZStationList.h"

@implementation ZZStationList
- (id)initWithDictionary:(NSDictionary *)dic
{
    if (self = [super init]) {
        self.name = dic[@"name"];
        self.stationNum = dic[@"stationNum"];
    }
    return self;
}
+(id)stationWithDIc:(NSDictionary *)dic
{
    return [[ZZStationList alloc]initWithDictionary:dic];
}
@end
