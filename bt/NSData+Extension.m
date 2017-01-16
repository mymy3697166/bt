//
//  NSData+Extension.m
//  bt
//
//  Created by zjz on 2017/1/16.
//  Copyright © 2017年 selfdoctor. All rights reserved.
//

#import "NSData+Extension.h"

@implementation NSData(Extension)
- (NSString *)toBase64String {
  return [[self base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength] stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
}
@end
