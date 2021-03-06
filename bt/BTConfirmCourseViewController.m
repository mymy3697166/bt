//
//  BTConfirmCourseViewController.m
//  bt
//
//  Created by zjz on 17/1/14.
//  Copyright © 2017年 selfdoctor. All rights reserved.
//

#import "BTConfirmCourseViewController.h"

@interface BTConfirmCourseViewController () {
  __weak IBOutlet UILabel *labHeight;
  __weak IBOutlet UILabel *labWeight;
  __weak IBOutlet UILabel *labBMI;
  __weak IBOutlet UILabel *labBody;
  __weak IBOutlet UIImageView *ivCover;
  __weak IBOutlet UILabel *labName;
  __weak IBOutlet UILabel *labDays;
  __weak IBOutlet UIImageView *ivAvatar;
  __weak IBOutlet UILabel *labNickname;
  
  __weak IBOutlet UIButton *btnStart;
  
  NSNumber *courseId;
}
@end

@implementation BTConfirmCourseViewController
- (void)viewDidLoad {
  [super viewDidLoad];
  [self initUI];
  labHeight.text = [NSString stringWithFormat:@"%@cm", User.heights.lastObject[@"height"]];
  labWeight.text = [NSString stringWithFormat:@"%@kg", User.weights.lastObject[@"weight"]];
  float bmi = [Common bmiWithHeight:[User.heights.lastObject[@"height"] floatValue] andWeight:[User.weights.lastObject[@"weight"] floatValue]];
  labBMI.text = [NSString stringWithFormat:@"%1.f", bmi];
  NSString *body;
  if (bmi < 18.5) body = @"过轻";
  else if (bmi >= 18.5 && bmi < 25) body = @"正常";
  else if (bmi >= 25 && bmi < 28) body = @"过重";
  else if (bmi >= 28 && bmi < 32) body = @"肥胖";
  else body = @"非常肥胖";
  labBody.text = body;
  [Common asyncPost:URL_FETCHRECOMMENTCOURSE forms:@{@"tags": self.tags} completion:^(NSDictionary *data, NSError *error) {
    if (!data) return;
    if ([data[@"status"] isEqual:@0]) {
      [BTCourse updateCourseWithData:<#(NSDictionary *)#>]
      courseId = data[@"data"][@"id"];
      [ivCover loadURL:[NSString stringWithFormat:@"%@%@", URL_IMAGEPATH, data[@"data"][@"cover"]]];
      labName.text = data[@"data"][@"name"];
      labDays.text = [NSString stringWithFormat:@"所需时间：%@天", data[@"data"][@"days"]];
      [ivAvatar loadURL:[NSString stringWithFormat:@"%@%@", URL_AVATARPATH, data[@"data"][@"coach_avatar"]]];
      labNickname.text = [NSString stringWithFormat:@"课程教练：%@", data[@"data"][@"coach_name"]];
    } else {
      [Common info:data[@"description"]];
    }
  }];
}

- (void)initUI {
  ivAvatar.layer.masksToBounds = YES;
  ivAvatar.layer.cornerRadius = 16;
  
  btnStart.layer.cornerRadius = 20;
  btnStart.layer.borderWidth = 1;
  btnStart.layer.borderColor = RGB(170, 170, 170).CGColor;
}

- (IBAction)startClick:(UIButton *)sender {
  [Common showLoading];
  [User joinCourseWithBlock:^(NSError *error) {
    [Common hideLoading];
    if (error) {
      [self showError:error];
      return;
    }
    [Notif postNotificationName:@"N_LOGIN_SUCCESS" object:nil];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
  }];
}

- (IBAction)skipClick:(UIButton *)sender {
  [Notif postNotificationName:@"N_LOGIN_SUCCESS" object:nil];
  [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
@end
