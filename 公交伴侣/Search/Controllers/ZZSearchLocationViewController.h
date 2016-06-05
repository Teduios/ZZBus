//
//  SearchLocationViewController.h
//  MyBus
//
//  Created by Tarena on 16/5/7.
//  Copyright © 2016年 Tarena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZHistory.h"
typedef enum{
    BUSNAME,
    STATIONNAME,
}SEARCHSWITCH;
@protocol SearchLocationDelegate<NSObject>
- (void)historyChangeWith:(NSString *)busNum WithChoose:(SearchFor)search;
@end
@interface ZZSearchLocationViewController : UIViewController
//当前选择的城市
@property (nonatomic, strong) NSString *currentCity;
@property (nonatomic, weak) id<SearchLocationDelegate>delegate;
@property (nonatomic,assign)SEARCHSWITCH searchSwitch;
@end
