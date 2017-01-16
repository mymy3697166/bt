//
//  NSString+Extension.m
//  bt
//
//  Created by zjz on 2017/1/16.
//  Copyright © 2017年 selfdoctor. All rights reserved.
//

#import "NSString+Extension.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString(Extension)
- (NSDate *)toDateWithFormat:(NSString *)format {
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  [formatter setDateFormat:format];
  return [formatter dateFromString:self];
}

- (NSString *)md5 {
  const char *cStr = [self UTF8String];
  unsigned char result[CC_MD5_DIGEST_LENGTH];
  CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
  NSMutableString *res = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
  for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
    [res appendFormat:@"%02X", result[i]];
  }
  return res;
}

- (BOOL)testByRegular:(NSString *)regular {
  NSRegularExpression *reg = [[NSRegularExpression alloc] initWithPattern:regular options:NSRegularExpressionCaseInsensitive error:nil];
  NSRange range = NSMakeRange(0, [self lengthOfBytesUsingEncoding:kCFStringEncodingUTF8]);
  return [reg numberOfMatchesInString:self options:NSMatchingReportProgress range:range] > 0;
}
@end
