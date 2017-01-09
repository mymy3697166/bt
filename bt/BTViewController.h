//
//  BTViewController.h
//  bt
//
//  Created by zjz on 17/1/6.
//  Copyright © 2017年 selfdoctor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTMessage.h"
#import "BTCommon.h"

@interface BTViewController : UIViewController
@property (strong, nonatomic) BTMessage *message;
@property (strong, nonatomic) BTCommon *common;
@end
