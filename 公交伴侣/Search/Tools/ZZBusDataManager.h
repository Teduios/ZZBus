//
//  ZZBusDataManager.h
//  MyBus
//
//  Created by Tarena on 16/5/13.
//  Copyright © 2016年 Tarena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZZResult.h"
#import "ZZPlanResult.h"
#import "ZZAllBusInStation.h"
#import "ZZCity.h"
#import "ZZHistory.h"
@protocol ZZBusDelegate<NSObject>
- (void)downLoadSuccess;
- (void)downLoadDefult;
@end
@interface ZZBusDataManager : NSObject
+ (NSArray *)getStationResult;
+ (NSArray *)getPlanResult;
@property (nonatomic,weak)id<ZZBusDelegate>delegate;
+ (NSArray *)loadAllBusInStation;
- (void)loadPlanListWithCity:(NSString *)cityName StartMark:(NSString *)startMark End:(NSString *)endMark BusName:(NSString*)busName StationName:(NSString *)stationName;
+ (NSArray *)loadAllCitys;
+ (NSDictionary *)LoadAllHistoryWithCityName:(NSString *)cityName;
+ (void)writeHistoryToFileWithDictionary:(NSDictionary *)dic;
+ (void)clearHistory:(NSString *)cityName;
@end
