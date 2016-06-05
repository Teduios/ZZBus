//
//  DetailPlan.m
//  MyBus
//
//  Created by Tarena on 16/5/12.
//  Copyright © 2016年 Tarena. All rights reserved.
//

#import "ZZDetailPlan.h"

@implementation ZZDetailPlan
- (id)initWithDictionary:(NSDictionary *)dic
{
    if (self = [super init]) {
        self.busName = dic[@"busName"];
        self.startName = dic[@"startName"];
        self.endName = dic[@"endName"];
        self.footLength = dic[@"footLength"];
    }
    return self;
}
+ (id)detailWithDictionary:(NSDictionary *)dic
{
    return [[ZZDetailPlan alloc]initWithDictionary:dic];
}
@end
