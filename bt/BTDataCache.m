//
//  BTDataCache.m
//  bt
//
//  Created by zjz on 2017/3/9.
//  Copyright © 2017年 selfdoctor. All rights reserved.
//

#import "BTDataCache.h"
#import "BTCommon.h"

@implementation BTDataCache
+ (NSString *)primaryKey {return @"key";}

+ (id)getValueForKey:(NSString *)key {
  RLMResults *results = [BTDataCache objectsWhere:[NSString stringWithFormat:@"key='%@'", key]];
  if (results.count == 0) return nil;
  NSData *valueData = [results.firstObject[@"value"] dataUsingEncoding:NSUTF8StringEncoding];
  id value = [NSJSONSerialization JSONObjectWithData:valueData options:NSJSONReadingAllowFragments error:nil];
  return value;
}

+ (void)setValue:(id)value forKey:(NSString *)key {
  BTDataCache *dataCache = [[BTDataCache alloc] init];
  dataCache.key = key;
  NSData *valueData = [NSJSONSerialization dataWithJSONObject:value options:kNilOptions error:nil];
  dataCache.value = [[NSString alloc] initWithData:valueData encoding:NSUTF8StringEncoding];
  [Realm transactionWithBlock:^{
    [Realm addOrUpdateObject:dataCache];
  }];
}
@end
