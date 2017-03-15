//
//  BTArticleListViewController.m
//  bt
//
//  Created by zjz on 2017/3/15.
//  Copyright © 2017年 selfdoctor. All rights reserved.
//

#import "BTArticleListViewController.h"
#import "BTMainArticleCell.h"
#import "BTSecondaryArticleCell.h"
#import "MJRefresh.h"
#import "BTListBottomCell.h"

@interface BTArticleListViewController () <UITableViewDelegate, UITableViewDataSource> {
  __weak IBOutlet UITableView *tvArticles;
  
  NSMutableArray *dataSource;
  NSInteger page;
  BOOL hasNext;
}
@end

@implementation BTArticleListViewController
- (void)viewDidLoad {
  [super viewDidLoad];
  dataSource = [NSMutableArray arrayWithArray:[BTDataCache getValueForKey:@"ARTICLE_LIST_ARTICLES"]];
  page = 0;
  hasNext = YES;
  
  tvArticles.estimatedRowHeight = 100;
  tvArticles.rowHeight = UITableViewAutomaticDimension;
  MJRefreshNormalHeader *mjHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
    page = 0;
    [self fetchArticles:^{
      [tvArticles.mj_header endRefreshing];
    }];
  }];
  mjHeader.lastUpdatedTimeLabel.hidden = YES;
  tvArticles.mj_header = mjHeader;
  MJRefreshAutoNormalFooter *mjFooter = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
    if (!hasNext) {
      [tvArticles.mj_footer endRefreshing];
      return;
    }
    page++;
    [self fetchArticles:^{
      [mjFooter endRefreshing];
    }];
  }];
  mjHeader.lastUpdatedTimeLabel.hidden = YES;
  tvArticles.mj_footer = mjFooter;
  
  [self fetchArticles:nil];
}

- (void)fetchArticles:(void(^)())block {
  [Common asyncPost:URL_FETCHARTICLES forms:@{@"rows": @20, @"page": [NSNumber numberWithInteger:page]} completion:^(NSDictionary *data, NSError *error) {
    if (error) {
      [self showError:error];
      if (block) block();
      return;
    }
    if (((NSArray *)data[@"data"]).count < 20) hasNext = NO;
    if (page == 0) {
      [BTDataCache setValue:dataSource forKey:@"ARTICLE_LIST_ARTICLES"];
      dataSource = [NSMutableArray arrayWithArray:data[@"data"]];
    } else [dataSource addObjectsFromArray:data[@"data"]];
    [tvArticles reloadData];
    if (block) block();
  }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {return dataSource.count;}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {return 1;}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  return section == 0 ? 0.0001 : 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {return 0.0001;}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//  if (indexPath.section == dataSource.count) {
//    static NSString *lbcString = @"BTListBottomCell";
//    BTListBottomCell *cell = [tableView dequeueReusableCellWithIdentifier:lbcString];
//    if (!cell) {
//      UINib *nib = [UINib nibWithNibName:lbcString bundle:nil];
//      [tableView registerNib:nib forCellReuseIdentifier:lbcString];
//      cell = [tableView dequeueReusableCellWithIdentifier:lbcString];
//      cell.height = 60;
//    }
//    if (dataSource.count == 0) {
//      [cell setTitle:@"小编还没来得及送货" block:nil];
//    } else if (dataSource.count < 20 && dataSource.count > 0) {
//      [cell setTitle:@"没有更多了" block:nil];
//    }
//    if (hasNext) {
//      [cell setTitle:@"正在加载更多..." block:nil];
//    }
//    return cell;
//  }
  NSDictionary *article = dataSource[indexPath.section];
  if ([article[@"status"] isEqualToString:@"1"]) {
    BTMainArticleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BTMainArticleCell"];
    [cell setData:article inController:self];
    return cell;
  } else {
    BTSecondaryArticleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BTSecondaryArticleCell"];
    [cell setData:article inController:self];
    return cell;
  }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  
}
@end
