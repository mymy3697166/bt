//
//  BTDynamicCell.m
//  bt
//
//  Created by zjz on 2017/1/22.
//  Copyright © 2017年 selfdoctor. All rights reserved.
//

#import "BTDynamicCell.h"
#import "BTCommon.h"

@implementation BTDynamicCell {
  __weak IBOutlet UIImageView *ivAvatar;
  __weak IBOutlet UILabel *labName;
  __weak IBOutlet UILabel *labTime;
  __weak IBOutlet UILabel *labContent;
  __weak IBOutlet UIView *vImages;
  __weak IBOutlet NSLayoutConstraint *lcIvImagesHeight;
  __weak IBOutlet UILabel *labPlanCount;
  __weak IBOutlet UIButton *btnPraise;
  __weak IBOutlet UIButton *btnComment;
}

- (void)awakeFromNib {
  ivAvatar.layer.cornerRadius = 24;
  [super awakeFromNib];
}

- (void)setData:(NSDictionary *)data {
  if (data == nil) return;
  _data = data;
  [ivAvatar loadURL:[URL_AVATARPATH stringByAppendingString:data[@"creator_avatar"]]];
  labName.text = data[@"creator_name"];
  labContent.text = data[@"description"];
  
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
}
@end
