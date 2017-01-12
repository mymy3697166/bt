//
//  BTDatePickerView.h
//  bt
//
//  Created by zjz on 2017/1/11.
//  Copyright © 2017年 selfdoctor. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol BTDatePickerViewDelegate <NSObject>
- (void)datePickerViewOnConfirm:(NSDate *)date;
@end

@interface BTDatePickerView : UIView <UIPickerViewDelegate, UIPickerViewDataSource>
@property (strong, nonatomic) id<BTDatePickerViewDelegate> datePickerViewDelegate;
- (void)show;
- (void)showWithDate:(NSDate *)date;
- (void)hide;
@end
