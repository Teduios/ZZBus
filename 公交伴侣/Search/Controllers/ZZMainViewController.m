//
//  MainViewController.m
//  MyBus
//
//  Created by Tarena on 16/5/7.
//  Copyright © 2016年 Tarena. All rights reserved.
//

#import "ZZMainViewController.h"
#import "ZZSearchLocationViewController.h"
#import "ZZSearchPlanViewController.h"
#import "ZZStationListViewController.h"
#import "ZZCurrentCity.h"
#import "ZZBusDataManager.h"
#import "ZZLocationSeachTableViewController.h"
#import "ZZBusListViewController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
@interface ZZMainViewController ()<UITableViewDelegate,UITableViewDataSource,ZZBusDelegate,SearchLocationDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>
@property (weak, nonatomic) IBOutlet UITableView *historyTableView;
@property (nonatomic,copy)NSMutableArray *allHistoryBus;
@property (weak, nonatomic) IBOutlet UILabel *startStation;
@property (weak, nonatomic) IBOutlet UILabel *endStation;
@property (weak, nonatomic) IBOutlet UIButton *cityName;
@property (nonatomic,strong) UIView *grayView;
@property (nonatomic,strong) NSMutableArray *tempArray;
@property (nonatomic,strong) NSDictionary *startDic;
@property (nonatomic,strong) NSDictionary *endDic;
@property (nonatomic,assign) SearchFor seachfor;
@property (nonatomic,strong) BMKLocationService *locationService;
@property (nonatomic,strong) BMKGeoCodeSearch* geocodesearch;
@property (nonatomic, strong) NSString *selectedStr;
@end

@implementation ZZMainViewController

//历史搜索写入沙盒路径懒加载
- (NSMutableArray *)tempArray
{
    if (!_tempArray) {
        _tempArray = [NSMutableArray array];
    }
    return _tempArray;
}
//跳转到根据名称查询公交站跟公交车的页面
- (IBAction)searchEnd:(UITapGestureRecognizer *)sender {
    ZZLocationSeachTableViewController *searchLocation = [self.storyboard instantiateViewControllerWithIdentifier:@"locationMark"];
    searchLocation.who = ENDSTATION;
    searchLocation.block = ^(NSDictionary *dic){
        self.endStation.text = [[dic allKeys]lastObject];
        self.endDic = dic;
    };
    [self.navigationController pushViewController:searchLocation animated:YES];


}
//跳转到根据名称查询公交站跟公交车的页面
- (IBAction)searchStatation:(UITapGestureRecognizer *)sender {
    ZZLocationSeachTableViewController *searchLocation = [self.storyboard instantiateViewControllerWithIdentifier:@"locationMark"];
    searchLocation.who = STARTSTAION;
    searchLocation.block = ^(NSDictionary *dic){
            self.startStation.text = [[dic allKeys]lastObject];
        self.startDic = dic;
         };
    [self.navigationController pushViewController:searchLocation animated:YES];
    
}
//历史搜索个数懒加载
- (NSMutableArray *)allHistoryBus
{
    
    if (!_allHistoryBus) {
        
        NSDictionary *dic = [ZZBusDataManager LoadAllHistoryWithCityName:self.cityName.titleLabel.text];
        _allHistoryBus = [NSMutableArray arrayWithArray:dic[self.cityName.titleLabel.text]];
    }
    return _allHistoryBus;
}
//当界面从其他界面回来时，界面出现时重修读取数据
- (void)viewWillAppear:(BOOL)animated
{
    self.grayView.hidden = YES;
   ZZCurrentCity *city = [ZZCurrentCity sharedCurrentName];
    [self.cityName setTitle:city.currentCityName forState:UIControlStateNormal];
    NSDictionary *dic = [ZZBusDataManager LoadAllHistoryWithCityName:city.currentCityName];
    NSArray *array = dic[city.currentCityName];
    self.allHistoryBus = [array copy];
    self.historyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.historyTableView reloadData];
}
//点击  起始位置 目的位置互换
- (IBAction)changeStation:(UITapGestureRecognizer *)sender {
    NSString *tem = [self.startStation.text copy];
    self.startStation.text = [self.endStation.text copy];
    self.endStation.text = [tem copy];
    NSDictionary *dic = [NSDictionary new];
    dic = [self.startDic copy];
    self.startDic = [self.endDic copy];
    self.endDic =[dic copy];
}
//tableview有多少个分区
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
//tableview每个分区有多少行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return self.allHistoryBus.count;
}
//返回每个cell的样式
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"historyCell"];
    ZZHistory *his = self.allHistoryBus[indexPath.row];
    cell.textLabel.text = his.name;
    self.historyTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    return cell;
    
}
//当点到击cell的时候做什么
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    ZZBusDataManager *zzbus = [ZZBusDataManager new];
    zzbus.delegate = self;
    self.switchMnager = HISTORYMANAGE;
    ZZHistory *his = self.allHistoryBus[indexPath.row];
    if (his.searchforChoose == BUSNAMESEARCH ) {
        self.seachfor = BUSNAMESEARCH;
         [zzbus loadPlanListWithCity:self.cityName.titleLabel.text StartMark:nil End:nil BusName:cell.textLabel.text StationName:nil];
    }
    else {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        self.selectedStr = cell.textLabel.text;
        self.seachfor = STATIONNAMESEARCH;
        [zzbus loadPlanListWithCity:self.cityName.titleLabel.text StartMark:nil End:nil BusName:nil StationName:cell.textLabel.text];
    }
   
}

