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
  
  NSMutableArray *dataSource;
}

@end

@implementation BTPlanHomeViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  dataSource = [NSMutableArray array];
  if (U) {
    BTWeightRecord *first = U.weights.firstObject;
    BTWeightRecord *last = U.weights.lastObject;
    NSNumber *diff = [NSNumber numberWithInt:[first.weight intValue] - [last.weight intValue]];
    NSDictionary *weightInfo = @{@"data": @[@{@"weight": last.weight, @"difference": diff}], @"rowHeight": @158, @"key": @"BTWeightCell"};
    [dataSource addObject:weightInfo];
  }
  if (!Course) {
    [BTCourse fetchCourseWithBlock:^(NSError *error) {
      NSLog(@"%@", error);
    }];
  }
  btnLogin.layer.cornerRadius = 5;
  [N addObserver:self selector:@selector(loginComplete) name:@"N_LOGIN_SUCCESS" object:nil];
}

- (void)loginComplete {
//  if (U.mid) {
//    [Common asyncPost:URL_FETCHPLANHOME forms:@{@"weight": @1, @"article": @1, @"difference": @1, @"course": @1} completion:^(NSDictionary *data, NSError *error) {
//      if (!data) return;
//      if ([data[@"status"] isEqual:@0]) {
//        U.weights = data[@"weight"];
//        U.difference = data[@"difference"];
//        dataSource = data[@"data"];
//        [tvTable reloadData];
//      } else {
//        [Common info:data[@"description"]];
//      }
//    }];
//  }
//  [Common asyncPost:URL_FETCHDYNAMICS forms:@{@"course": @1} completion:^(NSDictionary *data, NSError *error) {
//    if (!data) return;
//    if ([data[@"status"] isEqual:@0]) {
//      //dynamics = data[@"data"];
//      NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:4];
//      [tvTable reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
//    } else {
//      [Common info:data[@"description"]];
//    }
//  }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {return 0.0001;}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {return 0.0001;}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return [dataSource[indexPath.section][@"rowHeight"] floatValue];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  NSArray *ds = dataSource[section][@"data"];
  return ds.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  BTWeightCell *cell = [tableView dequeueReusableCellWithIdentifier:dataSource[indexPath.section][@"key"]];
  if (!cell) {
    UINib *guideNib = [UINib nibWithNibName:@"BTWeightCell" bundle:nil];
    [tableView registerNib:guideNib forCellReuseIdentifier:@"BTWeightCell"];
    cell = [tableView dequeueReusableCellWithIdentifier:@"BTWeightCell"];
  }
  [cell setData:dataSource[indexPath.section][@"data"][indexPath.row]];
  return cell;
}

- (IBAction)btnLoginClick:(UIButton *)sender {
  BTLoginNavigationController *lnc = [self.storyboard instantiateViewControllerWithIdentifier:@"BTLoginNavigationController"];
  [self presentViewController:lnc animated:YES completion:nil];
}
@end
