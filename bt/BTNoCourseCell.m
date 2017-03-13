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
  
  UIViewController *viewController;
}

- (void)awakeFromNib {
  [super awakeFromNib];
  btnMore.layer.cornerRadius = 5;
  btnMore.layer.borderWidth = 1;
  btnMore.layer.borderColor = [UIColor whiteColor].CGColor;
  
  UITapGestureRecognizer *rec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ivCourseImageClick:)];
  [ivCourseImage addGestureRecognizer:rec];
}

- (void)setData:(BTCourse *)course inController:(UIViewController *)controller {
  viewController = controller;
  [ivCourseImage loadURL:[URL_IMAGEPATH stringByAppendingString:course.cover]];
  labCourseName.text = course.name;
  labCourseCoach.text = [@"课程教练：" stringByAppendingString:course.coachName];
  labDuration.text = [NSString stringWithFormat:@"时需：%ld天", (long)course.plans.count];
}

- (void)ivCourseImageClick:(UITapGestureRecognizer *)sender {
  [viewController performSegueWithIdentifier:@"planhome_course" sender:nil];
}

- (IBAction)moreClick:(UIButton *)sender {
  
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
}

@end
