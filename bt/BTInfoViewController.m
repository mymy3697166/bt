//
//  BTInfoViewController.m
//  bt
//
//  Created by zjz on 2017/1/10.
//  Copyright © 2017年 selfdoctor. All rights reserved.
//

#import "BTInfoViewController.h"
#import "BTDatePickerView.h"
#import "BTHeightPickerView.h"
#import "BTWeightPickerView.h"

@interface BTInfoViewController () <BTDatePickerViewDelegate, BTHeightPickerViewDelegate, BTWeightPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
  __weak IBOutlet UIButton *btnAvatar;
  __weak IBOutlet UIButton *btnGenderF;
  __weak IBOutlet UIButton *btnGenderM;
  __weak IBOutlet UITextField *tbDob;
  __weak IBOutlet UITextField *tbNickname;
  __weak IBOutlet UITextField *tbHeight;
  __weak IBOutlet UITextField *tbWeight;
  
  NSString *gender;
  NSString *avatar;
  UIAlertController *alert;
  UIImagePickerController *ipc;
}
@end

@implementation BTInfoViewController
- (void)viewDidLoad {
  [super viewDidLoad];
  gender = @"F";
  [self initUI];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  alert = [UIAlertController alertControllerWithTitle:@"选择头像" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
  ipc = [[UIImagePickerController alloc] init];
  ipc.allowsEditing = YES;
  ipc.delegate = self;
  UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:ipc animated:YES completion:nil];
  }];
  UIAlertAction *albumAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    ipc.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentViewController:ipc animated:YES completion:nil];
  }];
  UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
  [alert addAction:cameraAction];
  [alert addAction:albumAction];
  [alert addAction:cancelAction];
}

- (void)initUI {
  self.navigationItem.hidesBackButton = YES;
  [self.view layoutIfNeeded];
  btnAvatar.layer.masksToBounds = YES;
  btnAvatar.layer.cornerRadius = btnAvatar.bounds.size.width / 2;
  btnGenderF.layer.cornerRadius = 15;
  btnGenderF.layer.borderWidth = 1;
  btnGenderF.layer.borderColor = RGB(236, 82, 72).CGColor;
  btnGenderM.layer.cornerRadius = 15;
  btnGenderM.layer.borderWidth = 1;
  btnGenderM.layer.borderColor = RGB(170, 170, 170).CGColor;
}

