//
//  StationListViewController.m
//  MyBus
//
//  Created by Tarena on 16/5/9.
//  Copyright © 2016年 Tarena. All rights reserved.
//

#import "ZZStationListViewController.h"
#import "ZZBusDataManager.h"
@interface ZZStationListViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *endStation;
@property (weak, nonatomic) IBOutlet UITableView *stationTableView;
@property (weak, nonatomic) IBOutlet UILabel *startStation;
@property (nonatomic,copy)NSMutableArray *allStations;
@property (nonatomic,copy)NSMutableArray *otherStations;
@end

@implementation ZZStationListViewController
//初始化所有的公交站
-(NSMutableArray *)allStations{
    if (!_allStations) {
        _allStations = [NSMutableArray new];
        NSArray *result = [ZZBusDataManager getStationResult];
        ZZInformation *info1 = result[0];
        for(ZZStationList *station in info1.stationdes){
                [_allStations addObject:station.name];
            }
    }
    return _allStations;
}
//给反方向的公交站数组懒加载
- (NSMutableArray *)otherStations
{
    if (!_otherStations) {
        _otherStations = [NSMutableArray new];
        NSArray *result = [ZZBusDataManager getStationResult];
        ZZInformation *info1 = result[1];
        for(ZZStationList *station in info1.stationdes){
            [_otherStations addObject:station.name];
        }
    }
    return _otherStations;
}
//- (void)setData {
//    self.allStations = [NSMutableArray new];
//    ZZResult *re = [[ZZResult alloc]init];
//    ZZInformation *info1 = re.result[0];
//    for(ZZStationList *station in info1.stationdes){
//        [self.allStations addObject:station.name];
//    }
//    self.otherStations = [NSMutableArray new];
//    ZZInformation *info2 = re.result[1];
//    for(ZZStationList *station in info2.stationdes){
//        [self.otherStations addObject:station.name];
//    }
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.stationTableView.dataSource=self;
    self.stationTableView.delegate=self;
    self.startStation.text = [NSString stringWithFormat:@"  起点:%@",self.allStations[0]];
    self.endStation.text = [NSString stringWithFormat:@"  终点:%@",[self.allStations lastObject]];
    self.navigationItem.title = @"公交站列表";
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(clickIterm)];
    self.navigationItem.leftBarButtonItem = item;
}
- (void)clickIterm {
    [self.navigationController popViewControllerAnimated:YES];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.allStations.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"stationCell" forIndexPath:indexPath];
    cell.textLabel.text=[NSString stringWithFormat:@"%ld.%@",indexPath.row+1,self.allStations[indexPath.row]];
    return cell;
}
- (IBAction)changeD:(UIButton *)sender {
    NSMutableArray *tem = [self.allStations mutableCopy];
    self.allStations = [self.otherStations mutableCopy];
    self.otherStations = [tem mutableCopy];
    self.startStation.text = [NSString stringWithFormat:@"  起点:%@",self.allStations[0]];
    self.endStation.text = [NSString stringWithFormat:@"  终点:%@",[self.allStations lastObject]];
    [self.stationTableView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
