//
//  BTCourse.h
//  bt
//
//  Created by zjz on 2017/3/8.
//  Copyright © 2017年 selfdoctor. All rights reserved.
//

#import <Realm/Realm.h>

@class BTCourse;
@class BTPlan;

@interface BTAction : RLMObject
@property BTPlan *plan;
@property NSNumber<RLMInt> *dataId;
@property NSString *name;
@property NSString *category;
@property NSString *cover;
@property NSString *video;
@property NSNumber<RLMInt> *size;
@property NSNumber<RLMInt> *times;
@end
RLM_ARRAY_TYPE(BTAction)

@interface BTPlan : RLMObject
@property BTCourse *course;
@property NSNumber<RLMInt> *dataId;
@property NSString *name;
@property NSString *cover;
@property NSString *levelName;
@property NSString *tool;
@property NSNumber<RLMInt> *duration;
@property NSNumber<RLMInt> *calorie;
@property NSNumber<RLMInt> *times;
@property RLMArray<BTAction> *actions;
@end
RLM_ARRAY_TYPE(BTPlan)

@interface BTCourse : RLMObject
@property NSNumber<RLMInt> *dataId;
@property NSString *name;
@property NSString *cover;
@property NSNumber<RLMInt> *executionCount;
@property NSNumber<RLMInt> *coachId;
@property NSString *coachName;
@property NSString *coachAvatar;
@property RLMArray<BTPlan> *plans;
@property NSNumber<RLMBool> *isJoin;

+ (instancetype)currentCourse;
+ (void)fetchCourseWithBlock:(void(^)(NSError *error))block;
@end
RLM_ARRAY_TYPE(BTCourse)
