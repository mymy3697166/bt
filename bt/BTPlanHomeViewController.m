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
#import "BTDynamicCell.h"

@interface BTPlanHomeViewController () <UITableViewDataSource, UITableViewDelegate> {
  __weak IBOutlet UITableView *tvTable;
  __weak IBOutlet UIView *vNoLogin;
  __weak IBOutlet UIButton *btnLogin;
  
  NSDictionary *dataSource;
}

@end

@implementation BTPlanHomeViewController

- (void)viewDidLoad {
  
  [super viewDidLoad];
  tvTable.estimatedRowHeight = 100;
  tvTable.rowHeight = UITableViewAutomaticDimension;
  btnLogin.layer.cornerRadius = 5;
  [N addObserver:self selector:@selector(loginComplete) name:@"NLOGINCOMPLETE" object:nil];
}

- (void)loginComplete {
  if (User.avatar != nil)
    [btn loadURL:[URL_AVATARPATH stringByAppendingString:User.avatar]];
  if (User.uid != nil) {
    [Common asyncPost:URL_FETCHPLANHOME forms:@{@"weight": @1, @"article": @1, @"difference": @1, @"course": @1} completion:^(NSDictionary *data) {
      if (!data) return;
      if ([data[@"status"] isEqual:@0]) {
        dataSource = data[@"data"];
        [tvTable reloadData];
      } else {
        [Common info:data[@"description"]];
      }
    }];
  }
  [Common asyncPost:URL_FETCHDYNAMICS forms:@{@"course": @1} completion:^(NSDictionary *data) {
    if (!data) return;
    if ([data[@"status"] isEqual:@0]) {
      dynamics = data[@"data"];
      NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:4];
      [tvTable reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    } else {
      [Common info:data[@"description"]];
    }
  }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {return 0.0001;}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {return 0.0001;}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  NSArray *ds = dataSource[]
  return dataSource.allKeys[section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
  if (!cell) {
    if (indexPath.section == 0) {
      cell = [tableView dequeueReusableCellWithIdentifier:@"BTWeightCell" forIndexPath:indexPath];
      BTWeightCell *wCell = (BTWeightCell *)cell;
      wCell.weight = User.weight;
      wCell.diff = @0;
    } else if (indexPath.section == 1) {
      if (dataSource[@"start_time"]) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"BTCurrentCourseCell" forIndexPath:indexPath];
        BTCurrentCourseCell *ccCell = (BTCurrentCourseCell *)cell;
        [ccCell setData:dataSource];
      } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"BTNoCourseCell" forIndexPath:indexPath];
        BTNoCourseCell *ncCell = (BTNoCourseCell *)cell;
        [ncCell setData:dataSource];
      }
    } else if (indexPath.section == 2) {
      cell = [tableView dequeueReusableCellWithIdentifier:@"BTRecommendArticleCell" forIndexPath:indexPath];
      BTRecommendArticleCell *raCell = (BTRecommendArticleCell *)cell;
      [raCell setData:dataSource[@"articles"]];
    } else if (indexPath.section == 3) {
      cell = [tableView dequeueReusableCellWithIdentifier:@"BTCourseDynamicTitleCell" forIndexPath:indexPath];
      UILabel *lab = cell.contentView.subviews[0];
      lab.text = [NSString stringWithFormat:@"有%@人也在执行（%@）", dataSource[@"course_execution_count"], dataSource[@"course_name"]];
    } else {
      cell = [tableView dequeueReusableCellWithIdentifier:@"BTDynamicCell" forIndexPath:indexPath];
      BTDynamicCell *dCell = (BTDynamicCell *)cell;
      dCell.data = dynamics[indexPath.row];
    }
  }
  return cell;
}

- (IBAction)btnLoginClick:(UIButton *)sender {
  BTLoginNavigationController *lnc = [self.storyboard instantiateViewControllerWithIdentifier:@"BTLoginNavigationController"];
  [self presentViewController:lnc animated:YES completion:nil];
}
@end
