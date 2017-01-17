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

@interface BTPlanHomeViewController () <UITableViewDataSource, UITableViewDelegate> {
  __weak IBOutlet UITableView *tvTable;
  
  NSDictionary *dataSource;
}

@end

@implementation BTPlanHomeViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  tvTable.estimatedRowHeight = 80;
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
  return 2;
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
      cell = [tableView dequeueReusableCellWithIdentifier:@"BTCurrentCourseCell" forIndexPath:indexPath];
      BTCurrentCourseCell *ccCell = (BTCurrentCourseCell *)cell;
      [ccCell setData:dataSource];
    }
  }
  return cell;
}
@end
