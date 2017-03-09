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
  tvTable.estimatedRowHeight = 100;
  tvTable.rowHeight = UITableViewAutomaticDimension;
  [Notif addObserver:self selector:@selector(loginComplete) name:@"N_LOGIN_SUCCESS" object:nil];
  [self loadLocalData];
  [self loadRemoteData];
}

- (void)loadLocalData {
  if (User) {
    NSDictionary *weightInfo;
    if (User.weights.count == 0) {
      weightInfo = @{@"data": @[@{@"weight": @0, @"difference": @0}], @"key": @"BTWeightCell"};
    }
    else {
      BTWeightRecord *first = User.weights.firstObject;
      BTWeightRecord *last = User.weights.lastObject;
      NSNumber *diff = [NSNumber numberWithInt:[first.weight intValue] - [last.weight intValue]];
      weightInfo = @{@"data": @[@{@"weight": last.weight, @"difference": diff}], @"key": @"BTWeightCell"};
      [dataSource addObject:weightInfo];
    }
    if (Course) {
      NSString *key;
      if ([Course.isJoin isEqualToNumber:@1]) key = @"BTCurrentCourseCell";
      else key = @"BTNoCourseCell";
      [dataSource addObject:@{@"data": @[Course], @"key": key}];
      if ([Course.isJoin isEqualToNumber:@0]) {
        NSArray *articles = [BTDataCache getValueForKey:@"PLAN_HOME_ARTICLES"];
        if (articles) {
          [dataSource addObject:@{@"data": @[articles], @"key": @"BTRecommendArticleCell"}];
        }
      }
      [dataSource addObject:@{@"data": @[Course], @"key": @"BTDynamicTitleCell"}];
    }
  }
}

- (void)loadRemoteData {
  if (User) {
    [Common requestQueue:^{
      NSError *error;
      NSDictionary *res = [Common syncPost:URL_FETCHPLANHOME forms:@{@"article": @1, @"course": @1} error:&error];
      NSLog(@"%@", res);
      if (error) {
        [self showError:error];
        return;
      }
      [BTCourse updateCourseWithData:res[@"data"]];
      NSString *key;
      if ([Course.isJoin isEqualToNumber:@1]) key = @"BTCurrentCourseCell";
      else key = @"BTNoCourseCell";
      NSDictionary *courseInfo = @{@"data": @[Course], @"key": key};
      [self insertItem:courseInfo];
      if ([Course.isJoin isEqualToNumber:@0]) {
        [BTDataCache setValue:res[@"data"][@"articles"] forKey:@"PLAN_HOME_ARTICLES"];
        [self insertItem:@{@"data": @[res[@"data"][@"articles"]], @"key": @"BTRecommendArticleCell"}];
      }
      [self insertItem:@{@"data": @[Course], @"key": @"BTDynamicTitleCell"}];
      [tvTable reloadData];
    }];
  }
}

- (void)insertItem:(NSDictionary *)item {
  NSInteger index = [self getDataSourceIndexForKey:item[@"key"]];
  if (index != -1) {
    [dataSource replaceObjectAtIndex:index withObject:item];
    return;
  }
  if ([item[@"key"] isEqualToString:@"BTCurrentCourseCell"] || [item[@"key"] isEqualToString:@"BTNoCourseCell"]) {
    if (dataSource.count < 2) [dataSource addObject:item];
    else [dataSource insertObject:item atIndex:1];
  }
  if ([item[@"key"] isEqualToString:@"BTRecommendArticleCell"]) {
    if (dataSource.count < 3) [dataSource addObject:item];
    else [dataSource insertObject:item atIndex:2];
  }
  if ([item[@"key"] isEqualToString:@"BTDynamicTitleCell"]) {
    NSInteger articleIndex = [self getDataSourceIndexForKey:@"BTRecommendArticleCell"];
    if (articleIndex == -1) {
      if (dataSource.count < 3) [dataSource addObject:item];
      else [dataSource insertObject:item atIndex:2];
    } else {
      if (dataSource.count < 4) [dataSource addObject:item];
      else [dataSource insertObject:item atIndex:3];
    }
  }
}

- (NSInteger)getDataSourceIndexForKey:(NSString *)key {
  for (int i = 0; i < dataSource.count; i++) {
    if ([key isEqualToString:dataSource[i][@"key"]]) return i;
  }
  return -1;
}

- (void)loginComplete {
  [self loadLocalData];
  [tvTable reloadData];
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
    UINib *weightNib = [UINib nibWithNibName:sectionData[@"key"] bundle:nil];
    [tableView registerNib:weightNib forCellReuseIdentifier:sectionData[@"key"]];
    cell = [tableView dequeueReusableCellWithIdentifier:sectionData[@"key"]];
  }
  if ([sectionData[@"key"] isEqualToString:@"BTWeightCell"]) {
    BTWeightCell *wc = (BTWeightCell *)cell;
    [wc setData:sectionData[@"data"][indexPath.row]];
  } else if ([sectionData[@"key"] isEqualToString:@"BTNoCourseCell"]) {
    BTNoCourseCell *ncc = (BTNoCourseCell *)cell;
    [ncc setData:sectionData[@"data"][indexPath.row]];
  } else if ([sectionData[@"key"] isEqualToString:@"BTRecommendArticleCell"]) {
    BTRecommendArticleCell *rac = (BTRecommendArticleCell *)cell;
    [rac setData:sectionData[@"data"][indexPath.row]];
  } else if ([sectionData[@"key"] isEqualToString:@"BTDynamicTitleCell"]) {
    BTDynamicTitleCell *dtc = (BTDynamicTitleCell *)cell;
    [dtc setData:sectionData[@"data"][indexPath.row]];
  }
  return cell;
}

- (IBAction)btnLoginClick:(UIButton *)sender {
  BTLoginNavigationController *lnc = [self.storyboard instantiateViewControllerWithIdentifier:@"BTLoginNavigationController"];
  [self presentViewController:lnc animated:YES completion:nil];
}
@end
