//
//  BTDataCache.h
//  bt
//
//  Created by zjz on 2017/3/9.
//  Copyright © 2017年 selfdoctor. All rights reserved.
//

#import <Realm/Realm.h>

@interface BTDataCache : RLMObject
@property NSString *key;
@property NSString *value;

+ (id)getValueForKey:(NSString *)key;
+ (void)setValue:(id)value forKey:(NSString *)key;
@end
