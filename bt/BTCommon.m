//
//  BTCommon.m
//  bt
//
//  Created by zjz on 17/1/8.
//  Copyright © 2017年 selfdoctor. All rights reserved.
//

#import "BTCommon.h"

@implementation BTCommon
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
    [Message info:@"网络不给力，请稍后重试"];
    return nil;
  }
  NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
  if (error) {
    NSLog(@"%@", error);
    [Message info:@"网络不给力，请稍后重试"];
    return nil;
  }
  NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
  if (error) {
    NSLog(@"%@", error);
    [Message info:@"网络不给力，请稍后重试"];
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
    [Message info:@"网络不给力，请稍后重试"];
    return;
  }
  NSURLSession *session = [NSURLSession sharedSession];
  NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    if (error) {
      NSLog(@"%@", error);
      [Message info:@"网络不给力，请稍后重试"];
      return;
    }
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    if (error) {
      NSLog(@"%@", error);
      [Message info:@"网络不给力，请稍后重试"];
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
@end
