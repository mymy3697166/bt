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

@implementation BTPlanRecord @end

@implementation BTTag @end

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
      if (block) block(error);
      return;
    }
    if (![data[@"status"] isEqual:@0]) {
      if (block) block([NSError errorWithDomain:@"BTLOGICERROR" code:[data[@"status"] integerValue] userInfo:data]);
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
    if (block) block(nil);
  }];
}

- (void)logout {
  [Realm transactionWithBlock:^{
    currentUser.isLogin = @0;
  }];
}

+ (void)registerWithMobilePhone:(NSString *)mobilePhone andPwd:(NSString *)pwd andVerifyCode:(NSString *)verifyCode andBlock:(void (^)(NSError *))block {
  [Common asyncPost:URL_REGISTER forms:@{@"uid": mobilePhone, @"pwd": pwd, @"code": verifyCode} completion:^(NSDictionary *data, NSError *error) {
    if (error) {
      if (block) block(error);
      return;
    }
    if (![data[@"status"] isEqual:@0]) {
      if (block) block([NSError errorWithDomain:@"BTLOGICERROR" code:[data[@"status"] integerValue] userInfo:data]);
      return;
    }
    if (!currentUser) currentUser = [[BTUser alloc] init];
    currentUser.mid = data[@"data"][@"mid"];
    currentUser.token = data[@"data"][@"access_token"];
    currentUser.isLogin = @1;
    [Realm transactionWithBlock:^{
      [Realm addOrUpdateObject:currentUser];
    }];
    if (block) block(nil);
  }];
}

+ (void)sendRegisterVerifyCodeToMobilePhone:(NSString *)mobilePhone andBlock:(void (^)(NSError *))block {
  [Common asyncPost:URL_REGISTERCODE forms:@{@"mobile_no": mobilePhone} completion:^(NSDictionary *data, NSError *error) {
    if (error) {
      if (block) block(error);
      return;
    }
    if (![data[@"status"] isEqual:@0]) {
      if (block) block([NSError errorWithDomain:@"BTLOGICERROR" code:[data[@"status"] integerValue] userInfo:data]);
      return;
    }
    if (block) block(nil);
  }];
}

+ (void)validateVerifyCodeForMobilePhone:(NSString *)mobilePhone andVerifyCode:(NSString *)code andBlock:(void (^)(NSError *))block {
  [Common asyncPost:URL_VALIDATECODE forms:@{@"mobile_no": mobilePhone, @"code": code} completion:^(NSDictionary *data, NSError *error) {
    if (error) {
      if (block) block(error);
      return;
    }
    if (![data[@"status"] isEqual:@0]) {
      if (block) block([NSError errorWithDomain:@"BTLOGICERROR" code:[data[@"status"] integerValue] userInfo:data]);
      return;
    }
    if (block) block(nil);
  }];
}

- (void)saveInfoWithBlock:(void (^)(NSError *))block {
  NSDictionary *forms = @{@"avatar": _avatar, @"nc": _nickname, @"gender": _gender, @"dob": [_dob toStringWithFormat:@"yyyy-MM-dd"]};
  [Common asyncPost:URL_UPDATEUSERINFO forms:forms completion:^(NSDictionary *data, NSError *error) {
    if (error) {
      if (block) block(error);
      return;
    }
    if (![data[@"status"] isEqual:@0]) {
      if (block) block([NSError errorWithDomain:@"BTLOGICERROR" code:[data[@"status"] integerValue] userInfo:data]);
      return;
    }
    if (block) block(nil);
  }];
}

- (void)updateWeight:(NSNumber *)weight withBlock:(void(^)(NSError *))block {
  BTWeightRecord *wr = [[BTWeightRecord alloc] init];
  wr.user = self;
  wr.weight = weight;
  [Common asyncPost:URL_UPDATEWEIGHT forms:@{@"weight": weight} completion:^(NSDictionary *data, NSError *error) {
    if (error) {
      if (block) block(error);
      return;
    }
    if (![data[@"status"] isEqual:@0]) {
      if (block) block([NSError errorWithDomain:@"BTLOGICERROR" code:[data[@"status"] integerValue] userInfo:data]);
      return;
    }
    wr.dataId = data[@"data"][@"id"];
    wr.createdAt = [NSDate dateWithTimeIntervalSince1970:[data[@"data"][@"created_at"] integerValue]];
    [Realm transactionWithBlock:^{
      [self.weights addObject:wr];
    }];
    if (block) block(nil);
  }];
}

- (void)updateHeight:(NSNumber *)height withBlock:(void (^)(NSError *))block {
  BTHeightRecord *hr = [[BTHeightRecord alloc] init];
  hr.user = self;
  hr.height = height;
  [Common asyncPost:URL_UPDATEHEIGHT forms:@{@"height": height} completion:^(NSDictionary *data, NSError *error) {
    if (error) {
      if (block) block(error);
      return;
    }
    if (![data[@"status"] isEqual:@0]) {
      if (block) block([NSError errorWithDomain:@"BTLOGICERROR" code:[data[@"status"] integerValue] userInfo:data]);
      return;
    }
    hr.dataId = data[@"data"][@"id"];
    hr.createdAt = [NSDate dateWithTimeIntervalSince1970:[data[@"data"][@"created_at"] integerValue]];
    [Realm transactionWithBlock:^{
      [self.heights addObject:hr];
    }];
    if (block) block(nil);
  }];
}

- (void)joinCourseWithBlock:(void(^)(NSError *))block {
  [Common asyncPost:URL_JOINCOURSE forms:@{@"id": Course.dataId} completion:^(NSDictionary *data, NSError *error) {
    if (error) {
      if (block) block(error);
      return;
    }
    if (![data[@"status"] isEqual:@0]) {
      if (block) block([NSError errorWithDomain:@"BTLOGICERROR" code:[data[@"status"] integerValue] userInfo:data]);
      return;
    }
    [Realm transactionWithBlock:^{
      Course.isJoin = @1;
      Course.startTime = [NSDate dateWithTimeIntervalSince1970:[data[@"data"][@"start_time"] integerValue]];
    }];
    if (block) block(nil);
  }];
}

- (void)quitCourseWithBlock:(void (^)(NSError *))block {
  [Common asyncPost:URL_QUITCOURSE forms:@{@"id": Course.dataId} completion:^(NSDictionary *data, NSError *error) {
    if (error) {
      if (block) block(error);
      return;
    }
    if (![data[@"status"] isEqual:@0]) {
      if (block) block([NSError errorWithDomain:@"BTLOGICERROR" code:[data[@"status"] integerValue] userInfo:data]);
      return;
    }
    [Realm transactionWithBlock:^{
      Course.isJoin = @0;
      Course.startTime = nil;
      [User.planRecords removeAllObjects];
    }];
    if (block) block(nil);
  }];
}
@end
