//
//  BTCommon.m
//  bt
//
//  Created by zjz on 17/1/8.
//  Copyright © 2017年 selfdoctor. All rights reserved.
//

#import "BTCommon.h"

@implementation BTCommon
- (UIColor *)rgb:(int)red g:(int)green b:(int)blue {
  return [UIColor colorWithRed:red / 255.0 green:green / 255.0 blue:blue / 255.0 alpha:1];
}
@end
