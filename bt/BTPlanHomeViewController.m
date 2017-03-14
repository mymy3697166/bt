//
//  BTPlanHomeViewController.m
//  bt
//
//  Created by zjz on 2017/1/16.
//  Copyright © 2017年 selfdoctor. All rights reserved.
//

#import "BTPlanHomeViewController.h"
#import "BTLoginNavigationController.h"
#import "BTWeightCell.h"
#import "BTCurrentCourseCell.h"
#import "BTNoCourseCell.h"
#import "BTRecommendArticleCell.h"
#import "BTDynamicTitleCell.h"
#import "BTDynamicCell.h"
#import "BTListBottomCell.h"
#import "MJRefresh.h"
#import "MJRefreshStateHeader.h"

@interface BTPlanHomeViewController () <UITableViewDataSource, UITableViewDelegate> {
  __weak IBOutlet UITableView *tvTable;
  __weak IBOutlet UIView *vNoLogin;
  __weak IBOutlet UIButton *btnLogin;
  
  NSMutableArray *dataSource;
}
@end

@implementation BTPlanHomeViewController
- (void)viewDidLoad {
  [super viewDidLoad];
  dataSource = [NSMutableArray array];
  btnLogin.layer.cornerRadius = 5;
  // 设置预测表格单元格高度
  tvTable.estimatedRowHeight = 100;
  tvTable.rowHeight = UITableViewAutomaticDimension;
  
  [Notif addObserver:self selector:@selector(loginSuccess) name:@"N_LOGIN_SUCCESS" object:nil];
  [Notif addObserver:self selector:@selector(updateWeightSuccess) name:@"N_UPDATE_WEIGHT_SUCCESS" object:nil];
  
  MJRefreshNormalHeader *mjHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
    [self loadRemoteDataWithBlock:^{
      [tvTable.mj_header endRefreshing];
    }];
  }];
  mjHeader.lastUpdatedTimeLabel.hidden = YES;
  tvTable.mj_header = mjHeader;
  
  if (User) {
    vNoLogin.hidden = YES;
    [self loadLocalData];
    [self loadRemoteDataWithBlock:nil];
  }
}

- (void)loadLocalData {
  [dataSource removeAllObjects];
  // 向数据源加入体重数据
  NSDictionary *weightInfo;
  if (User.weights.count == 0) {
    weightInfo = @{@"data": @[@{@"weight": @0, @"difference": @0}], @"key": @"BTWeightCell"};
  }
  else {
    BTWeightRecord *first = User.weights.firstObject;
    BTWeightRecord *last = User.weights.lastObject;
    NSNumber *diff = [NSNumber numberWithFloat:[first.weight floatValue] - [last.weight floatValue]];
    weightInfo = @{@"data": @[@{@"weight": last.weight, @"difference": diff}], @"key": @"BTWeightCell"};
    [dataSource addObject:weightInfo];
  }
  if (Course) {
    [dataSource addObject:@{@"data": @[Course], @"key": [Course.isJoin isEqualToNumber:@1] ? @"BTCurrentCourseCell" : @"BTNoCourseCell"}];
    if ([Course.isJoin isEqualToNumber:@0]) {
      NSArray *articles = [BTDataCache getValueForKey:@"PLAN_HOME_ARTICLES"];
      if (![articles null]) [dataSource addObject:@{@"data": @[articles], @"key": @"BTRecommendArticleCell"}];
    }
    [dataSource addObject:@{@"data": @[Course], @"key": @"BTDynamicTitleCell"}];
    NSMutableArray *dynamics = [NSMutableArray arrayWithArray:[BTDataCache getValueForKey:@"PLAN_HOME_DYNAMICS"]];
    NSInteger count = dynamics.count;
    if (count == 31) [dynamics removeObjectAtIndex:30];
    [dataSource addObject:@{@"data": dynamics, @"key": @"BTDynamicCell"}];
    if (count == 0) [dataSource addObject:@{@"data": @[@"还没有任何动态"], @"key": @"BTListBottomCell"}];
    else if (count == 31) [dataSource addObject:@{@"data": @[@"查看更多动态"], @"key": @"BTListBottomCell"}];
    else [dataSource addObject:@{@"data": @[@"没有更多了"], @"key": @"BTListBottomCell"}];
  }
}

