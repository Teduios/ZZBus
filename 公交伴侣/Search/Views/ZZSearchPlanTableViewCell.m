//
//  SearchPlanTableViewCell.m
//  MyBus
//
//  Created by Tarena on 16/5/9.
//  Copyright © 2016年 Tarena. All rights reserved.
//

#import "ZZSearchPlanTableViewCell.h"
@interface ZZSearchPlanTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *planNumber;
@property (weak, nonatomic) IBOutlet UILabel *startStationLabel;
@property (weak, nonatomic) IBOutlet UILabel *interchangeStationLabel;

@end
@implementation ZZSearchPlanTableViewCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
//设置cell
-(void)creatPlan:(ZZPlans *)plan planNum:(NSInteger)planNum
{
    NSMutableString *busName = [NSMutableString new];
    NSMutableString *name = [NSMutableString new];
    for (ZZDetailPlan *detail in plan.segmentList) {
        [busName appendFormat:@"%@\n",detail.busName];
        [name appendString:[NSString stringWithFormat:@"从%@站上车到%@站下车走%@步到达\n",detail.startName,detail.endName,detail.footLength]];
    }
    self.startStationLabel.text = busName;
    self.interchangeStationLabel.text = name;
    self.planNumber.text=[NSString stringWithFormat:@"%ld",(long)planNum];
}

@end
