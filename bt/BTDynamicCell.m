//
//  BTDynamicCell.m
//  bt
//
//  Created by zjz on 2017/1/22.
//  Copyright © 2017年 selfdoctor. All rights reserved.
//

#import "BTDynamicCell.h"
#import "BTCommon.h"

@interface ImageInfo : NSObject
@property (strong, nonatomic) NSString *url;
@property (assign) CGFloat x;
@property (assign) CGFloat y;
@property (assign) CGFloat width;
@property (assign) CGFloat height;

+ (instancetype)info:(NSString *)url x:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height;
@end

@implementation ImageInfo
+ (instancetype)info:(NSString *)url x:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height {
  ImageInfo *imageInfo = [[ImageInfo alloc] init];
  imageInfo.url = url;
  imageInfo.x = x;
  imageInfo.y = y;
  imageInfo.width = width;
  imageInfo.height = height;
  return imageInfo;
}
@end

@implementation BTDynamicCell {
  __weak IBOutlet UIImageView *ivAvatar;
  __weak IBOutlet UILabel *labName;
  __weak IBOutlet UILabel *labTime;
  __weak IBOutlet UILabel *labContent;
  __weak IBOutlet NSLayoutConstraint *lcContentTop;
  __weak IBOutlet UIView *vImages;
  __weak IBOutlet NSLayoutConstraint *lcIvImagesHeight;
  __weak IBOutlet NSLayoutConstraint *lcIvImagesTop;
  __weak IBOutlet UILabel *labPlanCount;
  __weak IBOutlet NSLayoutConstraint *lcLabPlanCountTop;
  __weak IBOutlet NSLayoutConstraint *lcLabPlanCountHeight;
  __weak IBOutlet UIButton *btnPraise;
  __weak IBOutlet UIButton *btnComment;
}

- (void)awakeFromNib {
  ivAvatar.layer.cornerRadius = 24;
  labPlanCount.layer.cornerRadius = 4;
  [super awakeFromNib];
}

- (void)setData:(NSDictionary *)data {
  [ivAvatar loadURL:[URL_AVATARPATH stringByAppendingString:data[@"creator_avatar"]]];
  
  labName.text = data[@"creator_name"];
  
  labTime.text = [self formatDate:data[@"created_at"]];
  
  if ([data[@"description"] null]) {
    lcContentTop.constant = 0;
  } else {
    lcContentTop.constant = 16;
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 4;
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:data[@"description"] attributes:@{NSParagraphStyleAttributeName: paragraphStyle}];
    labContent.attributedText = attrString;
  }
  
  if ([data[@"images"] null]) {
    lcIvImagesTop.constant = 0;
    lcIvImagesHeight.constant = 0;
    [vImages.subviews enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
      [obj removeFromSuperview];
    }];
  } else {
    lcIvImagesTop.constant = 16;
    lcIvImagesHeight.constant = [self imagesHeight:((NSArray *)data[@"images"]).count];
    NSArray *images = [self createImageInfoWithUrls:data[@"images"]];
    [vImages.subviews enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
      [obj removeFromSuperview];
    }];
    [images enumerateObjectsUsingBlock:^(ImageInfo *info, NSUInteger idx, BOOL *stop) {
      UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(info.x, info.y, info.width, info.height)];
      imageView.contentMode = UIViewContentModeScaleAspectFill;
      imageView.clipsToBounds = YES;
      imageView.layer.cornerRadius = 2;
      [imageView loadURL:[URL_IMAGEPATH stringByAppendingPathComponent:info.url]];
      [vImages addSubview:imageView];
    }];
  }
  
  if (![data[@"object_type"] null] && ([data[@"object_type"] isEqualToString:@"ApmHealthPlan"] || [data[@"object_type"] isEqualToString:@"MemAccount"])) {
    lcLabPlanCountTop.constant = 16;
    lcLabPlanCountHeight.constant = 24;
    if ([data[@"object_type"] isEqualToString:@"ApmHealthPlan"]) {
      labPlanCount.text = [NSString stringWithFormat:@"  完成%@第%@次  ", data[@"object"][@"name"], data[@"object"][@"times"]];
    } else {
      labPlanCount.text = @"  看看Ta的减肥历程  ";
    }
  } else {
    lcLabPlanCountTop.constant = 0;
    lcLabPlanCountHeight.constant = 0;
  }
  
  [btnPraise setTitle:[NSString stringWithFormat:@" %@", data[@"praise_count"]] forState:UIControlStateNormal];
  
  [btnComment setTitle:[NSString stringWithFormat:@" %@", data[@"comment_count"]] forState:UIControlStateNormal];
}

