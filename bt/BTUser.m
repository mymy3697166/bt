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

- (NSNumber *)uid {return [ud objectForKey:@"uid"];}
- (void)setUid:(NSNumber *)uid {[ud setObject:uid forKey:@"uid"];}
@end
