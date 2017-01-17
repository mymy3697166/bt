//
//  NSDate+Extension.h
//  bt
//
//  Created by zjz on 2017/1/16.
//  Copyright © 2017年 selfdoctor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate(Extension)
- (NSString *)toStringWithFormat:(NSString *)format;
- (NSInteger)year;
- (NSInteger)month;
- (NSInteger)day;
- (NSDate *)toDate;
@end
