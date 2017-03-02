//
//  BTUser.h
//  bt
//
//  Created by zjz on 2017/1/9.
//  Copyright © 2017年 selfdoctor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>

@class BTUser;
/// 体重记录
@interface BTWeightRecord : RLMObject
@property NSNumber *dataId;
@property BTUser *user;
@property NSNumber *weight;
@property NSDate *createdAt;
@end
RLM_ARRAY_TYPE(BTWeightRecord)
@implementation BTWeightRecord @end
/// 身高记录
@interface BTHeightRecord : RLMObject
@property NSNumber *dataId;
@property BTUser *user;
@property NSNumber *height;
@property NSDate *createdAt;
@end
RLM_ARRAY_TYPE(BTHeightRecord)
@implementation BTHeightRecord @end
/// 用户
@interface BTUser : RLMObject
@property NSNumber *mid;
@property NSString *token;
@property NSString *nickname;
@property NSString *avatar;
@property NSString *gender;
@property NSDate *dob;
@property NSNumber *fansCount;
@property NSNumber *followCount;
@property NSNumber *dynamicCount;
@property NSString *isCoach;
@property RLMArray<BTWeightRecord> *weights;
@property RLMArray<BTHeightRecord> *heights;
@property NSString *isLogin;
/// 当前用户
+ (instancetype)currentUser;
/// 登录
+ (void)loginWithMobilePhone:(NSString *)mobilePhone andPwd:(NSString *)pwd;
/// 注册
+ (void)registerWithMobilePhone:(NSString *)mobilePhone andPwd:(NSString *)pwd andVerifyCode:(NSString *)verifyCode;
/// 保持用户数据
- (void)saveInfoWithBlock:(void(^)(NSError *error))block;
@end
RLM_ARRAY_TYPE(BTUser)

