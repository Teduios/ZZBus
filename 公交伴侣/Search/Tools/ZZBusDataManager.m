//
//  ZZBusDataManager.m
//  MyBus
//
//  Created by Tarena on 16/5/13.
//  Copyright © 2016年 Tarena. All rights reserved.
//

#import "ZZBusDataManager.h"
@implementation ZZBusDataManager
+ (NSArray *)getStationResult {
    
    return  [[ZZBusDataManager alloc] getStationResult];
    
}
- (NSArray *)getStationResult {
    ZZResult *resultStation = [[ZZResult alloc]init];
    return resultStation.result;
}
+ (NSArray *)getPlanResult {
    ZZPlanResult *planResult = [[ZZPlanResult alloc]init];
    return planResult.result;
}
static NSArray *_cityArray = nil;
+ (NSArray *)loadAllCitys {
    NSString *citisePath = [[NSBundle mainBundle]pathForResource:@"cityGroups.plist" ofType:nil];
    NSArray *allCitys = [NSArray arrayWithContentsOfFile:citisePath];
    NSMutableArray *mutab = [NSMutableArray array];
    for (NSDictionary *dic in allCitys) {
        ZZCity *city = [ZZCity new];
        [city setValuesForKeysWithDictionary:dic];
        [mutab addObject:city];
    }
    return [mutab copy];
}
+ (NSArray *)loadAllBusInStation
{
    NSMutableArray *array = [NSMutableArray array];
    NSDictionary *result = [[NSUserDefaults standardUserDefaults] objectForKey:@"dic"];
    for (NSDictionary *dic in result[@"result"]) {
        ZZAllBusInStation *busName = [[ZZAllBusInStation alloc]initWithDictionary:dic];
        [array addObject:busName];
    }
    return [array copy];
    
}
- (NSString *)stringTurnUTF8StringWith:(NSString *)newStr {
    NSCharacterSet *set = [NSCharacterSet URLHostAllowedCharacterSet];
    NSString *utf8Str = [newStr stringByAddingPercentEncodingWithAllowedCharacters:set];
    return utf8Str;
}
- (void)loadPlanListWithCity:(NSString *)cityName StartMark:(NSString *)startMark End:(NSString *)endMark BusName:(NSString*)busName StationName:(NSString *)stationName {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *newCityName = [self stringTurnUTF8StringWith:cityName];
        NSString *newStationName = [self stringTurnUTF8StringWith:stationName];
        NSString *newBusName = [self stringTurnUTF8StringWith:busName];
        NSString *path = [NSString new];
        if (endMark == nil && startMark == nil && stationName == nil) {
            path =[NSString stringWithFormat:@"http://op.juhe.cn/189/bus/busline?key=abae98bccad3dc2cd71e9511e550c785&city=%@&%%20bus=%@",newCityName,newBusName];
        }
        if (endMark == nil && startMark == nil && busName == nil) {
             path = [NSString stringWithFormat:@"http://op.juhe.cn/189/bus/station?key=abae98bccad3dc2cd71e9511e550c785&city=%@&%%20station=%@",newCityName,newStationName];
        }
        if (stationName == nil && busName == nil ) {
             path = [NSString stringWithFormat:@"http://op.juhe.cn/189/bus/transfer.php?key=abae98bccad3dc2cd71e9511e550c785&city=%@&xys=%@;%@",newCityName,startMark,endMark];
        }
       
        NSURL *url = [NSURL URLWithString:path];
        NSData *data = [NSData dataWithContentsOfURL:url];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            if ([dic[@"reason"] isEqualToString:@"success"]) {
                [[NSUserDefaults standardUserDefaults] setObject:dic forKey:@"dic"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [self.delegate downLoadSuccess];
            }
            else{
                [self.delegate downLoadDefult];
                
            }
            
            
        });
        
    });
}
+ (NSDictionary *)LoadAllHistoryWithCityName:(NSString *)cityName {
    NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)lastObject];
    NSString *historyPath = [libraryPath stringByAppendingPathComponent:@"/Caches/history.txt"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:historyPath];
    NSMutableArray *array = dic[cityName];
    NSMutableArray *array1 = [NSMutableArray new];
    for (NSData *data in array) {
        NSKeyedUnarchiver *unarchier = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
        ZZHistory *his = [unarchier decodeObjectForKey:@"historyKey"];
        [unarchier finishDecoding];
        [array1 addObject:his];
    }
    NSDictionary *dic1 = @{cityName:array1};
    return dic1;

}
+ (void)writeHistoryToFileWithDictionary:(NSDictionary *)dic { 
    NSMutableArray *array = [NSMutableArray new];
    for (ZZHistory *his in [[dic allValues]lastObject])
    {
        NSMutableData *data = [[NSMutableData alloc]init];
        NSKeyedArchiver *archier = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
        [archier encodeObject:his forKey:@"historyKey"];
        [archier finishEncoding];
        [array addObject:data];
    }
    NSDictionary *newDic = @{[[dic allKeys]lastObject]:array};
    NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)lastObject];
    NSString *historyPath = [libraryPath stringByAppendingPathComponent:@"/Caches/history.txt"];
    NSDictionary *oldDic = [NSDictionary new];
    oldDic = [NSDictionary dictionaryWithContentsOfFile:historyPath];
    NSMutableDictionary *muDic = [NSMutableDictionary dictionaryWithDictionary:oldDic];
    [muDic removeObjectForKey:[[newDic allKeys] firstObject]];
    [muDic addEntriesFromDictionary:newDic];
    if(![muDic writeToFile:historyPath atomically:YES]){
        NSLog(@"写入失败");
    }
}
+ (void)clearHistory:(NSString *)cityName {
    NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)lastObject];
    NSString *historyPath = [libraryPath stringByAppendingPathComponent:@"/Caches/history.txt"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:historyPath];
    if (dic.count == 0) {
        return;
    }
    NSMutableDictionary *newDic = [NSMutableDictionary new];
    newDic = [dic mutableCopy];
    [newDic removeObjectForKey:cityName];
    [newDic writeToFile:historyPath atomically:YES];
    
}
@end
