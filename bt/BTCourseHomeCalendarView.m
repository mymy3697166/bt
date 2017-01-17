//
//  BTCourseHomeCalendarView.m
//  bt
//
//  Created by zjz on 2017/1/17.
//  Copyright © 2017年 selfdoctor. All rights reserved.
//

#import "BTCourseHomeCalendarView.h"

@implementation BTCourseHomeCalendarView

- (instancetype)init {
  NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"BTCourseHomeCalendarView" owner:self options:nil];
  self = (BTCourseHomeCalendarView *)views[0];
  return self;
}
@end
