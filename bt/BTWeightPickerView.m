//
//  BTWeightPickerView.m
//  bt
//
//  Created by zjz on 17/1/12.
//  Copyright © 2017年 selfdoctor. All rights reserved.
//

#import "BTWeightPickerView.h"

@implementation BTWeightPickerView {
  __weak IBOutlet UIPickerView *pvPicker;
  UIView *bgView;
  UIWindow *window;
}

- (instancetype)init {
  NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"BTWeightPickerView" owner:self options:nil];
  self = (BTWeightPickerView *)views[0];
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
  
  [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
    bgView.alpha = 0.3;
    self.frame = CGRectMake(0, y, width, height);
  } completion:nil];
  
  [pvPicker selectRow:45 inComponent:0 animated:NO];
}

- (void)showWithWeight:(float)weight {
  [self show];
  NSArray *arr = [[NSString stringWithFormat:@"%.1f", weight] componentsSeparatedByString:@"."];
  int z = [arr[0] intValue];
  int x = [arr[1] intValue];
  [pvPicker selectRow:z - 20 inComponent:0 animated:NO];
  [pvPicker selectRow:x inComponent:2 animated:NO];
}

- (void)hide {
  [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
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
  if (component == 0) return 180;
  if (component == 1) return 1;
  return 10;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
  if (view) return view;
  UILabel *label = [[UILabel alloc] init];
  if (component == 0) {
    label.textAlignment = NSTextAlignmentRight;
    label.text = [NSString stringWithFormat:@"%ld", (long)(row + 20)];
    return label;
  } else if (component == 1) {
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @".";
  } else {
    label.textAlignment = NSTextAlignmentLeft;
    label.text = [NSString stringWithFormat:@"%ld", (long)row];
  }
  return label;
}

- (void)bgClick {
  [self hide];
}

- (IBAction)cancelClick:(UIButton *)sender {
  [self hide];
}

- (IBAction)confirmClick:(UIButton *)sender {
  if (self.weightPickerViewDelegate) {
    NSInteger z = [pvPicker selectedRowInComponent:0];
    NSInteger x = [pvPicker selectedRowInComponent:2];
    float weight = [[NSString stringWithFormat:@"%ld.%ld", z + 20, x] floatValue];
    [self.weightPickerViewDelegate weightPickerViewOnConfirm:weight];
  }
  [self hide];
}
@end
