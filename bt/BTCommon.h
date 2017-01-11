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
#define URL_VALIDATECODE [URL_BASE stringByAppendingString:@"api/sms/validate_code"]
#define URL_REGISTER [URL_BASE stringByAppendingString:@"api_v2/mem/register"]

@interface BTCommon : NSObject
/// 信息提示
- (void)info:(NSString *)message;
/// 显示加载状态
- (void)showLoading;
/// 隐藏加载状态
- (void)hideLoading;
/// 同步发送post请求
- (NSDictionary *)syncPost:(NSString *)url forms:(NSDictionary *)forms;
/// 异步发送post请求
- (void)asyncPost:(NSString *)url forms:(NSDictionary *)forms completion:(void(^)(NSDictionary *data))completion;
/// 开启请求队列
- (void)requestQueue:(void(^)())block;
/// 正则验证
- (BOOL)regularTest:(NSString *)reg text:(NSString *)text;
/// 从日期对象中获取年月日时分秒信息
- (NSInteger)getInfoFromDate:(NSDate *)date byFormat:(NSString *)format;
/// 字符串转日期
- (NSDate *)stringToDate:(NSString *)string byFormat:(NSString *)format;
/// 日期转字符串
- (NSString *)dateToString:(NSDate *)date byFormat:(NSString *)format;
@end

