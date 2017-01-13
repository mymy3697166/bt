//
//  BTWeightPickerView.h
//  bt
//
//  Created by zjz on 17/1/12.
//  Copyright © 2017年 selfdoctor. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BTWeightPickerViewDelegate <NSObject>
- (void)weightPickerViewOnConfirm:(float)weight;
@end

@interface BTWeightPickerView : UIView <UIPickerViewDelegate, UIPickerViewDataSource>
@property (strong, nonatomic) id<BTWeightPickerViewDelegate> weightPickerViewDelegate;
- (void)show;
- (void)showWithWeight:(float)weight;
@end