//实现ZZBusDataManager代理方法（当下载成功时）
-(void)downLoadSuccess
{
    if (self.switchMnager == HISTORYMANAGE ) {
        if (self.seachfor == BUSNAMESEARCH) {
            ZZStationListViewController *station=[self.storyboard instantiateViewControllerWithIdentifier:@"stationList"];
            [self.navigationController pushViewController:station animated:YES];
        }
        else{
            ZZBusListViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"busList"];
            vc.cuttenStation = self.selectedStr;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
        
    }
    else {
         ZZSearchPlanViewController *searchPlan=[self.storyboard instantiateViewControllerWithIdentifier:@"searchPlan"];
        searchPlan.startLocation = self.startDic;
        searchPlan.endStation = self.endDic;
        [self.navigationController pushViewController:searchPlan animated:YES];
    }
   
    
}
//实现ZZBusDataManager代理方法（当下载失败时）
-(void)downLoadDefult
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"下载失败" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action];
    self.grayView.hidden = YES;
    [self.navigationController presentViewController:alert animated:YES completion:nil];
    
}
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
    static int i = 0;
    if (i > 0) {
        return;
    }
    i++;
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint = userLocation.location.coordinate;
    [self.geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
    CGPoint point = CGPointMake(userLocation.location.coordinate.longitude, userLocation.location.coordinate.latitude);
    NSValue *value = [NSValue valueWithCGPoint:point];
    self.startDic = @{userLocation.title:value};
    [self.locationService stopUserLocationService];
    
}
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
  
    if(![result.addressDetail.city isEqualToString:self.cityName.titleLabel.text]){
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"当前城市已变化,是否更新" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.cityName setTitle:result.addressDetail.city forState:UIControlStateNormal];
        self.startStation.text = result.address;
        ZZCurrentCity *city = [ZZCurrentCity sharedCurrentName];
        city.currentCityName = result.addressDetail.city;
        NSLog(@"%@",[NSThread currentThread]);

    }];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action];
    [alert addAction:action1];
    self.grayView.hidden = YES;
    [self.navigationController presentViewController:alert animated:YES completion:nil];
    }
}
- (void)didFailToLocateUserWithError:(NSError *)error {
    static int i = 0;
    if (i > 0) {
        return;
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"定位失败" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:action];
    [self.navigationController presentViewController:alert animated:YES completion:nil];
    i++;
    
    NSLog(@"定位错误");
}

