//
//  SearchPlanViewController.m
//  MyBus
//
//  Created by Tarena on 16/5/9.
//  Copyright © 2016年 Tarena. All rights reserved.
//

#import "ZZSearchPlanViewController.h"
#import "ZZSearchPlanTableViewCell.h"
#import "ZZBusDataManager.h"
#import "ZZCurrentCity.h"
@interface ZZSearchPlanViewController ()<UITableViewDelegate,UITableViewDataSource,ZZBusDelegate>
@property (weak, nonatomic) IBOutlet UITableView *planTableView;
@property (nonatomic,copy)NSMutableArray *allPlans;
@property (weak, nonatomic) IBOutlet UILabel *planStartStation;
@property (weak, nonatomic) IBOutlet UILabel *planEndStation;
@property (nonatomic,strong) UIView *effectView;

@end

@implementation ZZSearchPlanViewController
//所有方案懒加载
-(NSMutableArray *)allPlans
{
    if (!_allPlans) {
        
        _allPlans = [[NSMutableArray alloc]init];
        NSArray *array = [ZZBusDataManager getPlanResult];
        for (ZZPlans *plan in array) {
            
                [_allPlans addObject:plan];
            
        }
        
    }
    return _allPlans;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.planTableView.delegate = self;
    self.planTableView.dataSource = self;
    self.planStartStation.text = [[self.startLocation allKeys]lastObject];
    self.planEndStation.text = [[self.endStation allKeys]lastObject];
    [self loadNewView];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(clickIterm)];
    self.navigationItem.leftBarButtonItem = item;
    self.navigationItem.title = @"公交方案列表";
}
- (void)clickIterm {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)loadNewView {
    self.effectView = [[UIView alloc]initWithFrame:self.view.bounds];
    self.effectView.backgroundColor = [UIColor colorWithRed:245.0/255 green:245.0/255 blue:245.0/255 alpha:0.7];
    [self.view addSubview:self.effectView];
    UIActivityIndicatorView *activ = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    activ.center = self.effectView.center;
    activ.backgroundColor = [UIColor blackColor];
    [self.effectView addSubview:activ];
    [activ startAnimating];
    self.effectView.hidden = YES;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 101;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return  self.allPlans.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZZSearchPlanTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"planCell" forIndexPath:indexPath];
    ZZPlans *plan=self.allPlans[indexPath.row];
    [cell creatPlan:plan planNum:indexPath.row+1];
    return cell;
    
}
//点击互换起始终点位置并重新加载
- (IBAction)changeStation:(UIButton *)sender {
    self.effectView.hidden = NO;
    NSDictionary *tempDic = [NSDictionary new];
    tempDic = [self.startLocation copy];
    self.startLocation = [self.endStation copy];
    self.endStation = [tempDic copy];
    NSString *temp = [self.planStartStation.text copy];
    self.planStartStation.text = [self.planEndStation.text copy];
    self.planEndStation.text = [temp copy];
    //重新搜索路线,并重新加载数据
    ZZCurrentCity *city = [ZZCurrentCity sharedCurrentName];
    NSValue *startValue = [[self.startLocation allValues]lastObject];
    NSValue *endValue = [[self.endStation allValues]lastObject];
    CGPoint startPoint;
    CGPoint endPoint;
    [startValue getValue:&startPoint];
    [endValue getValue:&endPoint];
    NSString *startStr = [NSString stringWithFormat:@"%.7lf,%.7lf",startPoint.x,startPoint.y];
    NSString *endStr = [NSString stringWithFormat:@"%.7lf,%.7lf",endPoint.x,endPoint.y];
    ZZBusDataManager *manager = [ZZBusDataManager new];
    manager.delegate = self;
    [manager loadPlanListWithCity:city.currentCityName StartMark:startStr End:endStr BusName:nil StationName:nil];
    
}
//下载方案列表成功时调用
- (void)downLoadSuccess {
    self.allPlans = [NSMutableArray new];
    NSArray *array = [ZZBusDataManager getPlanResult];
    NSMutableArray *newPlan = [NSMutableArray new];
    for (ZZPlans *plan in array) {
        
        [newPlan addObject:plan];
        
    }
    self.allPlans = [newPlan mutableCopy];
    [self.planTableView reloadData];
    self.effectView.hidden = YES;
}
//下载换乘方案失败
- (void)downLoadDefult {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"下载失败或网络错误" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        self.effectView.hidden = YES;
    }];
    [alert addAction:action];
    [self.navigationController presentViewController:alert animated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
