//
//  ViewController.m
//  bt
//
//  Created by zjz on 17/1/6.
//  Copyright © 2017年 selfdoctor. All rights reserved.
//

#import "ViewController.h"
#import "BTLoginNavigationController.h"
#import "BTInfoViewController.h"
#import "BTCommon.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  BTLoginNavigationController *lnc = [self.storyboard instantiateViewControllerWithIdentifier:@"BTLoginNavigationController"];
  BTInfoViewController *ivc = [self.storyboard instantiateViewControllerWithIdentifier:@"BTInfoViewController"];
  [lnc pushViewController:ivc animated:NO];
  [self presentViewController:lnc animated:YES completion:nil];
}
@end
