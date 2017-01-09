//
//  BTCommon.h
//  bt
//
//  Created by zjz on 17/1/8.
//  Copyright © 2017年 selfdoctor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BTUser.h"

#define Common [[BTCommon alloc] init]
#define User [[BTUser alloc] init]

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1]
#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

#define URL_BASE @"http://test.renjk.com/"
//#define URL_BASE @"http://192.168.0.207:3000/"
#define URL_TEST [URL_BASE stringByAppendingString:@"api_v2/mem/test"]
#define URL_LOGIN [URL_BASE stringByAppendingString:@"api_v2/mem/login"]
#define URL_REGISTERCODE [URL_BASE stringByAppendingString:@"api/sms/register_code"]

@interface BTCommon : NSObject
- (void)info:(NSString *)message;
- (void)startLoading;
- (void)endLoading;
- (NSDictionary *)syncPost:(NSString *)url forms:(NSDictionary *)forms;
- (void)asyncPost:(NSString *)url forms:(NSDictionary *)forms completion:(void(^)(NSDictionary *data))completion;
- (void)requestQueue:(void(^)())block;
@end

