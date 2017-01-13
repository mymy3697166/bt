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
- (void)setUid:(NSNumber *)uid {[ud setObject:uid forKey:@"USER-UID"];}

- (NSString *)token {return [ud objectForKey:@"USER-TOKEN"];}
- (void)setToken:(NSString *)token {[ud setObject:token forKey:@"USER-TOKEN"];}

- (NSString *)nickname {return [ud objectForKey:@"USER-NICKNAME"];}
- (void)setNickname:(NSString *)nickname {[ud setObject:nickname forKey:@"USER-NICKNAME"];}

- (NSString *)avatar {return [ud objectForKey:@"USER-AVATAR"];}
- (void)setAvatar:(NSString *)avatar {[ud setObject:avatar forKey:@"USER-AVATAR"];}

- (NSString *)gender {return [ud objectForKey:@"USER-AVATAR"];}
- (void)setGender:(NSString *)gender {[ud setObject:gender forKey:@"USER-AVATAR"];}

- (NSNumber *)weight {return [ud objectForKey:@"USER-WEIGHT"];}
- (void)setWeight:(NSNumber *)weight {[ud setObject:weight forKey:@"USER-WEIGHT"];}

- (NSNumber *)height {return [ud objectForKey:@"USER-HEIGHT"];}
- (void)setHeight:(NSNumber *)height {[ud setObject:height forKey:@"USER-HEIGHT"];}
@end
