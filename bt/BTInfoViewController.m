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
  __weak IBOutlet UIView *avatarBgView;
  __weak IBOutlet UIButton *btnAvatar;
  
  __weak IBOutlet UIView *genderBgFView;
  __weak IBOutlet UIView *genderFView;
  __weak IBOutlet UIButton *btnGenderF;
  
  __weak IBOutlet UIView *genderBgMView;
  __weak IBOutlet UIView *genderMView;
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
  avatarBgView.clipsToBounds = YES;
  avatarBgView.layer.cornerRadius = avatarBgView.bounds.size.width / 2;
  
  genderBgFView.clipsToBounds = YES;
  genderBgFView.layer.cornerRadius = 16;
  genderFView.clipsToBounds = YES;
  genderFView.layer.cornerRadius = 15;
  
  genderBgMView.clipsToBounds = YES;
  genderBgMView.layer.cornerRadius = 16;
  genderMView.clipsToBounds = YES;
  genderMView.layer.cornerRadius = 15;
}

- (IBAction)genderFClick:(UIButton *)sender {
  btnGenderF.titleLabel.textColor = RGB(236, 82, 72);
  [btnGenderF setTitleColor:RGB(236, 82, 72) forState:UIControlStateNormal];
  genderBgFView.backgroundColor = RGB(236, 82, 72);
  
  btnGenderM.titleLabel.textColor = [UIColor lightGrayColor];
  [btnGenderM setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
  genderBgMView.backgroundColor = [UIColor lightGrayColor];
  
  gender = @"F";
}

- (IBAction)genderMClick:(UIButton *)sender {
  btnGenderM.titleLabel.textColor = RGB(0, 178, 255);
  [btnGenderM setTitleColor:RGB(0, 178, 255) forState:UIControlStateNormal];
  genderBgMView.backgroundColor = RGB(0, 178, 255);
  
  btnGenderF.titleLabel.textColor = [UIColor lightGrayColor];
  [btnGenderF setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
  genderBgFView.backgroundColor = [UIColor lightGrayColor];
  
  gender = @"M";
}

- (IBAction)avatarClick:(UIButton *)sender {
  [self presentViewController:alert animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
  UIImage *image = info[UIImagePickerControllerEditedImage];
  NSData *data = [Common compressAvatar:image];
  [Common showLoading];
  [Common asyncPost:URL_UPLOADAVATAR forms:@{@"images": @[[Common dataToBase64String:data]]} completion:^(NSDictionary *data) {
    [Common hideLoading];
    if (!data) return;
    if ([data[@"status"] isEqual:@0]) {
      avatar = data[@"data"][0];
      [Common cacheImage:[URL_AVATARPATH stringByAppendingString:avatar] completion:^(UIImage *image) {
        [btnAvatar setBackgroundImage:image forState:UIControlStateNormal];
      }];
    }
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
    NSDate *date = [Common stringToDate:tbDob.text byFormat:@"yyyy年MM月dd日"];
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
    tbDob.text = [Common dateToString:date byFormat:@"yyyy年MM月dd日"];
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
  [Common showLoading];
  [Common requestQueue:^{
    NSDictionary *params = @{@"avatar": avatar, @"nc": tbNickname.text, @"gender": gender, @"height": @([tbHeight.text intValue]), @"weight": @([tbWeight.text floatValue])};
    NSDictionary *data = [Common syncPost:URL_UPDATEUSERINFO forms:params];
    if ([data[@"status"] isEqual:@1]) {
      [Common info:data[@"description"]];
      return;
    }
    data = [Common syncPost:URL_UPDATEHEIGHT forms:@{@"height": @([tbHeight.text intValue])}];
    data = [Common syncPost:URL_UPDATEWEIGHT forms:@{@"weight": @([tbWeight.text intValue])}];
    [Common hideLoading];
    User.avatar = avatar;
    User.nickname = tbNickname.text;
    User.gender = gender;
    User.height = @([tbHeight.text intValue]);
    User.weight = @([tbWeight.text floatValue]);
    dispatch_async(dispatch_get_main_queue(), ^{
      [self performSegueWithIdentifier:@"info_tag" sender:nil];
    });
  }];
}
@end
