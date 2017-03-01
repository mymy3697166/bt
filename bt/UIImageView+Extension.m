//
//  UIImageView+Extension.m
//  bt
//
//  Created by zjz on 2017/1/16.
//  Copyright © 2017年 selfdoctor. All rights reserved.
//

#import "UIImageView+Extension.h"

@implementation UIImageView(Extension)
- (void)loadURL:(NSString *)url {
  [Common cacheImage:url completion:^(UIImage *image) {
    self.image = image;
  }];
}

- (void)tintColor:(UIColor *)color {
  UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0);
  [color setFill];
  UIRectFill(self.bounds);
  [self.image drawInRect:self.bounds blendMode:kCGBlendModeDestinationIn alpha:1];
  
  UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  
  self.image = tintedImage;
}
@end
