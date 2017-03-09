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

@implementation BTWeightRecord
+ (NSString *)primaryKey {return @"dataId";}
@end

@implementation BTHeightRecord
+ (NSString *)primaryKey {return @"dataId";}
@end

@implementation BTUser
+ (NSString *)primaryKey {
  return @"mid";
}

+ (NSDictionary *)defaultPropertyValues {
  return @{@"fansCount": @0, @"followCount": @0, @"dynamicCount": @0, @"isCoach": @0, @"isLogin": @0};
}

+ (instancetype)currentUser {
  if (!currentUser) {
    RLMResults<BTUser *> *users = [BTUser objectsWhere:@"isLogin==1"];
    if (users.count > 0) currentUser = users.firstObject;
  }
  return currentUser;
}

+ (void)loginWithMobilePhone:(NSString *)mobilePhone andPwd:(NSString *)pwd andBlock:(void(^)(NSError *))block {
  NSDictionary *forms = @{@"uid": mobilePhone, @"pwd": pwd, @"scope": @"description,activity,weights", };
  [Common asyncPost:URL_LOGIN forms:forms completion:^(NSDictionary *data, NSError *error) {
    if (error) {
      block(error);
      return;
    }
    if (![data[@"status"] isEqual:@0]) {
      block([NSError errorWithDomain:@"BTLOGICERROR" code:[data[@"status"] integerValue] userInfo:data]);
      return;
    }
    currentUser = [[BTUser alloc] init];
    NSDictionary *info = data[@"data"];
    currentUser.mid = info[@"mid"];
    currentUser.token = info[@"access_token"];
    if (![info[@"nc"] null]) currentUser.nickname = data[@"data"][@"nc"];
    if (![info[@"avatar"] null]) currentUser.avatar = data[@"data"][@"avatar"];
    if (![info[@"gender"] null]) currentUser.gender = data[@"data"][@"gender"];
    if (![info[@"dob"] null]) currentUser.dob = [((NSString *)data[@"data"][@"dob"]) toDateWithFormat:@"yyyy-MM-dd"];
    if (![info[@"fans_count"] null]) currentUser.fansCount = data[@"data"][@"follow_count"];
    if (![info[@"follow_count"] null]) currentUser.followCount = data[@"data"][@"fans_count"];
    if (![info[@"dynamic_count"] null]) currentUser.dynamicCount = data[@"data"][@"dynamic_count"];
    currentUser.isLogin = @1;
    [Realm transactionWithBlock:^{
      if (![info[@"weights"] null]) {
        NSArray *weights = info[@"weights"];
        [weights enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
          BTWeightRecord *weight = [[BTWeightRecord alloc] init];
          weight.dataId = obj[@"id"];
          weight.user = User;
          weight.weight = obj[@"weight"];
          weight.createdAt = [NSDate dateWithTimeIntervalSince1970:[obj[@"created_at"] integerValue]];
          [currentUser.weights addObject:weight];
        }];
      }
      [Realm addOrUpdateObject:currentUser];
    }];
    block(nil);
  }];
}

+ (void)registerWithMobilePhone:(NSString *)mobilePhone andPwd:(NSString *)pwd andVerifyCode:(NSString *)verifyCode andBlock:(void (^)(NSError *))block {
  [Common asyncPost:URL_REGISTER forms:@{@"uid": mobilePhone, @"pwd": pwd, @"code": verifyCode} completion:^(NSDictionary *data, NSError *error) {
    if (error) {
      block(error);
      return;
    }
    if (![data[@"status"] isEqual:@0]) {
      block([NSError errorWithDomain:@"BTLOGICERROR" code:[data[@"status"] integerValue] userInfo:data]);
      return;
    }
    if (!currentUser) currentUser = [[BTUser alloc] init];
    currentUser.mid = data[@"data"][@"mid"];
    currentUser.token = data[@"data"][@"access_token"];
    currentUser.isLogin = @1;
    [Realm transactionWithBlock:^{
      [Realm addOrUpdateObject:currentUser];
    }];
    block(nil);
  }];
}

+ (void)sendRegisterVerifyCodeToMobilePhone:(NSString *)mobilePhone andBlock:(void (^)(NSError *))block {
  [Common asyncPost:URL_REGISTERCODE forms:@{@"mobile_no": mobilePhone} completion:^(NSDictionary *data, NSError *error) {
    if (error) {
      block(error);
      return;
    }
    if (![data[@"status"] isEqual:@0]) {
      block([NSError errorWithDomain:@"BTLOGICERROR" code:[data[@"status"] integerValue] userInfo:data]);
      return;
    }
    block(nil);
  }];
}

+ (void)validateVerifyCodeForMobilePhone:(NSString *)mobilePhone andVerifyCode:(NSString *)code andBlock:(void (^)(NSError *))block {
  [Common asyncPost:URL_VALIDATECODE forms:@{@"mobile_no": mobilePhone, @"code": code} completion:^(NSDictionary *data, NSError *error) {
    if (error) {
      block(error);
      return;
    }
    if (![data[@"status"] isEqual:@0]) {
      block([NSError errorWithDomain:@"BTLOGICERROR" code:[data[@"status"] integerValue] userInfo:data]);
      return;
    }
    block(nil);
  }];
}

- (void)saveInfoWithBlock:(void (^)(NSError *))block {
  
}

- (void)updateWeight:(NSNumber *)weight withBlock:(void(^)())block {
  BTWeightRecord *wr = [[BTWeightRecord alloc] init];
  wr.user = User;
  wr.weight = weight;
  [Common asyncPost:URL_UPDATEWEIGHT forms:@{@"weight": weight} completion:^(NSDictionary *data, NSError *error) {
    if (error) {
      block(error);
      return;
    }
    if (![data[@"status"] isEqual:@0]) {
      block([NSError errorWithDomain:@"BTLOGICERROR" code:[data[@"status"] integerValue] userInfo:data]);
      return;
    }
    wr.dataId = data[@"data"][@"id"];
    wr.createdAt = [NSDate dateWithTimeIntervalSince1970:[data[@"data"][@"created_at"] integerValue]];
    [Realm transactionWithBlock:^{
      [Realm addObject:wr];
    }];
    block(nil);
  }];
}
@end
