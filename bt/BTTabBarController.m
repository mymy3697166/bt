//
//  BTTabBarVc.m
//  bt
//
//  Created by zjz on 17/1/6.
//  Copyright © 2017年 selfdoctor. All rights reserved.
//

#import "BTTabBarController.h"
#import "BTLoginNavigationController.h"

@interface BTTabBarController ()

@end

@implementation BTTabBarController
- (void)viewDidLoad {
  [super viewDidLoad];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqualToString:@"tab_login"] && [sender isEqualToString:@"tags"]) {
    BTLoginNavigationController *lnc = segue.destinationViewController;
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"BTTagViewController"];
    vc.navigationItem.hidesBackButton = YES;
    [lnc pushViewController:vc animated:NO];
  }
}
@end
