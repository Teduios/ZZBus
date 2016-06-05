//
//  MainViewController.h
//  MyBus
//
//  Created by Tarena on 16/5/7.
//  Copyright © 2016年 Tarena. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum{
    HISTORYMANAGE,
    PLANMANAGER,
}ManageSwitch;
@interface ZZMainViewController : UIViewController
@property (nonatomic,assign)ManageSwitch switchMnager;
@end
