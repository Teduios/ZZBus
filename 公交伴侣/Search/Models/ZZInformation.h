//
//  Information.h
//  MyBus
//
//  Created by Tarena on 16/5/12.
//  Copyright © 2016年 Tarena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZZStationList.h"

@interface ZZInformation : NSObject
@property (nonatomic,copy) NSArray *stationdes;
@property (nonatomic,copy) NSString *name;
- (id)initWithDictionary:(NSDictionary *)dic;
+ (id)informationWithDic:(NSDictionary *)dic;
@end