//界面初始化数据
- (void)viewDidLoad {
    [super viewDidLoad];
    ZZCurrentCity *currentCity = [ZZCurrentCity sharedCurrentName];
    self.cityName.titleLabel.text = currentCity.currentCityName;
    self.historyTableView.delegate=self;
    self.historyTableView.dataSource=self;
    [self loadData];
}
//界面加载初始化数据
- (void)loadData {
    self.grayView = [[UIView alloc]initWithFrame:self.view.bounds];
    self.grayView.backgroundColor = [UIColor colorWithRed:245.0/255 green:245.0/255 blue:245.0/255 alpha:0.7];
    UIActivityIndicatorView *activ = [UIActivityIndicatorView new];
    [activ startAnimating];
    activ.frame = CGRectMake(0, 0, 40, 40);
    activ.color = [UIColor blackColor];
    activ.center = self.grayView.center;
    self.grayView.hidden = YES;
    [self.grayView addSubview:activ];
    [self.view addSubview:self.grayView];
    self.locationService = [[BMKLocationService alloc]init];
    self.locationService.delegate = self;
    [self.locationService startUserLocationService];
    self.geocodesearch = [BMKGeoCodeSearch new];
    self.geocodesearch.delegate = self;

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
//点击搜索跳转并且利用Block方式反向传值，并且把返回的数据写入字典保存到历史搜索文件路径中
- (IBAction)seach:(UITapGestureRecognizer *)sender {
    ZZSearchLocationViewController *search=[self.storyboard instantiateViewControllerWithIdentifier:@"searchLocation"];
    search.currentCity = self.cityName.titleLabel.text;
    search.searchSwitch = BUSNAME;
    search.delegate = self;
    self.navigationItem.title = nil;
    [self.navigationController pushViewController:search animated:YES];
}
//当查询界面成功是调用此方法增加历史数据
- (void)historyChangeWith:(NSString *)busNum WithChoose:(SearchFor)search{
    ZZHistory *his = [ZZHistory initWithName:busNum WithSearchFor:search];
    for (ZZHistory *history in self.allHistoryBus) {
        if ([history.name isEqualToString:his.name]) {
            return;
        }
    }
    if (self.allHistoryBus.count == 0) {
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:his];
        self.allHistoryBus = [array mutableCopy];
    }
    else {
        NSMutableArray *array = [NSMutableArray arrayWithArray:self.allHistoryBus];
        [array addObject:his];
        self.allHistoryBus = [array mutableCopy];
    }
   
    [ZZBusDataManager writeHistoryToFileWithDictionary:@{self.cityName.titleLabel.text:[self.allHistoryBus copy]}];
   }
//跳转到搜索公交站的界面
- (IBAction)searchStationBus:(UITapGestureRecognizer *)sender {
    ZZSearchLocationViewController *search=[self.storyboard instantiateViewControllerWithIdentifier:@"searchLocation"];
    search.currentCity = self.cityName.titleLabel.text;
    search.searchSwitch = STATIONNAME;
    search.delegate = self;
    [self.navigationController pushViewController:search animated:YES];

}
//开始搜索公交换乘方案


- (IBAction)searchPlan:(UITapGestureRecognizer *)sender {

    //获取方案数据并传值到plan；
    self.grayView.hidden = NO;
    NSValue *startValue = [[self.startDic allValues]lastObject];
    NSValue *endValue = [[self.endDic allValues]lastObject];
    CGPoint startPoint;
    CGPoint endPoint;
    [startValue getValue:&startPoint];
    [endValue getValue:&endPoint];
    NSString *startStr = [NSString stringWithFormat:@"%.7lf,%.7lf",startPoint.x,startPoint.y];
    NSString *endStr = [NSString stringWithFormat:@"%.7lf,%.7lf",endPoint.x,endPoint.y];
    ZZBusDataManager *manager = [ZZBusDataManager new];
    manager.delegate = self;
    self.switchMnager = PLANMANAGER;
    [manager loadPlanListWithCity:self.cityName.titleLabel.text StartMark:startStr End:endStr BusName:nil StationName:nil];
}
//点击清楚历史搜索数据
- (IBAction)clearHistory:(UITapGestureRecognizer *)sender {
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *delet=[UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [ZZBusDataManager clearHistory:self.cityName.titleLabel.text];
        self.allHistoryBus = [NSMutableArray new];
        [self.historyTableView reloadData];
           }];
    UIAlertAction *cancle=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:delet];
    [alert addAction:cancle];
    [self.navigationController presentViewController:alert animated:YES completion:nil];
    
}


@end
