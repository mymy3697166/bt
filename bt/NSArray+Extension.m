//
//  NSArray+Extension.m
//  bt
//
//  Created by zjz on 2017/1/17.
//  Copyright © 2017年 selfdoctor. All rights reserved.
//

#import "NSArray+Extension.h"

@implementation NSArray(Extension)
- (id)find:(BOOL(^)(id))block {
  for (id item in self) {
    if (block(item)) return item;
  }
  return nil;
}
@end
