//
//  ZZLocationSeachTableViewController.m
//  MyBus
//
//  Created by Tarena on 16/5/16.
//  Copyright © 2016年 Tarena. All rights reserved.
//

#import "ZZLocationSeachTableViewController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import "ZZCurrentCity.h"
@interface ZZLocationSeachTableViewController ()<UISearchBarDelegate,BMKMapViewDelegate, BMKPoiSearchDelegate>
@property (nonatomic,strong) UISearchBar *searchBar;
@property (nonatomic,strong) NSMutableArray *allLocation;
@property (nonatomic,strong) BMKPoiSearch *poisearch;
@end

@implementation ZZLocationSeachTableViewController
- (NSMutableArray *)allLocation
{
    if (!_allLocation) {
        _allLocation = [NSMutableArray array];
    }
    return _allLocation;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchBar = [UISearchBar new];
    self.searchBar.delegate = self;
    [self.searchBar sizeToFit];
    self.tableView.tableHeaderView = self.searchBar;
    self.searchBar.placeholder = @"搜索地点";
    self.poisearch = [BMKPoiSearch new];
    self.poisearch.delegate = self;
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(clickIterm)];
    self.navigationItem.leftBarButtonItem = item;
}
- (void)clickIterm {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPoiResult *)poiResult errorCode:(BMKSearchErrorCode)errorCode {
     NSMutableArray *array = [NSMutableArray array];
    for (BMKPoiInfo *info in poiResult.poiInfoList) {
        CGPoint locationPoint = CGPointMake(info.pt.longitude, info.pt.latitude);
        NSValue *valu = [NSValue valueWithCGPoint:locationPoint];

        NSDictionary *dic = @{info.name:valu};
        [array addObject:dic];
    }
    self.allLocation = [array mutableCopy];
    [self.tableView reloadData];

}
//searchbar根据他里面输入框数据的变化去列表中匹配响应的数据并重新更新数据
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    BMKCitySearchOption *citySearchOption = [[BMKCitySearchOption alloc]init];
    ZZCurrentCity *city = [ZZCurrentCity sharedCurrentName];
    //citySearchOption.pageIndex = curPage;
    citySearchOption.pageCapacity = 20;
    citySearchOption.city = city.currentCityName;
    citySearchOption.keyword = searchText;
    [self.poisearch poiSearchInCity:citySearchOption];
}
//当选中cell时做什么
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = self.allLocation[indexPath.row];
    self.block(dic);
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.allLocation.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newOneCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"newOneCell"];
    }
    NSDictionary *dic = self.allLocation[indexPath.row];
    NSString *pointName = [[dic allKeys]lastObject];
    cell.textLabel.text =pointName;
    return cell;
}

@end
