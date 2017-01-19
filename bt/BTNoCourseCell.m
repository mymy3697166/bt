//
//  BTNoCourseCell.m
//  bt
//
//  Created by zjz on 17/1/18.
//  Copyright © 2017年 selfdoctor. All rights reserved.
//

#import "BTNoCourseCell.h"
#import "BTCommon.h"

@implementation BTNoCourseCell {

  __weak IBOutlet UIImageView *ivCourseImage;
  __weak IBOutlet UILabel *labCourseName;
  __weak IBOutlet UILabel *labCourseCoach;
  __weak IBOutlet UILabel *labDuration;
  __weak IBOutlet UIButton *btnMore;
}

- (void)awakeFromNib {
  [super awakeFromNib];
  btnMore.layer.cornerRadius = 5;
  btnMore.layer.borderWidth = 1;
  btnMore.layer.borderColor = [UIColor lightGrayColor].CGColor;
}

- (void)setData:(NSDictionary *)data {
  if (!data) return;
  [ivCourseImage loadURL:[URL_IMAGEPATH stringByAppendingString:data[@"course_cover"]]];
  labCourseName.text = data[@"course_name"];
  labCourseCoach.text = [@"课程教练：" stringByAppendingString:data[@"course_coach_name"]];
  NSArray *plans = data[@"course_plans"];
  labDuration.text = [NSString stringWithFormat:@"时需：%ld天", (long)plans.count];
}

- (IBAction)moreClick:(UIButton *)sender {
  
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
}

@end
