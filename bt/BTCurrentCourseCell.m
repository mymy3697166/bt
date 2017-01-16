//
//  BTCurrentCourseCell.m
//  bt
//
//  Created by zjz on 17/1/16.
//  Copyright © 2017年 selfdoctor. All rights reserved.
//

#import "BTCurrentCourseCell.h"

@implementation BTCurrentCourseCell {
  __weak IBOutlet UIButton *btnCourse;
}

- (void)awakeFromNib {
  [super awakeFromNib];
  btnCourse.clipsToBounds = YES;
  btnCourse.layer.cornerRadius = 16;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
}

@end
