//
//  BTRefreshView.h
//  bt
//
//  Created by zjz on 17/3/11.
//  Copyright © 2017年 selfdoctor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BTRefreshView : UIView
@property (assign, nonatomic, readonly) BOOL isRefreshing;

- (instancetype)initWithTarget:(UITableView *)target;
- (void)beginRefreshing:(CGFloat)distance;
@end
