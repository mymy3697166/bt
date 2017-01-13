//
//  BTUser.h
//  bt
//
//  Created by zjz on 2017/1/9.
//  Copyright © 2017年 selfdoctor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTUser : NSObject
@property (strong, nonatomic) NSNumber *uid;
@property (strong, nonatomic) NSString *token;
@property (strong, nonatomic) NSString *nickname;
@property (strong, nonatomic) NSString *avatar;
@property (strong, nonatomic) NSString *gender;
@property (strong, nonatomic) NSNumber *weight;
@property (strong, nonatomic) NSNumber *height;
@end
