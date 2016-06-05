//
//  ZZHistory.m
//  MyBus
//
//  Created by Tarena on 16/5/17.
//  Copyright © 2016年 Tarena. All rights reserved.
//

#import "ZZHistory.h"

@implementation ZZHistory
+ (id)initWithName:(NSString *)name WithSearchFor:(SearchFor)searchFor {
    ZZHistory *his = [[ZZHistory alloc]init];
    his.name = name;
    his.searchforChoose = searchFor;
    return his;
}
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.name = [aDecoder decodeObjectForKey:@"nameKey"];
        self.searchforChoose = [aDecoder decodeIntForKey:@"searchKey"];
    }
    return self;
    
}
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeInt:self.searchforChoose forKey:@"searchKey"];
    [aCoder encodeObject:self.name forKey:@"nameKey"];
}
@end
