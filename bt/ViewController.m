//
//  ViewController.m
//  bt
//
//  Created by zjz on 17/1/6.
//  Copyright © 2017年 selfdoctor. All rights reserved.
//

#import "ViewController.h"
#import "BTLoginNavigationController.h"
#import "BTTagViewController.h"
#import "BTInfoViewController.h"
#import "BTCommon.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  BTLoginNavigationController *lnc = [self.storyboard instantiateViewControllerWithIdentifier:@"BTLoginNavigationController"];
//  BTInfoViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"BTInfoViewController"];
  BTTagViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"BTTagViewController"];
  [self presentViewController:lnc animated:YES completion:nil];
  [lnc pushViewController:vc animated:NO];
//  UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
//  temporaryBarButtonItem.title = @"";
//  self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
}

//- (void)viewWillAppear:(BOOL)animated {
//  [self.navigationController setNavigationBarHidden:YES animated:animated];
//  [super viewWillAppear:animated];
//}
//
//- (void)viewWillDisappear:(BOOL)animated {
//  [self.navigationController setNavigationBarHidden:NO animated:animated];
//  [super viewWillDisappear:animated];
//}
@end
