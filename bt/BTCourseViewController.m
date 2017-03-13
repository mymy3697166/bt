//
//  BTCourseViewController.m
//  bt
//
//  Created by zjz on 2017/3/13.
//  Copyright © 2017年 selfdoctor. All rights reserved.
//

#import "BTCourseViewController.h"

@interface BTCourseViewController () {
  __weak IBOutlet UIImageView *ivCover;
  __weak IBOutlet UIImageView *ivCoachAvatar;
  __weak IBOutlet UILabel *labCoachName;
  __weak IBOutlet UILabel *labTime;
  __weak IBOutlet UIView *vMenu;
  __weak IBOutlet UIView *vMenuBg;
  __weak IBOutlet NSLayoutConstraint *lcMenuHeight;
  __weak IBOutlet UIButton *btnJoin;
}

@end

@implementation BTCourseViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  ivCoachAvatar.layer.cornerRadius = 16;
  vMenu.layer.cornerRadius = 3;
  vMenu.backgroundColor = RGBA(0, 0, 0, 0.7);
  
  self.title = Course.name;
  [ivCover loadURL: [URL_IMAGEPATH stringByAppendingPathComponent:Course.cover]];
  [ivCoachAvatar loadURL:[URL_AVATARPATH stringByAppendingPathComponent:Course.coachAvatar]];
  labCoachName.text = [NSString stringWithFormat:@"课程教练：%@", Course.coachName];
  RLMResults *results = [Course.plans objectsWhere:@"dataId!=0"];
  labTime.text = [NSString stringWithFormat:@"总%lu天/约%lu节", (unsigned long)Course.plans.count, (unsigned long)results.count];
}

- (void)refreshStatus {
  [btnJoin setTitle:([Course.isJoin isEqual:@1] ? @"退出课程" : @"加入课程") forState:UIControlStateNormal];
}

- (IBAction)btnMoreClick:(UIBarButtonItem *)sender {
  vMenuBg.hidden = !vMenuBg.hidden;
  lcMenuHeight.constant = lcMenuHeight.constant == 0 ? 80 : 0;
  [UIView animateWithDuration:0.25 animations:^{
    [self.view layoutIfNeeded];
  }];
}

- (IBAction)btnJoinClick:(UIButton *)sender {
  void(^successBlock)(NSError *) = ^(NSError *error) {
    [Common hideLoading];
    if (error) {
      [self showError:error];
      return;
    }
    [self refreshStatus];
    [self vMenuBgClick:nil];
  };
  [Common showLoading];
  if ([Course.isJoin isEqualToNumber:@0]) [User joinCourseWithBlock:successBlock];
  else [User quitCourseWithBlock:successBlock];
}

- (IBAction)btnShareClick:(UIButton *)sender {
  
}

- (IBAction)vMenuBgClick:(UITapGestureRecognizer *)sender {
  vMenuBg.hidden = YES;
  lcMenuHeight.constant = 0;
  [UIView animateWithDuration:0.25 animations:^{
    [self.view layoutIfNeeded];
  }];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}
@end
