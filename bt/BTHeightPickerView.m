//
//  BTHeightPickerView.m
//  bt
//
//  Created by zjz on 17/1/12.
//  Copyright © 2017年 selfdoctor. All rights reserved.
//

#import "BTHeightPickerView.h"
#import "BTCommon.h"

@implementation BTHeightPickerView {
  __weak IBOutlet UIPickerView *pvPicker;
  UIView *bgView;
  UIWindow *window;
}

- (instancetype)init {
  NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"BTHeightPickerView" owner:self options:nil];
  self = (BTHeightPickerView *)views[0];
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
  
  [pvPicker selectRow:90 inComponent:0 animated:NO];
}

- (void)showWithHeight:(int)height {
  [self show];
  [pvPicker selectRow:height - 80 inComponent:0 animated:NO];
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
  return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
  return 150;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
  if (view) return view;
  UILabel *label = [[UILabel alloc] init];
  label.textAlignment = NSTextAlignmentCenter;
  label.text = [NSString stringWithFormat:@"%ld", (long)(row + 80)];
  return label;
}

- (void)bgClick {
  [self hide];
}

- (IBAction)cancelClick:(UIButton *)sender {
  [self hide];
}

- (IBAction)confirmClick:(UIButton *)sender {
  if (self.heightPickerViewDelegate) {
    NSInteger height = [pvPicker selectedRowInComponent:0];
    [self.heightPickerViewDelegate heightPickerViewOnConfirm:(int)(height + 80)];
  }
  [self hide];
}
@end
