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
  UIView *dView = [[UIView alloc] initWithFrame:self.frame];
  dView.backgroundColor = [UIColor lightGrayColor];
  [self.superview addSubview:dView];
  [Common cacheImage:url completion:^(UIImage *image) {
    self.image = image;
    [UIView animateWithDuration:0.1 animations:^{
      dView.alpha = 0;
    } completion:^(BOOL finished) {
      [dView removeFromSuperview];
    }];
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
