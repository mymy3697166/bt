//
//  BTInfoViewController.m
//  bt
//
//  Created by zjz on 2017/1/10.
//  Copyright © 2017年 selfdoctor. All rights reserved.
//

#import "BTInfoViewController.h"

@interface BTInfoViewController () {
  
  __weak IBOutlet UIView *genderBgFView;
  __weak IBOutlet UIView *genderFView;
}

@end

@implementation BTInfoViewController
- (void)viewDidLoad {
  [super viewDidLoad];
  genderBgFView.clipsToBounds = YES;
  genderBgFView.layer.cornerRadius = 20;
  genderFView.clipsToBounds = YES;
  genderFView.layer.cornerRadius = 19;
}
@end
