//
//  BTUser.m
//  bt
//
//  Created by zjz on 2017/1/9.
//  Copyright © 2017年 selfdoctor. All rights reserved.
//

#import "BTUser.h"
#import "BTCommon.h"

static BTUser *currentUser;

@implementation BTUser
+ (NSString *)primaryKey {
  return @"mid";
}

+ (NSDictionary *)defaultPropertyValues {
  return @{@"fansCount": @0, @"followCount": @0, @"dynamicCount": @0, @"isCoach": @"false", @"isLogin": @"false"};
}

+ (instancetype)currentUser {
  if (!currentUser) {
    RLMResults<BTUser *> *users = [BTUser objectsWhere:@"isLogin=='true'"];
    if (users.count > 0) currentUser = users.firstObject;
  }
  return currentUser;
}

+ (void)loginWithMobilePhone:(NSString *)mobilePhone andPwd:(NSString *)pwd {
  NSDictionary *forms = @{@"uid": mobilePhone, @"pwd": pwd, @"scope": @"description", };
  [Common showLoading];
  [Common asyncPost:URL_LOGIN forms:forms completion:^(NSDictionary *data) {
    [Common hideLoading];
    if (data == nil) return;
    if (![data[@"status"] isEqual:@0]) {
      [Common info:data[@"description"]];
      return;
    }
    if (!currentUser) currentUser = [[BTUser alloc] init];
    currentUser.mid = data[@"data"][@"mid"];
    currentUser.token = data[@"data"][@"access_token"];
    if (![data[@"data"][@"nc"] null]) currentUser.nickname = data[@"data"][@"nc"];
    if (![data[@"data"][@"avatar"] null]) currentUser.avatar = data[@"data"][@"avatar"];
    if (![data[@"data"][@"gender"] null]) currentUser.gender = data[@"data"][@"gender"];
    if (![data[@"data"][@"dob"] null]) currentUser.dob = [((NSString *)data[@"data"][@"dob"]) toDateWithFormat:@"yyyy-MM-dd"];
    if (![data[@"data"][@"fans_count"] null]) currentUser.fansCount = data[@"data"][@"follow_count"];
    if (![data[@"data"][@"follow_count"] null]) currentUser.followCount = data[@"data"][@"fans_count"];
    if (![data[@"data"][@"dynamic_count"] null]) currentUser.dynamicCount = data[@"data"][@"dynamic_count"];
    currentUser.isLogin = @"1";
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm transactionWithBlock:^{
      [realm addOrUpdateObject:currentUser];
    }];
    [N postNotificationName:@"N_LOGINCOMPLETE" object:nil];
  }];
}

+ (void)registerWithMobilePhone:(NSString *)mobilePhone andPwd:(NSString *)pwd andVerifyCode:(NSString *)verifyCode {
  [Common showLoading];
  [Common asyncPost:URL_REGISTER forms:@{@"uid": mobilePhone, @"pwd": pwd, @"code": verifyCode} completion:^(NSDictionary *data) {
    [Common hideLoading];
    if (data == nil) return;
    if (![data[@"status"] isEqual:@0]) {
      [Common info:data[@"description"]];
      return;
    }
    if (!currentUser) currentUser = [[BTUser alloc] init];
    currentUser.mid = data[@"data"][@"mid"];
    currentUser.token = data[@"data"][@"access_token"];
    currentUser.isLogin = @"1";
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm transactionWithBlock:^{
      [realm addOrUpdateObject:currentUser];
    }];
    [N postNotificationName:@"N_REGISTERCOMPLETE" object:nil];
  }];
}

- (void)saveInfoWithBlock:(void (^)(NSError *))block {
  
}

- (void)updateWeight:(NSNumber *)weight block:(void(^)())block {
  BTWeightRecord *wr = [[BTWeightRecord alloc] init];
  wr.user = U;
  wr.weight = weight;
  [Common showLoading];
  [Common asyncPost:URL_UPDATEWEIGHT forms:@{@"weight": weight} completion:^(NSDictionary *data) {
    [Common hideLoading];
    if (data == nil) return;
    if (![data[@"status"] isEqual:@0]) {
      [Common info:data[@"description"]];
      return;
    }
    wr.dataId = data[@"data"][@"id"];
    wr.createdAt = [NSDate dateWithTimeIntervalSince1970:[data[@"data"][@"created_at"] integerValue]];
    [R transactionWithBlock:^{
      [R addObject:wr];
    }];
    
  }];;
}
@end
