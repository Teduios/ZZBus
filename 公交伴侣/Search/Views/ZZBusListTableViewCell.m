//
//  ZZBusListTableViewCell.m
//  MyBus
//
//  Created by Tarena on 16/5/16.
//  Copyright © 2016年 Tarena. All rights reserved.
//

#import "ZZBusListTableViewCell.h"
@interface ZZBusListTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *secondCell;

@end
@implementation ZZBusListTableViewCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
//公交站每班公交车的具体数据
- (void)setInformationWith:(ZZAllBusInStation *)busName{
    CGFloat price = busName.basic_price.floatValue;
    NSString *startTime1 = [busName.start_time substringWithRange:NSMakeRange(0, 2)];
    
    NSString *startTime2 = [busName.start_time substringWithRange:NSMakeRange(2, 2)];
    NSString *endTime1 = [busName.end_time substringWithRange:NSMakeRange(0, 2)];
    
    NSString *endTime2 = [busName.end_time substringWithRange:NSMakeRange(2, 2)];
    self.secondCell.text = [NSString stringWithFormat:@"  %@\n  起点站:%@->终点站:%@\n\n  起步价:%.1f  首班时间:%@:%@-末班时间:%@:%@",busName.name,busName.front_name,busName.terminal_name,price,startTime1,startTime2,endTime1,endTime2];
}

@end