- (NSString *)formatDate:(NSNumber *)interval {
  NSTimeInterval pInterval = [interval integerValue];
  NSTimeInterval nInterval = [[NSDate date] timeIntervalSince1970];
  NSTimeInterval dInterval = nInterval - pInterval;
  if (dInterval < 60) return [NSString stringWithFormat:@"%f秒前", dInterval];
  if (dInterval >= 60 && dInterval < 3600) return [NSString stringWithFormat:@"%d分钟前", (int)(dInterval / 60)];
  if (dInterval >= 3600 && dInterval < 86400) return [NSString stringWithFormat:@"%d小时前", (int)(dInterval / 3600)];
  if (dInterval >= 86400 && dInterval < 345600) return [NSString stringWithFormat:@"%d天前", (int)(dInterval / 86400)];
  NSDate *date = [NSDate dateWithTimeIntervalSince1970:pInterval];
  return [date toStringWithFormat:@"MM-dd"];
}

- (NSArray *)createImageInfoWithUrls:(NSArray *)urls {
  NSInteger imageCount = urls.count;
  NSMutableArray *results = [NSMutableArray array];
  CGFloat totalWidth = [UIScreen mainScreen].bounds.size.width - 20;
  if (imageCount == 1)
    [results addObject:[ImageInfo info:urls[0] x:0 y:0 width:totalWidth height:totalWidth / 2]];
  if (imageCount == 2) {
    CGFloat width = totalWidth / 2 - 3;
    [results addObject:[ImageInfo info:urls[0] x:0 y:0 width:width height:width]];
    [results addObject:[ImageInfo info:urls[1] x:width + 6 y:0 width:width height:width]];
  }
  if (imageCount == 3) {
    CGFloat bWidth = totalWidth * 0.75 - 3;
    CGFloat sWidth = totalWidth * 0.25 - 3;
    [results addObject:[ImageInfo info:urls[0] x:0 y:0 width:bWidth height:totalWidth * 0.5]];
    [results addObject:[ImageInfo info:urls[1] x:totalWidth * 0.75 + 3 y:0 width:sWidth height:sWidth]];
    [results addObject:[ImageInfo info:urls[2] x:totalWidth * 0.75 + 3 y:sWidth + 6 width:sWidth height:sWidth]];
  }
  if (imageCount == 4) {
    CGFloat width = totalWidth / 2 - 3;
    [results addObject:[ImageInfo info:urls[0] x:0 y:0 width:width height:width / 2]];
    [results addObject:[ImageInfo info:urls[1] x:width + 6 y:0 width:width height:width / 2]];
    [results addObject:[ImageInfo info:urls[2] x:0 y:width / 2 + 6 width:width height:width / 2]];
    [results addObject:[ImageInfo info:urls[3] x:width + 6 y:width / 2 + 6 width:width height:width / 2]];
  }
  if (imageCount == 5 || imageCount == 8) {
    for (int i = 0; i < imageCount - 1; i++) {
      CGFloat width = (totalWidth - 12) / 3;
      CGFloat height = width * (imageCount == 8 ? 0.8 : 1);
      [results addObject:[ImageInfo info:urls[0] x:0 y:0 width:width height:height]];
    }
    CGFloat lWidth = totalWidth * 2 / 3 - 2;
    CGFloat lHeight = (totalWidth - 12) / 3 * (imageCount == 8 ? 0.8 : 1);
    [results addObject:[ImageInfo info:urls[0] x:(totalWidth - 12) / 3 + 6 y:(NSInteger)(imageCount / 3) * (lHeight + 6) width:lWidth height:lHeight]];
  }
  if (imageCount == 6 || imageCount == 9) {
    for (int i = 0; i < imageCount; i++) {
      CGFloat width = (totalWidth - 12) / 3;
      CGFloat height = width * (imageCount == 9 ? 0.8 : 1);
      [results addObject:[ImageInfo info:urls[0] x:i % 3 * (width + 6) y:(NSInteger)(i / 3) * (height + 6) width:width height:height]];
    }
  }
  if (imageCount == 7) {
    for (int i = 0; i < imageCount - 1; i++) {
      CGFloat width = (totalWidth - 12) / 3;
      CGFloat height = width * 0.8;
      [results addObject:[ImageInfo info:urls[0] x:i % 3 * (width + 6) y:(NSInteger)(i / 3) * (height + 6) width:width height:height]];
    }
    CGFloat lHeight = (totalWidth - 12) / 3 * 0.8;
    [results addObject:[ImageInfo info:urls[0] x:0 y:lHeight * 2 + 12 width:totalWidth height:lHeight]];
  }
  return results;
}

- (CGFloat)imagesHeight:(NSInteger)itemCount {
  CGFloat flw = [UIScreen mainScreen].bounds.size.width - 20;
  CGFloat flh;
  if (itemCount == 0) flh = 0;
  else if (itemCount == 1) flh = flw / 2;
  else if (itemCount == 2) flh = flw / 2 - 3;
  else if (itemCount == 3) flh = flw / 2;
  else if (itemCount == 4) flh = flw / 2 + 3;
  else if (itemCount == 5 || itemCount == 6) flh = (flw - 12) / 3 * 2 + 6;
  else flh = (flw - 12) * 0.8 + 12;
  return flh;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
}
@end
