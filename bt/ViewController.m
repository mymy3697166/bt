//
//  ViewController.m
//  bt
//
//  Created by zjz on 17/1/6.
//  Copyright © 2017年 selfdoctor. All rights reserved.
//

#import "ViewController.h"
#import "BTLoginNavigationController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  BTLoginNavigationController *lnc = [self.storyboard instantiateViewControllerWithIdentifier:@"BTLoginNavigationController"];
  [self presentViewController:lnc animated:YES completion:nil];
}
@end
