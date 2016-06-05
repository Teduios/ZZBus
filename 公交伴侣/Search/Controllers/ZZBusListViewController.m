//
//  ZZBusListViewController.m
//  MyBus
//
//  Created by Tarena on 16/5/16.
//  Copyright © 2016年 Tarena. All rights reserved.
//

#import "ZZBusListViewController.h"
#import "ZZBusListTableViewCell.h"
#import "ZZBusDataManager.h"
@interface ZZBusListViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *stationName;
@property (weak, nonatomic) IBOutlet UITableView *busList;
@property (nonatomic,strong) NSArray *allBusName;
@end

@implementation ZZBusListViewController
- (NSArray *)allBusName {
    if (!_allBusName) {
        _allBusName = [ZZBusDataManager loadAllBusInStation];
    }
    return _allBusName;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.busList.delegate = self;
    self.busList.dataSource = self;
    self.stationName.text = self.cuttenStation;
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(clickIterm)];
    self.navigationItem.leftBarButtonItem = item;
    self.navigationItem.title = @"公交车路线";
}
- (void)clickIterm {
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.allBusName.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZZBusListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"busListCell" forIndexPath:indexPath];
    [cell setInformationWith:self.allBusName[indexPath.row]];
    return cell;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
