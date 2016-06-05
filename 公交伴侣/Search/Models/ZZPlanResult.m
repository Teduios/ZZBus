//
//  PlanResult.m
//  MyBus
//
//  Created by Tarena on 16/5/12.
//  Copyright © 2016年 Tarena. All rights reserved.
//

#import "ZZPlanResult.h"

@implementation ZZPlanResult
- (id)init
{
    if (self = [super init]) {
        NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"dic"];
        NSMutableArray *mu1 = [NSMutableArray new];
        NSArray *array = dic[@"result"];
        for (NSDictionary *dic1 in array) {
            ZZPlans *plan = [ZZPlans plansWithDictionary:dic1];
            [mu1 addObject:plan];
        }
        self.result = [mu1 copy];
        
    }
    return self;
}
//+ (id)shardPlanResult
//{
//    static ZZPlanResult *planResult = nil;
//    if (planResult == nil) {
//        planResult = [[ZZPlanResult alloc]init];
//    }
//    return planResult;
//}
@end
