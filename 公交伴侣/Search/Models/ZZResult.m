//
//  Result.m
//  MyBus
//
//  Created by Tarena on 16/5/12.
//  Copyright © 2016年 Tarena. All rights reserved.
//

#import "ZZResult.h"

@implementation ZZResult

- (id)init
{
    if (self = [super init]) {
        NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"dic"];
        NSArray *array = dic[@"result"];
        NSMutableArray *mut = [NSMutableArray new];
        for (NSDictionary *dic in array) {
            ZZInformation *info = [ZZInformation informationWithDic:dic];
            [mut addObject:info];
        }
        self.result = [mut copy];
    }
    return self;
}
//+ (id)sharedResult
//{
//    static ZZResult *result = nil;
//    if (result == nil) {
//        result = [[ZZResult alloc]init];
//    }
//    return result;
//}
@end
