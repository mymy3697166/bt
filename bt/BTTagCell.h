//
//  BTTagCell.h
//  bt
//
//  Created by zjz on 2017/1/13.
//  Copyright © 2017年 selfdoctor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BTTagCell : UITableViewCell
@property (strong, nonatomic) NSString *icon;
@property (strong, nonatomic) NSString *name;
@property (assign, nonatomic) BOOL isSelected;
@end
