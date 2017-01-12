//
//  BTHeightPickerView.h
//  bt
//
//  Created by zjz on 17/1/12.
//  Copyright © 2017年 selfdoctor. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BTHeightPickerViewDelegate <NSObject>
- (void)heightPickerViewOnConfirm:(NSInteger)height;
@end

@interface BTHeightPickerView : UIView <UIPickerViewDelegate, UIPickerViewDataSource>
@property (strong, nonatomic) id<BTHeightPickerViewDelegate> heightPickerViewDelegate;
- (void)show;
- (void)showWithHeight:(NSInteger)height;
@end
