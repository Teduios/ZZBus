
//
//  ZZHistory.h
//  MyBus
//
//  Created by Tarena on 16/5/17.
//  Copyright © 2016年 Tarena. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum
{
    BUSNAMESEARCH,
    STATIONNAMESEARCH,
    PALANSEARCH,
}SearchFor;
@interface ZZHistory : NSObject<NSCoding>
@property (nonatomic,strong) NSString *name;
@property (nonatomic,assign) SearchFor searchforChoose;
+ (id)initWithName:(NSString *)name WithSearchFor:(SearchFor)searchFor;
@end
