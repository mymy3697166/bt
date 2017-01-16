//
//  BTDatePickerView.m
//  bt
//
//  Created by zjz on 2017/1/11.
//  Copyright © 2017年 selfdoctor. All rights reserved.
//

#import "BTDatePickerView.h"
#import "BTCommon.h"

@implementation BTDatePickerView {
  __weak IBOutlet UIPickerView *pvDatePicker;
  UIView *bgView;
  UIWindow *window;
  NSInteger days;
}

- (instancetype)init {
  NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"BTDatePickerView" owner:self options:nil];
  self = (BTDatePickerView *)views[0];
  days = 31;
  return self;
}

- (void)show {
  if (!window) window = [UIApplication sharedApplication].keyWindow;
  if (!bgView) {
    bgView = [[UIView alloc] initWithFrame:window.bounds];
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgClick)];
    [bgView addGestureRecognizer:tgr];
  }
  bgView.frame = window.bounds;
  bgView.backgroundColor = [UIColor blackColor];
  bgView.alpha = 0;
  [window addSubview:bgView];
  
  CGFloat width = window.bounds.size.width;
  CGFloat height = window.bounds.size.height * 2 / 5;
  CGFloat y = window.bounds.size.height - height;
  self.frame = CGRectMake(0, window.bounds.size.height, width, height);
  [window addSubview:self];

  [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
    bgView.alpha = 0.3;
    self.frame = CGRectMake(0, y, width, height);
  } completion:nil];
  
  [pvDatePicker selectRow:74 inComponent:0 animated:NO];
  [pvDatePicker selectRow:6 inComponent:1 animated:NO];
  [pvDatePicker selectRow:14 inComponent:2 animated:NO];
}

- (void)showWithDate:(NSDate *)date {
  [self show];
  NSInteger nowYear = [Common getInfoFromDate:[NSDate date] byFormat:@"yyyy"];
  NSInteger year = [Common getInfoFromDate:date byFormat:@"yyyy"];
  NSInteger month = [Common getInfoFromDate:date byFormat:@"MM"];
  NSInteger day = [Common getInfoFromDate:date byFormat:@"dd"];
  [pvDatePicker selectRow:99 - nowYear + year inComponent:0 animated:NO];
  [pvDatePicker selectRow:month - 1 inComponent:1 animated:NO];
  [pvDatePicker selectRow:day - 1 inComponent:2 animated:NO];
}

- (void)hide {
  [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
    bgView.alpha = 0;
    CGFloat width = window.bounds.size.width;
    CGFloat height = window.bounds.size.height * 2 / 5;
    self.frame = CGRectMake(0, window.bounds.size.height, width, height);
  } completion:^(BOOL finished) {
    [bgView removeFromSuperview];
    [self removeFromSuperview];
  }];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
  return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
  if (component == 0) return 100;
  else if (component == 1) return 12;
  else return days;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
  UILabel *label = [[UILabel alloc] init];
  label.textAlignment = NSTextAlignmentCenter;
  if (component == 0) {
    if (view) return view;
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy"];
    NSInteger year = [[format stringFromDate:[NSDate date]] integerValue];
    label.text = [NSString stringWithFormat:@"%ld年", (long)(year - 99 + row)];
  }
  else if (component == 1) {
    if (view) return view;
    label.text = [NSString stringWithFormat:@"%ld月", (long)(row + 1)];
  }
  else {
    label.text = [NSString stringWithFormat:@"%ld日", (long)(row + 1)];
  }
  return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
  if (component == 1) {
    if (row == 1) days = 28;
    else if (row == 3 || row == 5 || row == 8 || row == 10) days = 30;
    else days = 31;
    [pickerView reloadComponent:2];
  }
}

- (void)bgClick {
  [self hide];
}

- (IBAction)cancelClick:(UIButton *)sender {
  [self hide];
}

- (IBAction)confirmClick:(UIButton *)sender {
  if (self.datePickerViewDelegate) {
    NSInteger nowYear = [Common getInfoFromDate:[NSDate date] byFormat:@"yyyy"];
    NSInteger year = nowYear - 99 + [pvDatePicker selectedRowInComponent:0];
    NSInteger month = [pvDatePicker selectedRowInComponent:1] + 1;
    NSInteger day = [pvDatePicker selectedRowInComponent:2] + 1;
    NSDate *date = [[NSString stringWithFormat:@"%ld-%02ld-%02ld", (long)year, (long)month, (long)day] toDateWithFormat:@"yyyy-MM-dd"];
    [self.datePickerViewDelegate datePickerViewOnConfirm:date];
  }
  [self hide];
}
@end
