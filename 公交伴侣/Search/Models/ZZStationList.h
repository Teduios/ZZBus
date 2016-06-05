//
//  StationList.h
//  MyBus
//
//  Created by Tarena on 16/5/12.
//  Copyright © 2016年 Tarena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZZStationList : NSObject
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *stationNum;
- (id)initWithDictionary:(NSDictionary *)dic ;
+ (id)stationWithDIc:(NSDictionary *)dic;
@end
