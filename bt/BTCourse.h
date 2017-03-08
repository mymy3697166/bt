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

@end
RLM_ARRAY_TYPE(BTAction)

@interface BTPlan : RLMObject
@property BTCourse *course;
@property NSString *name;
@property NSString *cover;
@property NSString *category;
@property NSString *video;
@property NSNumber<RLMDouble> *size;
@property NSNumber<RLMInt> *times;
@property NSArray<BTAction> *actions;
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
@end
RLM_ARRAY_TYPE(BTCourse)
