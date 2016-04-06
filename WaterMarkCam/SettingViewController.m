//
//  SettingViewController.m
//  WaterMarkCam
//
//  Created by Bane on 2013/06/08.
//  Copyright (c) 2013年 Bane. All rights reserved.
//

#import "SettingViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <MediaPlayer/MediaPlayer.h>
#import "UIImage+ResizeImage.h"
#import "LogoSizeSettingViewController.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

@synthesize topTableView;
@synthesize btnCancel;
@synthesize btnSave;
@synthesize btnUpperLeft;
@synthesize btnUpperRight;
@synthesize btnBottomLeft;
@synthesize btnBottomRight;
@synthesize waterMarkView;
@synthesize sliderCell;
@synthesize alphaOfLogo;
@synthesize btnSizeSetting;
@synthesize btnChooseLogo;

#pragma mark - View lifeCycle
- (void)dealloc {
    self.topTableView = nil;
    self.btnCancel = nil;
    self.btnSave = nil;
    self.btnUpperLeft = nil;
    self.btnUpperRight = nil;
    self.btnBottomLeft = nil;
    self.btnBottomRight = nil;
    self.waterMarkView = nil;
    self.sliderCell = nil;
    self.btnSizeSetting = nil;
    self.btnChooseLogo = nil;
    
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //サイズ設定ボタン
    self.btnSizeSetting.faceColor = [UIColor colorWithRed:243.0/255.0 green:156.0/255.0 blue:18.0/255.0 alpha:1.0];
    self.btnSizeSetting.sideColor = [UIColor colorWithRed:230.0/255.0 green:126.0/255.0 blue:34.0/255.0 alpha:1.0];
    self.btnSizeSetting.radius = 8.0;
    self.btnSizeSetting.margin = 4.0;
    self.btnSizeSetting.depth = 3.0;
    
    self.btnSizeSetting.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [self.btnSizeSetting setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    //ロゴ選択ボタン
    self.btnChooseLogo.faceColor = [UIColor colorWithRed:155.0/255.0 green:89.0/255.0 blue:182.0/255.0 alpha:1.0];
    self.btnChooseLogo.sideColor = [UIColor colorWithRed:142.0/255.0 green:68.0/255.0 blue:173.0/255.0 alpha:1.0];
    self.btnChooseLogo.radius = 8.0;
    self.btnChooseLogo.margin = 4.0;
    self.btnChooseLogo.depth = 3.0;
    
    self.btnChooseLogo.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [self.btnChooseLogo setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    if (self.sliderCell == nil) {
        NSArray *tmpArray = [[NSBundle mainBundle] loadNibNamed:@"SliderCell" owner:self options:nil];
        self.sliderCell = [tmpArray objectAtIndex:0];
        self.sliderCell.delegate = self;
    }
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    NSData* imageData = [ud objectForKey:WMWaterMarkSaveKey];
    if(imageData) {
        UIImage* image = [UIImage imageWithData:imageData];
        self.waterMarkView.contentMode =  UIViewContentModeScaleAspectFit;
        self.waterMarkView.image = image;
    }
    NSDictionary *dic = [ud dictionaryForKey:settingSaveKey];
    
    if (dic == nil) {
        self.alphaOfLogo = 1.0;
        self.sliderCell.opacityLabel.text = @"100";
        
    } else {
        //ロゴの透明度
        self.alphaOfLogo = [[dic objectForKey:WMOpacityValueSaveKey] floatValue];
        [self.sliderCell.slider setValue:self.alphaOfLogo];
        self.sliderCell.opacityLabel.text = [NSString stringWithFormat:@"%.0f", self.alphaOfLogo * 100];
        self.waterMarkView.alpha = self.alphaOfLogo;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//表示する画像の選択
- (IBAction)logoSelect:(id)sender {
    if ([self startMediaBrowserFromViewController:self usingDelegate:self sender:sender]) {
    } else {
        //写真ライブラリーが利用出来ない
    }
}

//ロゴサイズ設定画面の表示
- (IBAction)logoSizeSetting:(id)sender {
    if (waterMarkView.image == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                         message:@"表示するロゴを選択して下さい"
                                                        delegate:self
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        
    } else {
        LogoSizeSettingViewController *logoView = [[[LogoSizeSettingViewController alloc] initWithNibName:@"LogoSizeSettingViewController"
                                                                                                   bundle:nil
                                                                                              alphaOfLogo:self.alphaOfLogo] autorelease];
        
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 60000
        [self presentViewController:logoView animated:YES completion:nil];
#endif
        // iOS 6 以前で有効
#if __IPHONE_OS_VERSION_MAX_ALLOWED < 60000
        [self presentModalViewController:logoView animated:YES];
#endif
    }
}

- (IBAction)cancelSetting:(id)sender {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 60000
    [self dismissViewControllerAnimated:YES completion:nil];
#endif

#if __IPHONE_OS_VERSION_MAX_ALLOWED < 60000
    [self dismissModalViewControllerAnimated:YES];
#endif
}

- (IBAction)saveSetting:(id)sender {
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];

    if (self.waterMarkView.image != nil) {
        NSData *imageData = UIImagePNGRepresentation(self.waterMarkView.image);
        [[NSUserDefaults standardUserDefaults] setObject:imageData forKey:WMWaterMarkSaveKey];
        [ud synchronize];
    }
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         [NSString stringWithFormat:@"%.02f", self.alphaOfLogo], WMOpacityValueSaveKey,
                         nil];
    
    [ud setObject:dic forKey:settingSaveKey];
    [ud synchronize];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 60000
    [self dismissViewControllerAnimated:YES completion:nil];
#endif
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED < 60000
    [self dismissModalViewControllerAnimated:YES];
#endif
}

#pragma mark - SliderCellDelegate
- (void)sliderValueChanged:(float)value {
    self.alphaOfLogo = value;
    if (self.waterMarkView.image != nil) {
        self.waterMarkView.alpha = value;
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
            //タイトルと説明
        case 0:
        {
            if (indexPath.row == 0) {
                return self.sliderCell;
            }
        }
            break;
        default:
            break;
    }
    return nil;
}

#pragma mark - UITableViewDelegate

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return NSLocalizedString(@"ロゴの透明度", @"Transparency of watermark");
    }
    return @"";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0;
}

