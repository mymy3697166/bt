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

@interface BTPlanHomeViewController () <UITableViewDataSource, UITableViewDelegate> {
  __weak IBOutlet UITableView *tvTable;
  
  NSDictionary *dataSource;
}

@end

@implementation BTPlanHomeViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  tvTable.estimatedRowHeight = 100;
  tvTable.rowHeight = UITableViewAutomaticDimension;
  [Common asyncPost:URL_ACCESSTOKENLOGIN forms:nil completion:^(NSDictionary *data) {
    if (!data) return;
    if ([data[@"status"] isEqual:@0]) {
      User.token = data[@"data"][@"access_token"];
      UIImageView *btn = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 36, 36)];
      btn.clipsToBounds = YES;
      btn.layer.cornerRadius = 18;
      [btn loadURL:[URL_AVATARPATH stringByAppendingString:User.avatar]];
      self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
      [Common asyncPost:URL_FETCHPLANHOME forms:@{@"weight": @1, @"article": @1, @"difference": @1, @"course": @1} completion:^(NSDictionary *data) {
        if (!data) return;
        if ([data[@"status"] isEqual:@0]) {
          dataSource = data[@"data"];
          [tvTable reloadData];
        } else {
          [Common info:data[@"description"]];
        }
      }];
    } else {
      BTLoginNavigationController *lnc = [self.storyboard instantiateViewControllerWithIdentifier:@"BTLoginNavigationController"];
      [self presentViewController:lnc animated:YES completion:nil];
    }
  }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {return 1;}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {return 1;}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 1;
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
    }
  }
  return cell;
}
@end
