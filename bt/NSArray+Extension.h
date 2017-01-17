//
//  NSArray+Extension.h
//  bt
//
//  Created by zjz on 2017/1/17.
//  Copyright © 2017年 selfdoctor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray(Extension)
- (id)find:(BOOL(^)(id))block;
@end
