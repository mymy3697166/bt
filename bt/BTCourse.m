//
//  BTCourse.m
//  bt
//
//  Created by zjz on 2017/3/8.
//  Copyright © 2017年 selfdoctor. All rights reserved.
//

#import "BTCourse.h"
#import "BTCommon.h"

static BTCourse *currentCourse;

@implementation BTAction

@end

@implementation BTPlan

@end

@implementation BTCourse
+ (instancetype)currentCourse {
  if (currentCourse) return currentCourse;
  RLMResults *results = [BTCourse allObjects];
  if (results.count > 0) return results.firstObject;
  return nil;
}

+ (void)fetchCourseWithBlock:(void (^)(NSError *))block {
  [Common asyncPost:URL_FETCHPLANHOME forms:@{@"course": @1} completion:^(NSDictionary *data, NSError *error) {
    if (error) {
      block(error);
      return;
    }
    if (![data[@"status"] isEqual:@0]) {
      block([NSError errorWithDomain:@"BTLOGICERROR" code:[data[@"status"] integerValue] userInfo:data]);
      return;
    }
    [BTCourse updateCourseWithData:data[@"data"]];
    block(nil);
  }];
}

+ (void)updateCourseWithData:(NSDictionary *)data {
  if (currentCourse) {
    [Realm transactionWithBlock:^{
      [Realm deleteObjects:[BTAction allObjects]];
      [Realm deleteObjects:[BTPlan allObjects]];
      [Realm deleteObjects:[BTCourse allObjects]];
    }];
  }
  currentCourse = [[BTCourse alloc] init];
  currentCourse.dataId = data[@"course_id"];
  currentCourse.name = data[@"course_name"];
  currentCourse.cover = data[@"course_cover"];
  currentCourse.executionCount = data[@"course_execution_count"];
  currentCourse.coachId = data[@"course_coach_id"];
  currentCourse.coachName = data[@"course_coach_name"];
  currentCourse.coachAvatar = data[@"course_coach_avatar"];
  currentCourse.isJoin = data[@"start_time"] ? @1 : @0;
  [Realm transactionWithBlock:^{
    NSArray *planArray = data[@"course_plans"];
    [planArray enumerateObjectsUsingBlock:^(id planDic, NSUInteger planIdx, BOOL *planStop) {
      BTPlan *plan = [[BTPlan alloc] init];
      plan.course = currentCourse;
      plan.dataId = planDic[@"id"];
      if (![planDic[@"id"] isEqual:@0]) {
        plan.name = planDic[@"name"];
        plan.cover = planDic[@"cover"];
        plan.levelName = planDic[@"level_name"];
        plan.tool = planDic[@"tool"];
        plan.duration = planDic[@"duration"];
        plan.calorie = planDic[@"calorie"];
        NSArray *actionArray = planDic[@"actions"];
        [actionArray enumerateObjectsUsingBlock:^(id actionDic, NSUInteger actionIdx, BOOL *actionStop) {
          BTAction *action = [[BTAction alloc] init];
          action.plan = plan;
          action.dataId = actionDic[@"id"];
          action.category = actionDic[@"category"];
          if (![actionDic[@"id"] isEqual:@0]) {
            action.name = actionDic[@"name"];
            action.cover = actionDic[@"cover"];
            action.video = actionDic[@"video"];
            action.size = actionDic[@"size"];
            action.times = actionDic[@"times"];
          }
          [plan.actions addObject:action];
        }];
      }
      [currentCourse.plans addObject:plan];
    }];
    [Realm addObject:currentCourse];
  }];
}
@end
