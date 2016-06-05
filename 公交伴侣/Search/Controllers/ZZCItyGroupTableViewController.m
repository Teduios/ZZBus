//
//  CItyGroupTableViewController.m
//  HomeWork
//
//  Created by Tarena on 16/5/17.
//  Copyright © 2016年 Tarena. All rights reserved.
//

#import "ZZCItyGroupTableViewController.h"
#import "ZZCurrentCity.h"
#import "ZZBusDataManager.h"
@interface ZZCItyGroupTableViewController ()<UISearchBarDelegate>
@property (nonatomic,strong) NSMutableArray *allCitys;
@property (nonatomic,strong) NSArray *allCityName;
@property (nonatomic,strong) UISearchBar *searchBar;
@end

@implementation ZZCItyGroupTableViewController
- (NSArray *)allCitys {
    if (!_allCitys) {
    _allCitys = [self.allCityName copy];
    }
    return _allCitys;
}
- (NSArray *)allCityName {
    if (!_allCityName) {
        _allCityName = [[ZZBusDataManager loadAllCitys] copy];
    }
    return _allCityName;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSearchBar];
}
- (void)initSearchBar {
    self.searchBar = [UISearchBar new];
    self.searchBar.delegate = self;
    [self.searchBar sizeToFit];
    self.tableView.tableHeaderView = self.searchBar;
    self.searchBar.placeholder = @"搜索城市";    
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length == 0) {
        self.allCitys = [self.allCityName copy];
        [self.tableView reloadData];
        return;
     }
    NSMutableArray *array = [NSMutableArray new];
            for (ZZCity *city in self.allCityName) {
                for (NSString *cityName in city.cities) {
                    if ([cityName containsString:searchText]) {
                        if (![array containsObject:cityName]) {
                            [array addObject:cityName];
    
                        }
                    }
                }
            }
    
                self.allCitys = [array copy];
                [self.tableView reloadData];

    
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    if (searchBar.text.length == 0) {
        self.allCitys = [self.allCityName copy];
        [self.tableView reloadData];
        

    }
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    self.allCitys = [self.allCityName copy];
    [self.tableView reloadData];
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZZCurrentCity *current = [ZZCurrentCity sharedCurrentName];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    NSString *str =cell.textLabel.text;
    current.currentCityName =str;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cityChange" object:str];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if (self.allCitys.count != 0) {
        if ([self.allCitys[0] isKindOfClass:[ZZCity class]]) {
            NSMutableArray *array = [NSMutableArray array];
            for (ZZCity *city in self.allCitys) {
                [array addObject:city.title];
            }
            return [array copy];
        }
        return nil;
    }
    else {
        return nil;
    }
    
   
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.allCitys.count != 0) {
        if ([self.allCitys[0] isKindOfClass:[ZZCity class]]) {
            return self.allCitys.count;
        }
        else {
            return 1;
        }

    }
    else {
        return 1;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.allCitys.count != 0) {
        if ([self.allCitys[0] isKindOfClass:[ZZCity class]]) {
            ZZCity *city = self.allCitys[section];
            return city.cities.count;
        }
        return self.allCitys.count;
    }
    else {
        return 0;
    }
  
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    if ([self.allCitys[0] isKindOfClass:[ZZCity class]]) {
        ZZCity *city = self.allCitys[indexPath.section];
        cell.textLabel.text = city.cities[indexPath.row];
        

    }
    else {
        cell.textLabel.text = self.allCitys[indexPath.row];
        
    }
    return cell;
   }
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (self.allCitys.count != 0) {
        if ([self.allCitys[0] isKindOfClass:[ZZCity class]]) {
            ZZCity *city = self.allCitys[section];
            return city.title;
        }
        else{
            return nil;
        }

    }
    else {
        return 0;
    }
    
}
@end
