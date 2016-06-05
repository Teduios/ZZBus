//
//  AllBusInStation.m
//  MyBus
//
//  Created by Tarena on 16/5/16.
//  Copyright © 2016年 Tarena. All rights reserved.
//

#import "ZZAllBusInStation.h"

@implementation ZZAllBusInStation
- (id)initWithDictionary:(NSDictionary *)dic
{
    if (self = [super init]) {
        self.name = dic[@"name"];
        self.basic_price = dic[@"basic_price"];
        self.end_time = dic[@"end_time"];
        self.front_name = dic[@"front_name"];
        self.start_time = dic[@"start_time"];
        self.terminal_name = dic[@"terminal_name"];
    }
    return self;
}
@end
