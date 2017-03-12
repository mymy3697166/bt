//
//  BTRefreshView.m
//  bt
//
//  Created by zjz on 17/3/11.
//  Copyright © 2017年 selfdoctor. All rights reserved.
//

#import "BTRefreshView.h"

@implementation BTRefreshView {
  UITableView *tableView;
  
  CGFloat controlWidth;
  CGFloat screenWidth;
}
- (instancetype)initWithTarget:(UITableView *)target {
  self = [super init];
  tableView = target;
  _isRefreshing = NO;
  screenWidth = [UIScreen mainScreen].bounds.size.width;
  controlWidth = 50;
  self.frame = CGRectMake((screenWidth - controlWidth) / 2, -controlWidth, controlWidth, controlWidth);
  
  [tableView addSubview:self];
  
  UIActivityIndicatorView *aiv = [[UIActivityIndicatorView alloc] initWithFrame:self.bounds];
  aiv.color = [UIColor grayColor];
  aiv.hidesWhenStopped = NO;
  [self addSubview:aiv];
  return self;
}

- (void)beginRefreshing:(CGFloat)distance {
  if (distance < 0) return;
  if (!_isRefreshing && distance > controlWidth) {
    self.frame = CGRectMake((screenWidth - controlWidth) / 2, -distance, controlWidth, controlWidth);
  }
  if (!_isRefreshing && distance <= controlWidth) {
    tableView.contentInset = UIEdgeInsetsMake(distance, 0, 0, 0);
  }
  if (distance >= controlWidth * 2 && !_isRefreshing) {
    _isRefreshing = YES;
  }
}
@end
