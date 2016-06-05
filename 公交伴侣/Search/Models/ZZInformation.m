//
//  Information.m
//  MyBus
//
//  Created by Tarena on 16/5/12.
//  Copyright © 2016年 Tarena. All rights reserved.
//

#import "ZZInformation.h"

@implementation ZZInformation
-(id)initWithDictionary:(NSDictionary *)dic
{
    if (self = [super init]) {
        NSArray *array = dic[@"stationdes"];
       
        NSMutableArray *mu = [NSMutableArray new];
        for (NSDictionary *dic1 in array) {
            ZZStationList *station = [ZZStationList stationWithDIc:dic1];
            [mu addObject:station];
        }
        self.stationdes = [mu copy];
        self.name = dic[@"name"];
    }
    return self;
}
+(id)informationWithDic:(NSDictionary *)dic
{
    return [[ZZInformation alloc]initWithDictionary:dic];
}
@end
