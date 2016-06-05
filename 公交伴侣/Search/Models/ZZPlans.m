//
//  Plans.m
//  MyBus
//
//  Created by Tarena on 16/5/9.
//  Copyright © 2016年 Tarena. All rights reserved.
//

#import "ZZPlans.h"

@implementation ZZPlans
- (id)initWithDictionary:(NSDictionary *)dic
{
    if (self = [super init]) {
        NSMutableArray *array = [NSMutableArray new];
        NSArray *array1 = dic[@"segmentList"];
        for (NSDictionary *dic1 in array1) {
            ZZDetailPlan *detailePlan = [ZZDetailPlan detailWithDictionary:dic1];
            [array addObject:detailePlan];
        }
        self.segmentList = array;
    }
    return self;
}
+ (id)plansWithDictionary:(NSDictionary *)dic
{
    return [[ZZPlans alloc]initWithDictionary:dic];
}
@end
