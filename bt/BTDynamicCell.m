//
//  BTDynamicCell.m
//  bt
//
//  Created by zjz on 2017/1/22.
//  Copyright © 2017年 selfdoctor. All rights reserved.
//

#import "BTDynamicCell.h"

@implementation BTDynamicCell {
  __weak IBOutlet UIImageView *ivAvatar;
  __weak IBOutlet UILabel *labName;
  __weak IBOutlet UILabel *labTime;
  __weak IBOutlet UILabel *labContent;
  __weak IBOutlet UIView *vImages;
  __weak IBOutlet NSLayoutConstraint *lcIvImagesHeight;
  __weak IBOutlet UILabel *labPlanCount;
  __weak IBOutlet UIButton *btnPraise;
}

- (void)awakeFromNib {
  [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
}
@end
