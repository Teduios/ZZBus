//
//  SearchPlanTableViewCell.h
//  MyBus
//
//  Created by Tarena on 16/5/9.
//  Copyright © 2016年 Tarena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZPlans.h"

@interface ZZSearchPlanTableViewCell : UITableViewCell
-(void)creatPlan:(ZZPlans *)plan planNum:(NSInteger)planNum;
@end
