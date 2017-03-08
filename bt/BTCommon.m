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
    [hud hideAnimated:YES afterDelay:1];
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

- (NSDictionary *)syncPost:(NSString *)url forms:(NSDictionary *)forms error:(NSError **)error {
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
  request.HTTPMethod = @"POST";
  request.HTTPShouldHandleCookies = NO;
  request.timeoutInterval = 10;
  [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
  if (U && U.token != nil) [request setValue:U.token forHTTPHeaderField:@"mtoken"];
  else [request setValue:@"BBA8A2567B5095FEF4E316F532903571" forHTTPHeaderField:@"mtoken"];
  if (forms) request.HTTPBody = [NSJSONSerialization dataWithJSONObject:forms options:kNilOptions error:error];
  if (error) return nil;
  NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:error];
  if (error) return nil;
  NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:error];
  if (error) return nil;
  return json;
}

- (void)asyncPost:(NSString *)url forms:(NSDictionary *)forms completion:(void (^)(NSDictionary *, NSError *))completion {
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
  request.HTTPMethod = @"POST";
  request.HTTPShouldHandleCookies = NO;
  request.timeoutInterval = 10;
  [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
  if (U && U.token != nil) [request setValue:U.token forHTTPHeaderField:@"mtoken"];
  else [request setValue:@"BBA8A2567B5095FEF4E316F532903571" forHTTPHeaderField:@"mtoken"];
  NSError *error;
  if (forms) {
    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:forms options:kNilOptions error:&error];
  }
  if (error) {
    if ([NSThread isMainThread]) completion(nil, error);
    else dispatch_async(dispatch_get_main_queue(), ^{completion(nil, error);});
    return;
  }
  NSURLSession *session = [NSURLSession sharedSession];
  NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    if (error) {
      if ([NSThread isMainThread]) completion(nil, error);
      else dispatch_async(dispatch_get_main_queue(), ^{completion(nil, error);});
      return;
    }
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    if (error) {
      if ([NSThread isMainThread]) completion(nil, error);
      else dispatch_async(dispatch_get_main_queue(), ^{completion(nil, error);});
      return;
    }
    if ([NSThread isMainThread]) completion(json, nil);
    else dispatch_async(dispatch_get_main_queue(), ^{completion(json, nil);});
  }];
  [task resume];
}

- (void)requestQueue:(void(^)())block {
  dispatch_queue_t queue = dispatch_queue_create("requestQueue", nil);
  dispatch_async(queue, block);
}

- (NSInteger)getInfoFromDate:(NSDate *)date byFormat:(NSString *)format {
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  [formatter setDateFormat:format];
  return [[formatter stringFromDate:date] integerValue];
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

- (void)cacheImage:(NSString *)url completion:(void(^)(UIImage *image))completion {
  NSFileManager *fm = [NSFileManager defaultManager];
  NSString *fn = [NSString stringWithFormat:@"%@.jpg", [url md5]];
  NSString *docPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
  NSString *imagesPath = [docPath stringByAppendingPathComponent:@"images"];
  NSString *fp = [imagesPath stringByAppendingPathComponent:fn];
  if ([fm fileExistsAtPath:fp] && completion) {
    completion([UIImage imageWithContentsOfFile:fp]);
    return;
  }
  if (![fm fileExistsAtPath:imagesPath]) [fm createDirectoryAtPath:imagesPath withIntermediateDirectories:YES attributes:nil error:nil];
  dispatch_async(dispatch_queue_create(nil, nil), ^{
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    if (data.length > 0) [fm createFileAtPath:fp contents:data attributes:nil];
    dispatch_async(dispatch_get_main_queue(), ^{
      completion([UIImage imageWithContentsOfFile:fp]);
    });
  });
}

- (float)bmiWithHeight:(float)height andWeight:(float)weight {
  float h = height / 100;
  float hs = h * h;
  return weight / hs;
}
@end
