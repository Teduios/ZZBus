//
//  ZZLocationSeachTableViewController.h
//  MyBus
//
//  Created by Tarena on 16/5/16.
//  Copyright © 2016年 Tarena. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum{
    STARTSTAION,
    ENDSTATION,
}ClickWho;
typedef void(^LOCATION_SEARCH)(NSDictionary *);
@interface ZZLocationSeachTableViewController : UITableViewController
@property (nonatomic,strong) LOCATION_SEARCH block;
@property (nonatomic,assign) ClickWho who;
@end
