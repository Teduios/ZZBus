//
//  SearchLocationViewController.m
//  MyBus
//
//  Created by Tarena on 16/5/7.
//  Copyright © 2016年 Tarena. All rights reserved.
//

#import "ZZSearchLocationViewController.h"
#import "ZZStationListViewController.h"
#import "ZZBusDataManager.h"
#import "ZZBusListViewController.h"
@interface ZZSearchLocationViewController ()<ZZBusDelegate>
@property (weak, nonatomic) IBOutlet UITextField *searchTextFiled;
@property (nonatomic, strong) UIView *grayView;
@end

@implementation ZZSearchLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addView];
    [self.searchTextFiled becomeFirstResponder];
    switch (self.searchSwitch) {
        case BUSNAME:
            self.searchTextFiled.placeholder = @"请输入公交车号";
            break;
            
        default:
            self.searchTextFiled.placeholder = @"请输入站台名称";
            break;
    }
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(clickIterm)];
    self.navigationItem.leftBarButtonItem = item;
}
- (void)clickIterm {
    [self.navigationController popViewControllerAnimated:YES];
}
//添加当下载数据时显示active控件
- (void) addView {
    self.grayView = [[UIView alloc]initWithFrame:self.view.bounds];
    self.grayView.backgroundColor = [UIColor colorWithRed:245.0/255 green:245.0/255 blue:245.0/255 alpha:0.5];
    UIActivityIndicatorView *activ = [UIActivityIndicatorView new];
    [activ startAnimating];
    activ.frame = CGRectMake(0, 0, 40, 40);
    activ.color = [UIColor blackColor];
    activ.center = self.grayView.center;
    [self.grayView addSubview:activ];
    [self.view addSubview:self.grayView];
    }
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.searchTextFiled becomeFirstResponder];
    self.grayView.hidden = YES;

}

- (IBAction)searchFinish:(UITextField *)sender {

    [self downLoadBusData];
    
}
- (IBAction)didprintEnd:(id)sender {
    [self searchFinish:nil];
}
//实现代理方法（下载失败弹窗）
- (void)downLoadDefult
{
    self.grayView.hidden = YES;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"查询不到结果" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        self.searchTextFiled.text = @"";
    }];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];

    
}
//实现代理方法（下载成功并跳转界面）
- (void)downLoadSuccess {
    if (self.searchSwitch == BUSNAME) {
        ZZStationListViewController *stationListView = [self.storyboard instantiateViewControllerWithIdentifier:@"stationList"];
        [self.delegate historyChangeWith:self.searchTextFiled.text WithChoose:BUSNAMESEARCH];
        [self.navigationController pushViewController:stationListView animated:YES];

    }
    else {
        ZZBusListViewController *busList = [self.storyboard instantiateViewControllerWithIdentifier:@"busList"];
        busList.cuttenStation = self.searchTextFiled.text;
        [self.delegate historyChangeWith:self.searchTextFiled.text WithChoose:STATIONNAMESEARCH];
        [self.navigationController pushViewController:busList animated:YES];
    }
    
    
}
//下载数据并且显示active，并设置代理
- (void)downLoadBusData {
    self.grayView.hidden = NO;
    ZZBusDataManager *busData = [ZZBusDataManager new];
    busData.delegate = self;
    if (self.searchSwitch == BUSNAME) {
        [busData loadPlanListWithCity:self.currentCity StartMark:nil End:nil BusName:self.searchTextFiled.text StationName:nil];
    }
    else {
        [busData loadPlanListWithCity:self.currentCity StartMark:nil End:nil BusName:nil StationName:self.searchTextFiled.text];  
    }
    
}
@end
