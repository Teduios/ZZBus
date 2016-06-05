//
//  DetailPlan.h
//  MyBus
//
//  Created by Tarena on 16/5/12.
//  Copyright © 2016年 Tarena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZZDetailPlan : NSObject
@property (nonatomic,copy) NSString *footLength;
@property (nonatomic,copy) NSString *busName;
@property (nonatomic,copy) NSString *startName;
@property (nonatomic,copy) NSString *endName;
- (id)initWithDictionary:(NSDictionary *)dic;
+ (id)detailWithDictionary:(NSDictionary *)dic;
@end