- (void)loadRemoteDataWithBlock:(void(^)())block {
  [Common requestQueue:^{
    NSError *error;
    NSDictionary *res = [Common syncPost:URL_FETCHPLANHOME forms:@{@"article": @1, @"course": @1} error:&error];
    if (error) {
      [self showError:error];
      return;
    }
    while (dataSource.count > 1) {
      [dataSource removeLastObject];
    }
    // 更新课程信息
    [BTCourse updateCourseWithData:res[@"data"]];
    // 向数据源加入课程数据
    [dataSource addObject:@{@"data": @[Course], @"key": [Course.isJoin isEqualToNumber:@1] ? @"BTCurrentCourseCell" : @"BTNoCourseCell"}];
    // 缓存文章数据并加入数据源
    if ([Course.isJoin isEqualToNumber:@0]) {
      [BTDataCache setValue:res[@"data"][@"articles"] forKey:@"PLAN_HOME_ARTICLES"];
      [dataSource addObject:@{@"data": @[res[@"data"][@"articles"]], @"key": @"BTRecommendArticleCell"}];
    }
    // 向数据源加入课程动态标题数据
    [dataSource addObject:@{@"data": @[Course], @"key": @"BTDynamicTitleCell"}];
    // 拉取课程动态数据
    res = [Common syncPost:URL_FETCHDYNAMICS forms:@{@"course": Course.dataId, @"rows": @31} error:&error];
    if (error) {
      [self showError:error];
      return;
    }
    // 缓存动态数据并加入数据源
    [BTDataCache setValue:res[@"data"] forKey:@"PLAN_HOME_DYNAMICS"];
    NSMutableArray *dynamics = [NSMutableArray arrayWithArray:res[@"data"]];
    NSInteger count = dynamics.count;
    if (count == 31) [dynamics removeObjectAtIndex:30];
    [dataSource addObject:@{@"data": dynamics, @"key": @"BTDynamicCell"}];
    if (count == 0) [dataSource addObject:@{@"data": @[@"还没有任何动态"], @"key": @"BTListBottomCell"}];
    else if (count == 31) [dataSource addObject:@{@"data": @[@"查看更多动态"], @"key": @"BTListBottomCell"}];
    else [dataSource addObject:@{@"data": @[@"没有更多了"], @"key": @"BTListBottomCell"}];
    [tvTable reloadData];
    if (block) dispatch_async(dispatch_get_main_queue(), ^{block();});
  }];
}

- (void)loginSuccess {
  vNoLogin.hidden = YES;
  [self loadLocalData];
  [tvTable reloadData];
  [self loadRemoteDataWithBlock:nil];
}

- (void)updateWeightSuccess {
  BTWeightRecord *first = User.weights.firstObject;
  BTWeightRecord *last = User.weights.lastObject;
  NSNumber *diff = [NSNumber numberWithFloat:[first.weight floatValue] - [last.weight floatValue]];
  [dataSource replaceObjectAtIndex:0 withObject:@{@"data": @[@{@"weight": last.weight, @"difference": diff}], @"key": @"BTWeightCell"}];
  [tvTable reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {return 0.0001;}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {return 0.0001;}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  NSArray *ds = dataSource[section][@"data"];
  return ds.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSDictionary *sectionData = dataSource[indexPath.section];
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:dataSource[indexPath.section][@"key"]];
  if (!cell) {
    UINib *nib = [UINib nibWithNibName:sectionData[@"key"] bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:sectionData[@"key"]];
    cell = [tableView dequeueReusableCellWithIdentifier:sectionData[@"key"]];
  }
  if ([sectionData[@"key"] isEqualToString:@"BTWeightCell"]) {
    BTWeightCell *wc = (BTWeightCell *)cell;
    [wc setData:sectionData[@"data"][indexPath.row] inController:self];
  } else if ([sectionData[@"key"] isEqualToString:@"BTCurrentCourseCell"]) {
    BTCurrentCourseCell *ccc = (BTCurrentCourseCell *)cell;
    [ccc setData:sectionData[@"data"][indexPath.row] inController:self];
  } else if ([sectionData[@"key"] isEqualToString:@"BTNoCourseCell"]) {
    BTNoCourseCell *ncc = (BTNoCourseCell *)cell;
    [ncc setData:sectionData[@"data"][indexPath.row] inController:self];
  } else if ([sectionData[@"key"] isEqualToString:@"BTRecommendArticleCell"]) {
    BTRecommendArticleCell *rac = (BTRecommendArticleCell *)cell;
    [rac setData:sectionData[@"data"][indexPath.row] inController:self];
  } else if ([sectionData[@"key"] isEqualToString:@"BTDynamicTitleCell"]) {
    BTDynamicTitleCell *dtc = (BTDynamicTitleCell *)cell;
    [dtc setData:sectionData[@"data"][indexPath.row] inController:self];
  } else if ([sectionData[@"key"] isEqualToString:@"BTDynamicCell"]) {
    BTDynamicCell *dc = (BTDynamicCell *)cell;
    [dc setData:sectionData[@"data"][indexPath.row]];
  } else {
    BTListBottomCell *lbc = (BTListBottomCell *)cell;
    lbc.height = 52;
    if ([sectionData[@"data"][indexPath.row] isEqualToString:@"查看更多动态"])
      [lbc setTitle:sectionData[@"data"][indexPath.row] block:^{
        NSLog(@"go le");
      }];
    else [lbc setTitle:sectionData[@"data"][indexPath.row] block:nil];
  }
  return cell;
}

- (IBAction)btnLoginClick:(UIButton *)sender {
  BTLoginNavigationController *lnc = [self.storyboard instantiateViewControllerWithIdentifier:@"BTLoginNavigationController"];
  [self presentViewController:lnc animated:YES completion:nil];
}
@end
