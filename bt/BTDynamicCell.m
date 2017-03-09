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
  __weak IBOutlet NSLayoutConstraint *lcContentTop;
  __weak IBOutlet UIView *vImages;
  __weak IBOutlet NSLayoutConstraint *lcIvImagesHeight;
  __weak IBOutlet NSLayoutConstraint *lcIvImagesTop;
  __weak IBOutlet UILabel *labPlanCount;
  __weak IBOutlet NSLayoutConstraint *lcLabPlanCountTop;
  __weak IBOutlet NSLayoutConstraint *lcLabPlanCountHeight;
  __weak IBOutlet UIButton *btnPraise;
  __weak IBOutlet UIButton *btnComment;
}

- (void)awakeFromNib {
  ivAvatar.layer.cornerRadius = 24;
  labPlanCount.layer.cornerRadius = 4;
  [super awakeFromNib];
}

- (void)setData:(NSDictionary *)data {
  [ivAvatar loadURL:[URL_AVATARPATH stringByAppendingString:data[@"creator_avatar"]]];
  
  labName.text = data[@"creator_name"];
  
  if ([data[@"description"] null]) {
    lcContentTop.constant = 0;
  } else {
    lcContentTop.constant = 16;
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 4;
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:data[@"description"] attributes:@{NSParagraphStyleAttributeName: paragraphStyle}];
    labContent.attributedText = attrString;
  }
  
  if ([data[@"images"] null]) {
    lcIvImagesTop.constant = 0;
    lcIvImagesHeight.constant = 0;
  } else {
    lcIvImagesTop.constant = 16;
    lcIvImagesHeight.constant = 80;
  }
  
  if (![data[@"object_type"] null] && [data[@"object_type"] isEqualToString:@"ApmHealthPlan"]) {
    lcLabPlanCountTop.constant = 16;
    lcLabPlanCountHeight.constant = 24;
    labPlanCount.text = [NSString stringWithFormat:@"  完成%@第%@次  ", data[@"creator_name"], data[@"object"][@"times"]];
  } else {
    lcLabPlanCountTop.constant = 0;
    lcLabPlanCountHeight.constant = 0;
  }
  
  [btnPraise setTitle:[data[@"praise_count"] stringValue] forState:UIControlStateNormal];
  
  [btnComment setTitle:[data[@"comment_count"] stringValue] forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
}
@end
