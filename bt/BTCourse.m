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
    if (currentCourse) {
      [R deleteObjects:[BTAction allObjects]];
      [R deleteObjects:[BTPlan allObjects]];
      [R deleteObjects:[BTCourse allObjects]];
    }
    NSDictionary *courseDic = data[@"data"];
    BTCourse *course = [[BTCourse alloc] init];
    course.dataId = courseDic[@"course_id"];
    course.name = courseDic[@"course_name"];
    course.cover = courseDic[@"course_cover"];
    course.executionCount = courseDic[@"course_execution_count"];
    course.coachId = courseDic[@"course_coach_id"];
    course.coachName = courseDic[@"course_coach_name"];
    course.coachAvatar = courseDic[@"course_coach_avatar"];
    course.isJoin = courseDic[@"start_time"] ? @1 : @0;
    [R transactionWithBlock:^{
      NSArray *planArray = courseDic[@"course_plans"];
      [planArray enumerateObjectsUsingBlock:^(id planDic, NSUInteger planIdx, BOOL *planStop) {
        BTPlan *plan = [[BTPlan alloc] init];
        plan.course = course;
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
        [course.plans addObject:plan];
      }];
      [R addObject:course];
    }];
    block(nil);
  }];
}
@end
