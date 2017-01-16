//
//  NSString+Extension.h
//  bt
//
//  Created by zjz on 2017/1/16.
//  Copyright © 2017年 selfdoctor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(Extension)
- (NSDate *)toDateWithFormat:(NSString *)format;
- (NSString *)md5;
- (BOOL)testByRegular:(NSString *)regular;
@end
