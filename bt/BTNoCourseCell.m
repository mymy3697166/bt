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
}

- (void)awakeFromNib {
  [super awakeFromNib];
}

- (void)setData:(NSDictionary *)data {
  [ivCourseImage loadURL:[URL_IMAGEPATH stringByAppendingString:data[@"course_cover"]]];
  labCourseName.text = data[@"course_name"];
  labCourseCoach.text = [@"课程教练：" stringByAppendingString:data[@"course_coach_name"]];
  NSArray *plans = data[@"course_plans"];
  __block int days = 0;
  [plans enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    if (![obj[@"id"] isEqual:@0]) days++;
  }];
  labDuration.text = [NSString stringWithFormat:@"时需：%d天", days];
}

- (IBAction)moreClick:(UIButton *)sender {
  
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
}

@end
