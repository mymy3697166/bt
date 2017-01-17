//
//  NSDate+Extension.m
//  bt
//
//  Created by zjz on 2017/1/16.
//  Copyright © 2017年 selfdoctor. All rights reserved.
//

#import "NSDate+Extension.h"
#import "NSString+Extension.h"

@implementation NSDate(Extension)
- (NSString *)toStringWithFormat:(NSString *)format {
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  [formatter setDateFormat:format];
  return [formatter stringFromDate:self];
}
- (NSInteger)year {
  NSCalendar *calendar = [NSCalendar currentCalendar];
  unsigned int flags = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay;
  NSDateComponents *dc = [calendar components:flags fromDate:self];
  return dc.year;
}
- (NSInteger)month {
  NSCalendar *calendar = [NSCalendar currentCalendar];
  unsigned int flags = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay;
  NSDateComponents *dc = [calendar components:flags fromDate:self];
  return dc.month;
}
- (NSInteger)day {
  NSCalendar *calendar = [NSCalendar currentCalendar];
  unsigned int flags = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay;
  NSDateComponents *dc = [calendar components:flags fromDate:self];
  return dc.day;
}
- (NSDate *)toDate {
  NSString *dateString = [NSString stringWithFormat:@"%ld-%2ld-%2ld", (long)[self year], (long)[self month], (long)[self day]];
  return [dateString toDateWithFormat:@"yyyy-MM-dd"];
}
@end
