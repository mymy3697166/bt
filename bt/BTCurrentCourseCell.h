//
//  BTCurrentCourseCell.h
//  bt
//
//  Created by zjz on 17/1/16.
//  Copyright © 2017年 selfdoctor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTCommon.h"

@interface BTCurrentCourseCell : UITableViewCell
- (void)setData:(BTCourse *)course inController:(UIViewController *)controller;
@end
