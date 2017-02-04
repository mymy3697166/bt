//
//  BTUser.m
//  bt
//
//  Created by zjz on 2017/1/9.
//  Copyright © 2017年 selfdoctor. All rights reserved.
//

#import "BTUser.h"
#import "BTCommon.h"

@implementation BTUser {
  NSUserDefaults *ud;
}

- (instancetype)init {
  ud = [NSUserDefaults standardUserDefaults];
  return self;
}

- (NSNumber *)uid {return [ud objectForKey:@"USER-UID"];}
- (void)setUid:(NSNumber *)uid {
  if (uid == nil) {
    [ud removeObjectForKey:@"USER-UID"];
    return;
  }
  [ud setObject:uid forKey:@"USER-UID"];
}

- (NSString *)token {return [ud objectForKey:@"USER-TOKEN"];}
- (void)setToken:(NSString *)token {
  if (token == nil) {
    [ud removeObjectForKey:@"USER-TOKEN"];
    return;
  }
  [ud setObject:token forKey:@"USER-TOKEN"];
}

- (NSString *)nickname {return [ud objectForKey:@"USER-NICKNAME"];}
- (void)setNickname:(NSString *)nickname {
  if (nickname == nil) {
    [ud removeObjectForKey:@"USER-NICKNAME"];
    return;
  }
  [ud setObject:nickname forKey:@"USER-NICKNAME"];
}

- (NSString *)avatar {return [ud objectForKey:@"USER-AVATAR"];}
- (void)setAvatar:(NSString *)avatar {
  if (avatar == nil) {
    [ud removeObjectForKey:@"USER-AVATAR"];
    return;
  }
  [ud setObject:avatar forKey:@"USER-AVATAR"];
}

- (NSString *)gender {return [ud objectForKey:@"USER-GENDER"];}
- (void)setGender:(NSString *)gender {
  if (gender == nil) {
    [ud removeObjectForKey:@"USER-GENDER"];
    return;
  }
  [ud setObject:gender forKey:@"USER-GENDER"];
}

- (NSDate *)dob {return [ud objectForKey:@"USER-DOB"];}
- (void)setDob:(NSDate *)dob {
  if (dob == nil) {
    [ud removeObjectForKey:@"USER-DOB"];
    return;
  }
  [ud setObject:dob forKey:@"USER-DOB"];
}

- (NSNumber *)weight {return [ud objectForKey:@"USER-WEIGHT"];}
- (void)setWeight:(NSNumber *)weight {
  if (weight == nil) {
    [ud removeObjectForKey:@"USER-WEIGHT"];
    return;
  }
  [ud setObject:weight forKey:@"USER-WEIGHT"];
}

- (NSNumber *)height {return [ud objectForKey:@"USER-HEIGHT"];}
- (void)setHeight:(NSNumber *)height {
  if (height == nil) {
    [ud removeObjectForKey:@"USER-HEIGHT"];
    return;
  }
  [ud setObject:height forKey:@"USER-HEIGHT"];
}

- (void)login:(NSString *)uid pwd:(NSString *)pwd {
  NSDictionary *forms = @{@"uid": uid, @"pwd": pwd, @"scope": @"description"};
  [Common showLoading];
  [Common asyncPost:URL_LOGIN forms:forms completion:^(NSDictionary *data) {
    [Common hideLoading];
    if (data == nil) return;
    if ([data[@"status"] isEqual:@0]) {
      User.uid = data[@"data"][@"mid"];
      User.token = data[@"data"][@"access_token"];
      if (![data[@"data"][@"nc"] null]) User.nickname = data[@"data"][@"nc"];
      if (![data[@"data"][@"avatar"] null]) User.avatar = data[@"data"][@"avatar"];
      if (![data[@"data"][@"gender"] null]) User.gender = data[@"data"][@"gender"];
      if (![data[@"data"][@"dob"] null]) User.dob = [((NSString *)data[@"data"][@"dob"]) toDateWithFormat:@"yyyy-MM-dd"];
      if (![data[@"data"][@"height"] null]) User.height = data[@"data"][@"height"];
      if (![data[@"data"][@"weight"] null]) User.weight = data[@"data"][@"weight"];
      [N postNotificationName:@"NLOGINCOMPLETE" object:nil];
    } else {
      [Common info:data[@"description"]];
    }
  }];
}

- (void)autoLogin {
  if (self.uid == nil) return;
  [Common asyncPost:URL_ACCESSTOKENLOGIN forms:nil completion:^(NSDictionary *data) {
    if (!data) return;
    if ([data[@"status"] isEqual:@0]) {
      User.token = data[@"data"][@"access_token"];
    } else {
      [self clearData];
    }
    [N postNotificationName:@"NLOGINCOMPLETE" object:nil];
  }];
}

- (void)clearData {
  self.uid = nil;
  self.token = nil;
  self.nickname = nil;
  self.avatar = nil;
  self.gender = nil;
  self.dob = nil;
  self.height = nil;
  self.weight = nil;
}
@end
