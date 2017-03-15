//
//  BTViewController.m
//  bt
//
//  Created by zjz on 17/1/6.
//  Copyright © 2017年 selfdoctor. All rights reserved.
//

#import "BTViewController.h"

@interface BTViewController ()

@end

@implementation BTViewController
- (void)viewDidLoad {
  [super viewDidLoad];
  UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
  temporaryBarButtonItem.title = @"";
  self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
}

- (void)showError:(NSError *)error {
  if ([error.domain isEqualToString:@"BTLOGICERROR"]) {
    NSString *ep = error.userInfo[@"ep"];
    if ([ep isEqualToString:@"mtoken"]) {
      [User logout];
      [self.tabBarController performSegueWithIdentifier:@"tab_login" sender:nil];
    } else [Common info:error.userInfo[@"description"]];
    return;
  }
  [Common info:@"网络不给力，请稍后重试"];
}
@end
