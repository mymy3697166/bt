//
//  BTTagCell.m
//  bt
//
//  Created by zjz on 2017/1/13.
//  Copyright © 2017年 selfdoctor. All rights reserved.
//

#import "BTTagCell.h"
#import "BTCommon.h"

@implementation BTTagCell {
  __weak IBOutlet UIImageView *ivIcon;
  __weak IBOutlet UILabel *labName;
  __weak IBOutlet UIImageView *ivSelected;
}

- (void)setIcon:(NSString *)icon {
  _icon = icon;
  [Common cacheImage:[URL_IMAGEPATH stringByAppendingString:icon] completion:^(UIImage *image) {
    ivIcon.image = image;
  }];
}

- (void)setName:(NSString *)name {
  _name = name;
  labName.text = name;
}

- (void)setIsSelected:(BOOL)isSelected {
  _isSelected = isSelected;
  if (isSelected) ivSelected.image = [UIImage imageNamed:@"icon_selected_yes"];
  else ivSelected.image = [UIImage imageNamed:@"icon_selected_no"];
}

- (void)awakeFromNib {
  [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
}

@end
