//
//  BTInfoViewController.m
//  bt
//
//  Created by zjz on 2017/1/10.
//  Copyright © 2017年 selfdoctor. All rights reserved.
//

#import "BTInfoViewController.h"

@interface BTInfoViewController () {
  __weak IBOutlet UIView *avatarBgView;
  
  __weak IBOutlet UIView *genderBgFView;
  __weak IBOutlet UIView *genderFView;
  __weak IBOutlet UIButton *btnGenderF;
  
  __weak IBOutlet UIView *genderBgMView;
  __weak IBOutlet UIView *genderMView;
  __weak IBOutlet UIButton *btnGenderM;
  
  NSString *gender;
}
@end

@implementation BTInfoViewController
- (void)viewDidLoad {
  [super viewDidLoad];
  [self initUI];
  gender = @"F";
}

- (void)initUI {
  avatarBgView.clipsToBounds = YES;
  avatarBgView.layer.cornerRadius = avatarBgView.bounds.size.width / 2;
  
  genderBgFView.clipsToBounds = YES;
  genderBgFView.layer.cornerRadius = 16;
  genderFView.clipsToBounds = YES;
  genderFView.layer.cornerRadius = 15;
  
  genderBgMView.clipsToBounds = YES;
  genderBgMView.layer.cornerRadius = 16;
  genderMView.clipsToBounds = YES;
  genderMView.layer.cornerRadius = 15;
}

- (IBAction)genderFClick:(UIButton *)sender {
  btnGenderF.titleLabel.textColor = RGB(236, 82, 72);
  [btnGenderF setTitleColor:RGB(236, 82, 72) forState:UIControlStateNormal];
  genderBgFView.backgroundColor = RGB(236, 82, 72);
  
  btnGenderM.titleLabel.textColor = [UIColor lightGrayColor];
  [btnGenderM setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
  genderBgMView.backgroundColor = [UIColor lightGrayColor];
  
  gender = @"F";
}

- (IBAction)genderMClick:(UIButton *)sender {
  btnGenderM.titleLabel.textColor = RGB(0, 178, 255);
  [btnGenderM setTitleColor:RGB(0, 178, 255) forState:UIControlStateNormal];
  genderBgMView.backgroundColor = RGB(0, 178, 255);
  
  btnGenderF.titleLabel.textColor = [UIColor lightGrayColor];
  [btnGenderF setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
  genderBgFView.backgroundColor = [UIColor lightGrayColor];
  
  gender = @"M";
}

- (IBAction)dobClick:(UITapGestureRecognizer *)sender {
  NSLog(@"asdf");
}

- (IBAction)nextClick:(id)sender {
  
}

- (IBAction)backClick:(UIBarButtonItem *)sender {
  [self.navigationController popViewControllerAnimated:YES];
}

@end
