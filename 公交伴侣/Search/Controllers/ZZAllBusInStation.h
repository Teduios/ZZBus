//
//  AllBusInStation.h
//  MyBus
//
//  Created by Tarena on 16/5/16.
//  Copyright © 2016年 Tarena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZZAllBusInStation : NSObject
@property (nonatomic,strong) NSString *basic_price;
@property (nonatomic,strong) NSString *front_name;
@property (nonatomic,strong) NSString* terminal_name;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *start_time;
@property (nonatomic,strong) NSString *end_time;
- (id)initWithDictionary:(NSDictionary*)dic;
@end
