//
//  CurrentCity.h
//  MyBus
//
//  Created by Tarena on 16/5/13.
//  Copyright © 2016年 Tarena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZZCurrentCity : NSObject
@property (nonatomic,strong) NSString* currentCityName;
+ (id)sharedCurrentName;
@end
