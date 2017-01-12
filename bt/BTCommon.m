//
//  BTCommon.m
//  bt
//
//  Created by zjz on 17/1/8.
//  Copyright © 2017年 selfdoctor. All rights reserved.
//

#import "BTCommon.h"
#import "MBProgressHUD.h"
#import <CommonCrypto/CommonDigest.h>

@implementation BTCommon
- (void)info:(NSString *)message {
  void(^exe)() = ^{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = message;
    hud.label.textColor = [UIColor whiteColor];
    hud.bezelView.color = [UIColor blackColor];
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:2];
  };
  if ([NSThread isMainThread]) exe();
  else dispatch_async(dispatch_get_main_queue(), exe);
}

- (void)showLoading {
  void(^exe)() = ^{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.activityIndicatorColor = [UIColor whiteColor];
    hud.bezelView.color = [UIColor blackColor];
    hud.removeFromSuperViewOnHide = YES;
  };
  if ([NSThread isMainThread]) exe();
  else dispatch_async(dispatch_get_main_queue(), exe);
}

- (void)hideLoading {
  void(^exe)() = ^{
    [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
  };
  if ([NSThread isMainThread]) exe();
  else dispatch_async(dispatch_get_main_queue(), exe);
}

- (NSDictionary *)syncPost:(NSString *)url forms:(NSDictionary *)forms {
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
  request.HTTPMethod = @"POST";
  request.HTTPShouldHandleCookies = NO;
  request.timeoutInterval = 10;
  [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
  if (User.token != nil) [request setValue:User.token forHTTPHeaderField:@"mtoken"];
  NSError *error;
  if (forms) {
    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:forms options:kNilOptions error:&error];
  }
  if (error) {
    NSLog(@"%@", error);
    [self info:@"网络不给力，请稍后重试"];
    return nil;
  }
  NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
  if (error) {
    NSLog(@"%@", error);
    [self info:@"网络不给力，请稍后重试"];
    return nil;
  }
  NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
  if (error) {
    NSLog(@"%@", error);
    [self info:@"网络不给力，请稍后重试"];
    return nil;
  }
  return json;
}

- (void)asyncPost:(NSString *)url forms:(NSDictionary *)forms completion:(void (^)(NSDictionary *))completion {
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
  request.HTTPMethod = @"POST";
  request.HTTPShouldHandleCookies = NO;
  request.timeoutInterval = 10;
  [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
  if (User.token != nil) [request setValue:User.token forHTTPHeaderField:@"mtoken"];
  NSError *error;
  if (forms) {
    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:forms options:kNilOptions error:&error];
  }
  if (error) {
    NSLog(@"%@", error);
    [self info:@"网络不给力，请稍后重试"];
    completion(nil);
    return;
  }
  NSURLSession *session = [NSURLSession sharedSession];
  NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    if (error) {
      NSLog(@"%@", error);
      [self info:@"网络不给力，请稍后重试"];
      completion(nil);
      return;
    }
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    if (error) {
      NSLog(@"%@", error);
      [self info:@"网络不给力，请稍后重试"];
      completion(nil);
      return;
    }
    completion(json);
  }];
  [task resume];
}

- (void)requestQueue:(void(^)())block {
  dispatch_queue_t queue = dispatch_queue_create("requestQueue", nil);
  dispatch_async(queue, block);
}

- (BOOL)regularTest:(NSString *)regStr text:(NSString *)text {
  NSRegularExpression *reg = [[NSRegularExpression alloc] initWithPattern:regStr options:NSRegularExpressionCaseInsensitive error:nil];
  NSRange range = NSMakeRange(0, [text lengthOfBytesUsingEncoding:kCFStringEncodingUTF8]);
  return [reg numberOfMatchesInString:text options:NSMatchingReportProgress range:range] > 0;
}

- (NSInteger)getInfoFromDate:(NSDate *)date byFormat:(NSString *)format {
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  [formatter setDateFormat:format];
  return [[formatter stringFromDate:date] integerValue];
}

- (NSDate *)stringToDate:(NSString *)string byFormat:(NSString *)format {
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  [formatter setDateFormat:format];
  return [formatter dateFromString:string];
}

- (NSString *)dateToString:(NSDate *)date byFormat:(NSString *)format {
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  [formatter setDateFormat:format];
  return [formatter stringFromDate:date];
}

- (NSData *)compressImage:(UIImage *)image {
  CGFloat w = image.size.width;
  CGFloat h = image.size.height;
  CGFloat nw = w;
  CGFloat nh = h;
  CGFloat len = 800 / [[UIScreen mainScreen] scale];
  if (nw > len) {
    nw = len;
    nh = h * nw / w;
  }
  UIGraphicsBeginImageContextWithOptions(CGSizeMake(nw, nh), NO, [[UIScreen mainScreen] scale]);
  [image drawInRect:CGRectMake(0, 0, nw, nh)];
  UIImage *nImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return UIImageJPEGRepresentation(nImage, 0.6);
}

- (NSData *)compressAvatar:(UIImage *)image {
  CGFloat len = 512 / [[UIScreen mainScreen] scale];
  UIGraphicsBeginImageContextWithOptions(CGSizeMake(len, len), NO, [[UIScreen mainScreen] scale]);
  [image drawInRect:CGRectMake(0, 0, len, len)];
  UIImage *nImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return UIImageJPEGRepresentation(nImage, 0.6);
}

- (NSString *)dataToBase64String:(NSData *)data {
  return [[data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength] stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
}

- (NSString *)md5:(NSString *)source {
  const char *cStr = [source UTF8String];
  unsigned char result[CC_MD5_DIGEST_LENGTH];
  CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
  NSMutableString *res = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
  for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
    [res appendFormat:@"%02X", result[i]];
  }
  return res;
}

- (void)cacheImage:(NSString *)url completion:(void(^)(UIImage *image))completion {
  dispatch_async(dispatch_queue_create(nil, nil), ^{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *fn = [NSString stringWithFormat:@"%@.jpg", [self md5:url]];
    NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *imagesPath = [docPath stringByAppendingPathComponent:@"images"];
    NSString *fp = [imagesPath stringByAppendingPathComponent:fn];
    if (![fm fileExistsAtPath:fp]) {
      if (![fm fileExistsAtPath:imagesPath]) {
        NSError *error;
        [fm createDirectoryAtPath:imagesPath withIntermediateDirectories:YES attributes:nil error:&error];
        NSLog(@"%@", error);
      }
      NSURL *URL = [NSURL URLWithString:url];
      NSData *data = [NSData dataWithContentsOfURL:URL];
      [fm createFileAtPath:fp contents:data attributes:nil];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
      completion([UIImage imageWithContentsOfFile:fp]);
    });
  });
}
@end
