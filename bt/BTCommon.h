//
//  BTCommon.h
//  bt
//
//  Created by zjz on 17/1/8.
//  Copyright © 2017年 selfdoctor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BTCommon : NSObject
- (UIColor *)rgb:(int)red g:(int)green b:(int)blue;
- (void)post:(NSString *)url params:(NSDictionary *)params callback(void^(NSString *))callback;
- (void)post:(NSString *)url params:(NSDictionary *)params headers:(NSDictionary *)headers;
@end

#define URL_BASE "http://test.renjk.com/"
#define URL_LOGIN URL_BASE + "api_v2/mem/login"