- (IBAction)genderFClick:(UIButton *)sender {
  btnGenderF.titleLabel.textColor = RGB(236, 82, 72);
  [btnGenderF setTitleColor:RGB(236, 82, 72) forState:UIControlStateNormal];
  btnGenderF.layer.borderColor = RGB(236, 82, 72).CGColor;

  btnGenderM.titleLabel.textColor = RGB(170, 170, 170);
  [btnGenderM setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
  btnGenderM.layer.borderColor = RGB(170, 170, 170).CGColor;
  
  gender = @"F";
}

- (IBAction)genderMClick:(UIButton *)sender {
  btnGenderM.titleLabel.textColor = RGB(0, 178, 255);
  [btnGenderM setTitleColor:RGB(0, 178, 255) forState:UIControlStateNormal];
  btnGenderM.layer.borderColor = RGB(0, 178, 255).CGColor;
  
  btnGenderF.titleLabel.textColor = RGB(170, 170, 170);
  [btnGenderF setTitleColor:RGB(170, 170, 170) forState:UIControlStateNormal];
  btnGenderF.layer.borderColor = RGB(170, 170, 170).CGColor;
  
  gender = @"M";
}

- (IBAction)avatarClick:(UIButton *)sender {
  [self presentViewController:alert animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
  UIImage *image = info[UIImagePickerControllerEditedImage];
  NSData *data = [Common compressAvatar:image];
  [Common showLoading];
  [Common asyncPost:URL_UPLOADAVATAR forms:@{@"images": @[[data toBase64String]]} completion:^(NSDictionary *data, NSError *error) {
    [Common hideLoading];
    if (error) {
      [self showError:error];
      return;
    }
    avatar = data[@"data"][0];
    [btnAvatar setBackgroundImage:image forState:UIControlStateNormal];
    [Common cacheImage:[URL_AVATARPATH stringByAppendingString:avatar] completion:nil];
  }];
  [ipc dismissViewControllerAnimated:YES completion:nil];
  
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
  [ipc dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)dobClick:(UITapGestureRecognizer *)sender {
  BTDatePickerView *dpv = [[BTDatePickerView alloc] init];
  dpv.datePickerViewDelegate = self;
  if ([tbDob.text isEqualToString:@""]) [dpv show];
  else {
    NSDate *date = [tbDob.text toDateWithFormat:@"yyyy年MM月dd日"];
    [dpv showWithDate:date];
  }
}

- (IBAction)heightClick:(UITapGestureRecognizer *)sender {
  BTHeightPickerView *hpv = [[BTHeightPickerView alloc] init];
  hpv.heightPickerViewDelegate = self;
  if ([tbHeight.text isEqualToString:@""]) [hpv show];
  else [hpv showWithHeight:[tbHeight.text intValue]];
}

- (IBAction)weightClick:(UITapGestureRecognizer *)sender {
  BTWeightPickerView *wpv = [[BTWeightPickerView alloc] init];
  wpv.weightPickerViewDelegate = self;
  if ([tbWeight.text isEqualToString:@""]) [wpv show];
  else [wpv showWithWeight:[tbWeight.text floatValue]];
}

- (void)datePickerViewOnConfirm:(NSDate *)date {
  tbDob.text = [date toStringWithFormat:@"yyyy年MM月dd日"];
}

- (void)heightPickerViewOnConfirm:(int)height {
  tbHeight.text = [NSString stringWithFormat:@"%d", height];
}

- (void)weightPickerViewOnConfirm:(float)weight {
  tbWeight.text = [NSString stringWithFormat:@"%.1f", weight];
}

- (IBAction)bgClick:(UITapGestureRecognizer *)sender {
  [tbNickname resignFirstResponder];
}

- (IBAction)nextClick:(UIBarButtonItem *)sender {
  if (!avatar || [avatar isEqualToString:@""]) {
    [Common info:@"请上传头像"];
    return;
  }
  if ([tbNickname.text isEqualToString:@""]) {
    [Common info:@"请输入昵称"];
    return;
  }
  if ([tbDob.text isEqualToString:@""]) {
    [Common info:@"请输入生日"];
    return;
  }
  if ([tbHeight.text isEqualToString:@""]) {
    [Common info:@"请输入身高"];
    return;
  }
  if ([tbWeight.text isEqualToString:@""]) {
    [Common info:@"请输入体重"];
    return;
  }
  
//  [Common showLoading];
//  [Common requestQueue:^{
//    NSDate *dob = [tbDob.text toDateWithFormat:@"yyyy年MM月dd日"];
//    NSString *dobString = [dob toStringWithFormat:@"yyyy-MM-dd"];
//    NSDictionary *params = @{@"avatar": avatar, @"nc": tbNickname.text, @"gender": gender, @"dob": dobString};
//    NSDictionary *data = [Common syncPost:URL_UPDATEUSERINFO forms:params];
//    if ([data[@"status"] isEqual:@1]) {
//      [Common info:data[@"description"]];
//      return;
//    }
//    data = [Common syncPost:URL_UPDATEHEIGHT forms:@{@"height": @([tbHeight.text intValue])}];
//    data = [Common syncPost:URL_UPDATEWEIGHT forms:@{@"weight": @([tbWeight.text intValue])}];
//    [Common hideLoading];
//    U.avatar = avatar;
//    U.nickname = tbNickname.text;
//    U.gender = gender;
//    U.height = @([tbHeight.text intValue]);
//    U.weight = @([tbWeight.text floatValue]);
//    dispatch_async(dispatch_get_main_queue(), ^{
//      [self performSegueWithIdentifier:@"info_tag" sender:nil];
//    });
//  }];
}
@end