- (BOOL)startMediaBrowserFromViewController:(UIViewController*)controller
                              usingDelegate:(id)del
                                     sender:(UIButton *)sender {
    // 1 - Validations
    if (([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum] == NO)
        || (del == nil)
        || (controller == nil)) {
        return NO;
    }
    // 2 - Get image picker
    UIImagePickerController *mediaUI = [[[UIImagePickerController alloc] init] autorelease];
    mediaUI.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    mediaUI.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeImage, nil];
    // Hides the controls for moving & scaling pictures, or for
    // trimming movies. To instead show the controls, use YES.
    mediaUI.allowsEditing = YES;
    mediaUI.delegate = del;
    // 3 - Display image picker
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 60000
        [self presentViewController:mediaUI animated:YES completion:nil];
#endif
        // iOS 6 以前で有効
#if __IPHONE_OS_VERSION_MAX_ALLOWED < 60000
        [self presentModalViewController:mediaUI animated:YES];
#endif
    return YES;
}

#pragma mark - UIImagePickerController delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 60000
        [self dismissViewControllerAnimated:YES completion:nil];
#endif
        // iOS 6 以前で有効
#if __IPHONE_OS_VERSION_MAX_ALLOWED < 60000
        [self dismissModalViewControllerAnimated:YES];
#endif
    
    // 1 - Get media type
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    
    if (CFStringCompare ((CFStringRef)mediaType, kUTTypeImage, 0) == kCFCompareEqualTo) {
        CGSize size = CGSizeMake(self.waterMarkView.frame.size.width, self.waterMarkView.frame.size.height);

        UIImage *image = [[info objectForKey:UIImagePickerControllerOriginalImage] resizeImageWithSize:size];
        self.waterMarkView.contentMode =  UIViewContentModeScaleAspectFit;
        self.waterMarkView.image = image;
        self.waterMarkView.alpha = self.alphaOfLogo;
    }
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    if (self.waterMarkView.image != nil) {
        NSData *imageData = UIImagePNGRepresentation(self.waterMarkView.image);
        [[NSUserDefaults standardUserDefaults] setObject:imageData forKey:WMWaterMarkSaveKey];
        [ud synchronize];
    }
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         [NSString stringWithFormat:@"%.02f", self.alphaOfLogo], WMOpacityValueSaveKey,
                         nil];
    
    [ud setObject:dic forKey:settingSaveKey];
    [ud synchronize];
}

// For responding to the user tapping Cancel.
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 60000
        [self dismissViewControllerAnimated:YES completion:nil];
#endif
        // iOS 6 以前で有効
#if __IPHONE_OS_VERSION_MAX_ALLOWED < 60000
        [self dismissModalViewControllerAnimated:YES];
#endif
    }
}

#pragma mark  AutoRotation Support Methods

#pragma mark  iOS 6 or later
// iOS 6 SDK 以降で有効
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 60000
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate
{
    return YES;
}
#endif

#pragma mark  Before iOS 6
// iOS 6 以前で有効
#if __IPHONE_OS_VERSION_MAX_ALLOWED < 60000

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return NO;
}
#endif

@end
