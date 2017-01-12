//
//  BTUser.m
//  bt
//
//  Created by zjz on 2017/1/9.
//  Copyright © 2017年 selfdoctor. All rights reserved.
//

#import "BTUser.h"

@implementation BTUser {
  NSUserDefaults *ud;
}

- (instancetype)init {
  ud = [NSUserDefaults standardUserDefaults];
  return self;
}

- (NSNumber *)uid {return [ud objectForKey:@"USER-UID"];}
- (void)setUid:(NSNumber *)value {[ud setObject:value forKey:@"USER-UID"];}

- (NSString *)token {return [ud objectForKey:@"USER-TOKEN"];}
- (void)setToken:(NSString *)value {[ud setObject:value forKey:@"USER-TOKEN"];}

- (NSString *)nickname {return [ud objectForKey:@"USER-NICKNAME"];}
- (void)setNickname:(NSString *)value {[ud setObject:value forKey:@"USER-NICKNAME"];}

- (NSString *)avatar {return [ud objectForKey:@"USER-AVATAR"];}
- (void)setAvatar:(NSString *)value {[ud setObject:value forKey:@"USER-AVATAR"];}

- (NSNumber *)weight {return [ud objectForKey:@"USER-WEIGHT"];}
- (void)setWeight:(NSNumber *)value {[ud setObject:value forKey:@"USER-WEIGHT"];}

- (NSNumber *)height {return [ud objectForKey:@"USER-HEIGHT"];}
- (void)setHeight:(NSNumber *)value {[ud setObject:value forKey:@"USER-HEIGHT"];}
@end
