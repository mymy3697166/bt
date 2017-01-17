//
//  BTCurrentCourseCell.m
//  bt
//
//  Created by zjz on 17/1/16.
//  Copyright © 2017年 selfdoctor. All rights reserved.
//

#import "BTCurrentCourseCell.h"
#import "BTCourseHomeCalendarView.h"
#import "BTCommon.h"

@implementation BTCurrentCourseCell {
  __weak IBOutlet UIButton *btnCourse;
  __weak IBOutlet UIView *vCalendar;
}

- (void)awakeFromNib {
  [super awakeFromNib];
  btnCourse.clipsToBounds = YES;
  btnCourse.layer.cornerRadius = 16;
}

- (void)setData:(NSArray *)plans userPlans:(NSArray *)userPlans {
  // 去重用户训练
  NSArray *duPlans = [self distinct:userPlans];
  // 计算自今天起之后的训练
  NSMutableArray *yPlans = [NSMutableArray arrayWithArray:plans];
  [duPlans enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    if ([yPlans[idx][@"id"] isEqual:@0]) [yPlans removeObjectAtIndex:0];
    [yPlans removeObjectAtIndex:0];
  }];
  // 判断今天又没有完成训练
  NSDictionary *tPlan = [duPlans find:^BOOL(id item) {
    NSTimeInterval sd = [[[NSDate date] toDate] timeIntervalSince1970];
    NSTimeInterval ed = sd + 86399;
    NSTimeInterval cd = [item[@"complete_time"] integerValue];
    return cd <= ed && cd >= sd;
  }];
  // 渲染日历
  NSMutableArray *dates = [NSMutableArray array];
  for (int i = 0; i < 6; i++) {
    CGFloat w = (vCalendar.bounds.size.width - 32) / 6;
    BTCourseHomeCalendarView *view = [[BTCourseHomeCalendarView alloc] init];
    [view.ivIcon tintColor:[UIColor lightGrayColor]];
    NSDate *date = [[[NSDate date] toDate] dateByAddingTimeInterval:86400 * i];
    view.labDate.text = [NSString stringWithFormat:@"%2ld", (long)[date day]];
    NSDictionary *plan;
    if (i < yPlans.count) {
      plan = yPlans[i];
    }
    if (i == 0) {
      view.labDate.text = @"今日";
      if (plan && [plan[@"id"] isEqual:@0]) {
        view.labComplete.text = @"休息";
        view.ivIcon.image = [UIImage imageNamed:@"icon_rest"];
        [view.ivIcon tintColor:RGB(0, 178, 255)];
      }
      if (plan && ![plan[@"id"] isEqual:@0]) {
        view.labComplete.text = @"训练";
        view.ivIcon.image = [UIImage imageNamed:@"icon_fire"];
        [view.ivIcon tintColor:RGB(0, 178, 255)];
      }
      if (plan && ![plan[@"id"] isEqual:@0] && tPlan) {
        view.labComplete.text = @"完成";
        view.labDate.textColor = RGB(0, 178, 255);
        view.ivIcon.image = [UIImage imageNamed:@"icon_selected_yes"];
      }
      if (!plan) {
        view.labComplete.text = @"无训练";
      }
    } else {
      if (plan && [plan[@"id"] isEqual:@0]) {
        view.labComplete.text = @"休息";
        view.ivIcon.image = [UIImage imageNamed:@"icon_rest"];
        [view.ivIcon tintColor:[UIColor lightGrayColor]];
      }
    }
    view.frame = CGRectMake(w * i, 0, w, 70);
    [vCalendar addSubview:view];
    [dates addObject:view];
  }
}

- (NSArray *)distinct:(NSArray *)source {
  NSMutableArray *newArray = [NSMutableArray array];
  [source enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    NSDictionary *item = obj;
    NSTimeInterval cd = [item[@"complete_time"] integerValue];
    NSDate *time = [NSDate dateWithTimeIntervalSince1970:cd];
    NSTimeInterval date = [[time toDate] timeIntervalSince1970];
    NSDictionary *res = [newArray find:^BOOL(id i) {
      return [i[@"date"] isEqualToNumber:[NSNumber numberWithInteger:date]];
    }];
    NSMutableDictionary *newItem = [NSMutableDictionary dictionaryWithDictionary:item];
    [newItem setObject:[NSNumber numberWithInteger:date] forKey:@"date"];
    if (!res){
      [newArray addObject:newItem];
    }
  }];
  return newArray;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
}

@end
