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

#ifdef DEBUG
#define URL_BASE @"http://192.168.0.207:3000/"
#define URL_PATH @"http://192.168.0.207:3000/upload/"
#else
#define URL_BASE @"http://test.renjk.com/"
#define URL_PATH @"http://testassets.renjk.com/"
#endif
#define URL_TEST [URL_BASE stringByAppendingString:@"api_v2/mem/test"]
#define URL_AVATARPATH [URL_PATH stringByAppendingString:@"mem/"]
#define URL_IMAGEPATH [URL_PATH stringByAppendingString:@"health/"]
#define URL_LOGIN [URL_BASE stringByAppendingString:@"api_v2/mem/login"]
#define URL_REGISTERCODE [URL_BASE stringByAppendingString:@"api/sms/register_code"]
#define URL_VALIDATECODE [URL_BASE stringByAppendingString:@"api/sms/validate_code"]
#define URL_REGISTER [URL_BASE stringByAppendingString:@"api_v2/mem/register"]
#define URL_UPLOADAVATAR [URL_BASE stringByAppendingString:@"upload_image/mem"]
#define URL_UPLOADIMAGE [URL_BASE stringByAppendingString:@"upload_image/health"]
#define URL_UPDATEUSERINFO [URL_BASE stringByAppendingString:@"api_v2/mem/update_mem_info"]
#define URL_UPDATEHEIGHT [URL_BASE stringByAppendingString:@"api_v2/mem/update_height"]
#define URL_UPDATEWEIGHT [URL_BASE stringByAppendingString:@"api_v2/mem/update_weight"]
#define URL_FETCHTAGS [URL_BASE stringByAppendingString:@"api_v2/health_course/fetch_tags"]

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
/// 压缩社区图片
- (NSData *)compressImage:(UIImage *)image;
/// 压缩用户头像
- (NSData *)compressAvatar:(UIImage *)image;
/// NSData数据转Base64字符串
- (NSString *)dataToBase64String:(NSData *)data;
/// MD5加密
- (NSString *)md5:(NSString *)source;
/// 缓存图片
- (void)cacheImage:(NSString *)url completion:(void(^)(UIImage *image))completion;
@end

