//
//  id+Extension.m
//  bt
//
//  Created by zjz on 2017/1/16.
//  Copyright © 2017年 selfdoctor. All rights reserved.
//

#import "NSObject+Extension.h"

@implementation NSObject(Extension)
- (BOOL)null {
  if (!self) return YES;
  if ([self isKindOfClass:[NSNull class]]) return YES;
  if ([self isKindOfClass:[NSString class]]) return [self isEqual:@""];
  if ([self isKindOfClass:[NSNumber class]]) return [self isEqual:@0];
  if ([self isKindOfClass:[NSArray class]]) return ((NSArray *)self).count == 0;
  if ([self isKindOfClass:[NSDictionary class]]) return ((NSDictionary *)self).allKeys.count == 0;
  return NO;
}
@end
