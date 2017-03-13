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
@class BTPlan;
/// 体重记录
@interface BTWeightRecord : RLMObject
@property NSNumber<RLMInt> *dataId;
@property BTUser *user;
@property NSNumber<RLMFloat> *weight;
@property NSDate *createdAt;
@end
RLM_ARRAY_TYPE(BTWeightRecord)
/// 身高记录
@interface BTHeightRecord : RLMObject
@property NSNumber<RLMInt> *dataId;
@property BTUser *user;
@property NSNumber<RLMFloat> *height;
@property NSDate *createdAt;
@end
RLM_ARRAY_TYPE(BTHeightRecord)
/// 训练记录
@interface BTPlanRecord : RLMObject
@property BTUser *user;
@property BTPlan *plan;
@property NSDate *completeTime;
@end
RLM_ARRAY_TYPE(BTPlanRecord)
/// 用户
@interface BTUser : RLMObject
@property NSNumber<RLMInt> *mid;
@property NSString *token;
@property NSString *nickname;
@property NSString *avatar;
@property NSString *gender;
@property NSDate *dob;
@property NSNumber<RLMInt> *fansCount;
@property NSNumber<RLMInt> *followCount;
@property NSNumber<RLMInt> *dynamicCount;
@property NSNumber<RLMBool> *isCoach;
@property RLMArray<BTWeightRecord> *weights;
@property RLMArray<BTHeightRecord> *heights;
@property NSNumber<RLMBool> *isLogin;
@property RLMArray<BTPlanRecord> *planRecords;
/// 当前用户
+ (instancetype)currentUser;
/// 使用手机号和密码登录
+ (void)loginWithMobilePhone:(NSString *)mobilePhone andPwd:(NSString *)pwd andBlock:(void(^)(NSError *error))block;
/// 注册
+ (void)registerWithMobilePhone:(NSString *)mobilePhone andPwd:(NSString *)pwd andVerifyCode:(NSString *)verifyCode andBlock:(void(^)(NSError *error))block;
/// 发送注册验证码
+ (void)sendRegisterVerifyCodeToMobilePhone:(NSString *)mobilePhone andBlock:(void(^)(NSError *error))block;
/// 验证验证码的有效性
+ (void)validateVerifyCodeForMobilePhone:(NSString *)mobilePhone andVerifyCode:(NSString *)code andBlock:(void(^)(NSError *error))block;
/// 保存用户数据
- (void)saveInfoWithBlock:(void(^)(NSError *error))block;
/// 更新体重数据
- (void)updateWeight:(NSNumber *)weight withBlock:(void(^)(NSError *error))block;
/// 加入课程
- (void)joinCourseWithBlock:(void(^)(NSError *error))block;
/// 退出课程
- (void)quitCourseWithBlock:(void(^)(NSError *error))block;
@end
RLM_ARRAY_TYPE(BTUser)

