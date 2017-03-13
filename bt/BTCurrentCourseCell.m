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
  __weak IBOutlet UILabel *labTitle;
  __weak IBOutlet UIImageView *ivPlanImage;
  __weak IBOutlet UIImageView *ivComplete;
  __weak IBOutlet UILabel *labPlanTitle;
  __weak IBOutlet UILabel *labLevel;
  __weak IBOutlet UILabel *labDuration;
  __weak IBOutlet UILabel *labCaloire;
  __weak IBOutlet UILabel *labComplete;
  __weak IBOutlet UIView *vCourse;
  __weak IBOutlet UIView *vRest;
  
  UIViewController *viewController;
}

- (void)awakeFromNib {
  [super awakeFromNib];
  btnCourse.layer.cornerRadius = 16;
}

- (void)setData:(BTCourse *)course inController:(UIViewController *)controller {
  viewController = controller;
  // 去重用户训练
  NSArray *duPlans = [self distinct:Course.plans];
  // 计算自今天起之后的训练
  NSMutableArray *yPlans = [NSMutableArray arrayWithArray:plans];
  [duPlans enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    if ([yPlans[idx][@"id"] isEqual:@0]) [yPlans removeObjectAtIndex:0];
    [yPlans removeObjectAtIndex:0];
  }];
  if (yPlans.count > 0 && [yPlans[0][@"id"] isEqual:@0]) {
    NSTimeInterval cd = [duPlans.lastObject[@"complete_time"] integerValue];
    if (cd < [[[NSDate date] toDate] timeIntervalSince1970] - 86400) [yPlans removeObjectAtIndex:0];
  }
  // 判断今天又没有完成训练
  NSDictionary *tPlan = [duPlans find:^BOOL(id item) {
    NSTimeInterval sd = [[[NSDate date] toDate] timeIntervalSince1970];
    NSTimeInterval ed = sd + 86399;
    NSTimeInterval cd = [item[@"complete_time"] integerValue];
    return cd <= ed && cd >= sd;
  }];
  // 渲染日历
  NSMutableArray *dates = [NSMutableArray array];
  for (int i = 0; i < 5; i++) {
    CGFloat w = (vCalendar.bounds.size.width - 32) / 5;
    BTCourseHomeCalendarView *view = [[BTCourseHomeCalendarView alloc] init];
    [view.ivIcon tintColor:[UIColor lightGrayColor]];
    NSDate *date = [[[NSDate date] toDate] dateByAddingTimeInterval:86400 * i];
    view.labDate.text = [NSString stringWithFormat:@"%2ld", (long)[date day]];
    NSDictionary *plan;
    if (i < yPlans.count) {
      plan = yPlans[i];
    }
    if (i == 0) {
      view.labDate.text = @"今";
      if (plan && [plan[@"id"] isEqual:@0]) {
        view.labComplete.text = @"休息";
        view.labDate.textColor = RGB(0, 178, 255);
        view.ivIcon.image = [UIImage imageNamed:@"icon_rest"];
        [view.ivIcon tintColor:RGB(0, 178, 255)];
      }
      if (plan && ![plan[@"id"] isEqual:@0]) {
        view.labComplete.text = @"训练";
        view.labDate.textColor = RGB(255, 128, 0);
        view.ivIcon.image = [UIImage imageNamed:@"icon_fire"];
        [view.ivIcon tintColor:RGB(255, 128, 0)];
      }
      if (plan && ![plan[@"id"] isEqual:@0] && tPlan) {
        view.labComplete.text = @"完成";
        view.labDate.textColor = RGB(0, 178, 255);
        view.ivIcon.image = [UIImage imageNamed:@"icon_selected_yes"];
        [view.ivIcon tintColor:RGB(0, 178, 255)];
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
  [self setPlan:yPlans[0] isComplete:tPlan != nil];
}

- (void)setPlan:(NSDictionary *)plan isComplete:(BOOL)com {
  BOOL rest = [plan[@"id"] isEqual:@0];
  if (rest) {
    labTitle.text = @"今日休息";
    vRest.hidden = NO;
  } else {
    labTitle.text = @"今日训练";
    [ivPlanImage loadURL:[URL_IMAGEPATH stringByAppendingString:plan[@"cover"]]];
    if (com) {
      ivComplete.image = [UIImage imageNamed:@"icon_selected_yes"];
      [ivComplete tintColor:RGB(0, 178, 255)];
      labComplete.text = @"今日已完成";
    }
    else {
      ivComplete.image = [UIImage imageNamed:@"icon_fire"];
      [ivComplete tintColor:RGB(255, 128, 0)];
      labComplete.text = @"今日未完成";
    }
    labPlanTitle.text = plan[@"name"];
    labLevel.text = [NSString stringWithFormat:@"%@ / %@", plan[@"level_name"], plan[@"tool"]];
    labDuration.text = [NSString stringWithFormat:@"耗时：%@", plan[@"duration"]];
    labCaloire.text = [NSString stringWithFormat:@"消耗热量：%@kcal", plan[@"calorie"]];
  }
}

- (NSArray *)distinct:(RLMArray<BTPlanRecord> *)source {
  NSMutableArray *newArray = [NSMutableArray array];
  for (BTPlanRecord *record in source) {
    NSTimeInterval date = [[record.completeTime toDate] timeIntervalSince1970];
    NSDictionary *res = [newArray find:^BOOL(id i) {
      return [i[@"date"] isEqualToNumber:[NSNumber numberWithInteger:date]];
    }];
    NSMutableDictionary *newItem = [NSMutableDictionary dictionaryWithDictionary:item];
    [newItem setObject:[NSNumber numberWithInteger:date] forKey:@"date"];
    if (!res){
      [newArray addObject:newItem];
    }
  }
  [source enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    NSDictionary *item = obj;
  }];
  return newArray;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
}
@end
