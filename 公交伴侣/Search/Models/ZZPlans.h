//
//  Plans.h
//  MyBus
//
//  Created by Tarena on 16/5/9.
//  Copyright © 2016年 Tarena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZZDetailPlan.h"

@interface ZZPlans : NSObject

@property (nonatomic,strong)NSArray *segmentList;
- (id)initWithDictionary:(NSDictionary *)dic;
+ (id)plansWithDictionary:(NSDictionary *)dic;
@end
