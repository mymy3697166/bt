//
//  BTDynamicTitleCell.h
//  bt
//
//  Created by zjz on 2017/3/9.
//  Copyright © 2017年 selfdoctor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTCommon.h"
@interface BTDynamicTitleCell : UITableViewCell
- (void)setData:(BTCourse *)course inController:(UIViewController *)controller;
@end
