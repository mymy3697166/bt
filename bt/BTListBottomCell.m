//
//  BTListBottomCellTableViewCell.m
//  bt
//
//  Created by zjz on 2017/3/10.
//  Copyright © 2017年 selfdoctor. All rights reserved.
//

#import "BTListBottomCell.h"

@implementation BTListBottomCell {
  __weak IBOutlet UIButton *btnAction;
  __weak IBOutlet NSLayoutConstraint *lcHeight;
  
  void(^btnActionClickBlock)();
}

- (void)awakeFromNib {
  [super awakeFromNib];
}

- (void)setHeight:(CGFloat)height {
  _height = height;
  lcHeight.constant = height;
}

- (void)setTitle:(NSString *)title block:(void(^)())block {
  [btnAction setTitle:title forState:UIControlStateNormal];
  btnActionClickBlock = block;
}

- (IBAction)btnActionClick:(id)sender {
  if (btnActionClickBlock) btnActionClickBlock();
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
}
@end
