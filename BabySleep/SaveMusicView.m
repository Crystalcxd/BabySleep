//
//  SaveMusicView.m
//  BabySleep
//
//  Created by Michael on 2016/9/1.
//  Copyright © 2016年 Michael. All rights reserved.
//

#import "SaveMusicView.h"
#import "TFLargerHitButton.h"

#import "ELCImagePickerController.h"

#import "Utility.h"
#import "WMUserDefault.h"

@interface SaveMusicView ()<UIActionSheetDelegate,ELCImagePickerControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic , strong) UITextField *textField;

@property (nonatomic , strong) UIImageView *musicImageView;

@property (nonatomic , assign) BOOL imageChange;

@end

@implementation SaveMusicView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *BG = [[UIView alloc] initWithFrame:frame];
        BG.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.49];
        [self addSubview:BG];
        
        UIView *boardBG = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 288, 365)];
        boardBG.center = CGPointMake(CGRectGetWidth(frame) * 0.5, CGRectGetHeight(frame) * 0.5);
        boardBG.backgroundColor = [UIColor whiteColor];
        boardBG.layer.borderWidth = 3.0;
        boardBG.layer.borderColor = HexRGB(0xFF918C).CGColor;
        boardBG.layer.shadowColor = HexRGB(0x8697D4).CGColor;
        boardBG.layer.shadowOffset = CGSizeMake(1, 2);
        [self addSubview:boardBG];
        
        TFLargerHitButton *cancelBtn = [TFLargerHitButton buttonWithType:UIButtonTypeCustom];
        [cancelBtn setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
        cancelBtn.frame = CGRectMake(255, 15, 18, 18);
        [boardBG addSubview:cancelBtn];
        
        UILabel *nameTitle = [[UILabel alloc] initWithFrame:CGRectMake(22, 33, 100, 18)];
        nameTitle.textColor = HexRGB(0x9E9E9E);
        nameTitle.font = [UIFont fontWithName:@"DFPYuanW5" size:18];
        nameTitle.text = @"名称";
        [boardBG addSubview:nameTitle];
        
        UIView *textFieldBG = [[UIView alloc] initWithFrame:CGRectMake(26, 66, 236, 34)];
        textFieldBG.layer.borderColor = HexRGB(0xFF756F).CGColor;
        [boardBG addSubview:textFieldBG];
        
        self.textField = [[UITextField alloc] initWithFrame:CGRectMake(36, 66, 226, 34)];
        self.textField.font = [UIFont fontWithName:@"DFPYuanW5" size:18];
        self.textField.textColor = HexRGB(0xD0D0D0);
        self.textField.text = self.musicData.musicName;
        [boardBG addSubview:self.textField];
        
        self.musicData.imageName = @"record_save_head.png";

        UILabel *iconTitle = [[UILabel alloc] initWithFrame:CGRectMake(22, 141, 100, 18)];
        iconTitle.textColor = HexRGB(0x9E9E9E);
        iconTitle.font = [UIFont fontWithName:@"DFPYuanW5" size:18];
        iconTitle.text = @"头像";
        [boardBG addSubview:iconTitle];
        
        self.musicImageView = [[UIImageView alloc] initWithFrame:CGRectMake(94, 171, 90, 90)];
        self.musicImageView.layer.cornerRadius = 45;
        self.musicImageView.image = [UIImage imageNamed:self.musicData.imageName];
        [boardBG addSubview:self.musicImageView];
        
        UIButton *selectImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        selectImageBtn.frame = self.musicImageView.frame;
        [selectImageBtn addTarget:selectImageBtn action:@selector(selectImage:) forControlEvents:UIControlEventTouchUpInside];
        [boardBG addSubview:selectImageBtn];
        
        UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        saveBtn.frame = CGRectMake(0, 300, 288, 64);
        [saveBtn setTitle:@"保 存" forState:UIControlStateNormal];
        [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [saveBtn.titleLabel setFont:[UIFont fontWithName:@"DFPYuanW5" size:20]];
        saveBtn.backgroundColor = HexRGB(0xFF918C);
        [boardBG addSubview:saveBtn];
    }
    
    return self;
}

- (void)cancelAction:(id)sender
{
    [self removeFromSuperview];
}

- (void)saveAction:(id)sender
{
    if (self.textField.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请输入名称" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    self.musicData.musicName = self.textField.text;
    self.musicData.userData = YES;
    
    [self saveImage];
    [self saveData];
    
    self.EndSaveMusic();
}

- (void)saveData
{
    NSMutableArray *array = [NSMutableArray new];
    if ([WMUserDefault arrayForKey:@"UserData"]) {
        [array addObjectsFromArray:[WMUserDefault arrayForKey:@"UserData"]];
    }
    
    [array addObject:self.musicData];
    
    [WMUserDefault setArray:array forKey:@"UserData"];
}

- (void)saveImage
{
    if (self.imageChange) {
        NSString  *pngPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@",self.musicData.musicName]];
        [UIImagePNGRepresentation(self.musicImageView.image) writeToFile:pngPath atomically:YES];
        
        self.musicData.imageName = [NSString stringWithFormat:@"%@.png",self.musicData.musicName];
    }
}

- (void)selectImage:(id)sender
{
    UIActionSheet *choosePhotoActionSheet;
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        choosePhotoActionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:NSLocalizedString(@"取消", nil)
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:NSLocalizedString(@"拍照", nil), NSLocalizedString(@"从相册选择", nil), nil];
    } else {
        choosePhotoActionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:NSLocalizedString(@"取消", nil)
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:NSLocalizedString(@"从相册选择", nil), nil];
    }
    
    choosePhotoActionSheet.tag = 200;
    [choosePhotoActionSheet showInView:self];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"buttonIndex:%ld",(long)buttonIndex);
    NSUInteger sourceType = 0;
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        switch (buttonIndex) {
            case 0:
                sourceType = UIImagePickerControllerSourceTypeCamera;
                break;
            case 1:
                sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                break;
            case 2:
                
                break;
        }
        
    } else {
        if (buttonIndex == 1) {
            return;
        } else {
            sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        }
    }
    if (buttonIndex == 0) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = sourceType;
        
        [self.fatherVC presentViewController:imagePickerController animated:YES completion:^{
            
        }];
    }else if (buttonIndex == 1){
        ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initImagePicker];
        elcPicker.maximumImagesCount = 1;
        elcPicker.returnsOriginalImage = NO; //Only return the fullScreenImage, not the fullResolutionImage
        elcPicker.imagePickerDelegate = self;
        
        [self.fatherVC presentViewController:elcPicker animated:YES completion:^{
            
        }];
        
    }else{

    }
    
}

#pragma mark ELCImagePickerControllerDelegate Methods

- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info
{
    NSMutableArray *images = [NSMutableArray arrayWithCapacity:[info count]];
    
    for (NSDictionary *dict in info) {
        self.imageChange = YES;
        
        UIImage *image = [dict objectForKey:UIImagePickerControllerOriginalImage];
        [images addObject:image];
        NSData *data = UIImagePNGRepresentation(image);
        
        self.musicImageView.image = image;
    }
}

- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker
{
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    self.imageChange = YES;
    
    UIImage *image= [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    self.musicImageView.image = image;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
