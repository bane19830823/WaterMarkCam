//
//  ViewController.m
//  WaterMarkCam
//
//  Created by Bane on 2013/06/04.
//  Copyright (c) 2013年 Bane. All rights reserved.
//

#import "MainViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <MediaPlayer/MediaPlayer.h>
#import "SettingViewController.h"
#import "UIImage+ResizeImage.h"
#import "UIColor+MLPFlatColors.h"
#import "UIScreen+is4inch.h"
#import "NADView.h"

@interface MainViewController ()

@end

@implementation MainViewController

@synthesize library = _library;
@synthesize btnOpenLibrary = _btnOpenLibrary;
@synthesize btnTakePicture = _btnTakePicture;
@synthesize btnTakeVideo = _btnTakeVideo;
@synthesize btnSetting = _btnSetting;
@synthesize buttonView = _buttonView;

- (void)dealloc {
    self.library = nil;
    self.btnOpenLibrary = nil;
    self.btnTakePicture = nil;
    self.btnTakeVideo = nil;
    self.btnSetting = nil;
    self.buttonView = nil;
    [self.nadViewHeader setDelegate:nil];
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // (1)ヘッダー広告
    // (2) NADView の作成
    self.nadViewHeader = [[NADView alloc] initWithFrame:CGRectMake(0, 20, 320, 50)];
    // (3) ログ出力の指定
    [self.nadViewHeader setIsOutputLog:NO];
    // (4) set apiKey, spotId.
    [self.nadViewHeader setNendID:@"ea574df6c315fd5375e22d7f6bae5cfacfcde4e0" spotID:@"579675"];
    [self.nadViewHeader setDelegate:self]; //(5)
    [self.nadViewHeader load]; //(6)
    [self.view addSubview:self.nadViewHeader]; // 最初から表示する場合
    
    // (1)フッター広告
    // (2) NADView の作成
    self.nadViewFooter = [[NADView alloc] initWithFrame:CGRectMake(0, [UIScreen getScreenHeight] - 50, 320, 50)];
    // (3) ログ出力の指定
    [self.nadViewFooter setIsOutputLog:NO];
    // (4) set apiKey, spotId.
    [self.nadViewFooter setNendID:@"8c23ab86b32859af5e0541183b4d59058c821c67" spotID:@"580361"];
    [self.nadViewFooter setDelegate:self]; //(5)
    [self.nadViewFooter load]; //(6)
    [self.view addSubview:self.nadViewFooter]; // 最初から表示する場合
    
	// Do any additional setup after loading the view, typically from a nib.
    self.library = [[ALAssetsLibrary alloc] init];
    
    //Take Picture Button
    self.btnTakePicture.faceColor = [UIColor colorWithRed:155.0/255.0 green:89.0/255.0 blue:182.0/255.0 alpha:1.0];
    self.btnTakePicture.sideColor = [UIColor colorWithRed:142.0/255.0 green:68.0/255.0 blue:173.0/255.0 alpha:1.0];
    self.btnTakePicture.radius = 8.0;
    self.btnTakePicture.margin = 4.0;
    self.btnTakePicture.depth = 3.0;
    self.btnTakePicture.exclusiveTouch = YES;
    self.btnTakePicture.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [self.btnTakePicture setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.buttonView addSubview:self.btnTakePicture];
    
    //Take Video Button
    self.btnTakeVideo.faceColor = [UIColor colorWithRed:243.0/255.0 green:156.0/255.0 blue:18.0/255.0 alpha:1.0];
    self.btnTakeVideo.sideColor = [UIColor colorWithRed:230.0/255.0 green:126.0/255.0 blue:34.0/255.0 alpha:1.0];
    self.btnTakeVideo.radius = 8.0;
    self.btnTakeVideo.margin = 4.0;
    self.btnTakeVideo.depth = 3.0;
    self.btnTakeVideo.exclusiveTouch = YES;
    self.btnTakeVideo.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [self.btnTakeVideo setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.buttonView addSubview:self.btnTakeVideo];

    
    //Open Library Button
    self.btnOpenLibrary.faceColor = [UIColor colorWithRed:46.0/255.0 green:204.0/255.0 blue:113.0/255.0 alpha:1.0];
    self.btnOpenLibrary.sideColor = [UIColor colorWithRed:39.0/255.0 green:174.0/255.0 blue:96.0/255.0 alpha:1.0];
    self.btnOpenLibrary.radius = 8.0;
    self.btnOpenLibrary.margin = 4.0;
    self.btnOpenLibrary.depth = 3.0;
    self.btnOpenLibrary.exclusiveTouch = YES;
    self.btnOpenLibrary.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [self.btnOpenLibrary setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.buttonView addSubview:self.btnOpenLibrary];
    
    //Setting Button
    self.btnSetting.faceColor = [UIColor colorWithRed:52.0/255.0 green:152.0/255.0 blue:219.0/255.0 alpha:1.0];
    self.btnSetting.sideColor = [UIColor colorWithRed:41.0/255.0 green:128.0/255.0 blue:185.0/255.0 alpha:1.0];
    self.btnSetting.radius = 8.0;
    self.btnSetting.margin = 4.0;
    self.btnSetting.depth = 3.0;
    self.btnSetting.exclusiveTouch = YES;
    self.btnSetting.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [self.btnSetting setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.buttonView addSubview:self.btnSetting];
    
    self.buttonView.frame = CGRectMake(0,
                                       [UIScreen getScreenHeight] / 2 - self.buttonView.frame.size.height / 2,
                                       self.buttonView.frame.size.width,
                                       self.buttonView.frame.size.height);
    [self.view addSubview:self.buttonView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showTakePicture:(id)sender {
    [self startMediaBrowserFromViewController:(UIViewController*)self
                                usingDelegate:(id)self sender:(UIButton *)sender];
}

- (IBAction)showTakeVideo:(id)sender {
    [self startMediaBrowserFromViewController:(UIViewController*)self
                                usingDelegate:(id)self sender:(UIButton *)sender];
}

//写真ライブラリを開く
- (IBAction)showLibrary:(UIButton *)sender {
[self startMediaBrowserFromViewController:(UIViewController*)self
                            usingDelegate:(id)self sender:(UIButton *)sender];
}


//設定画面を開く
- (IBAction)showSetting:(id)sender {
    SettingViewController *setVC = [[[SettingViewController alloc] initWithNibName:@"SettingViewController"
                                                                            bundle:nil] autorelease];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 60000
    [self presentViewController:setVC animated:YES completion:nil];
#endif
    // iOS 6 以前で有効
#if __IPHONE_OS_VERSION_MAX_ALLOWED < 60000
    [self presentModalViewController:setVC animated:YES];
#endif
}

- (BOOL)startMediaBrowserFromViewController:(UIViewController*)controller
                              usingDelegate:(id)del
                                     sender:(UIButton *)sender {
    // 1 - Validations
    if (sender == self.btnOpenLibrary) {
        if (([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum] == NO)
            || (del == nil)
            || (controller == nil)) {
            return NO;
        }
    } else if (sender == self.btnTakePicture || sender == self.btnTakeVideo) {
        if (([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO)
            || (del == nil)
            || (controller == nil)) {
            return NO;
        }
    }

    // 2 - Get image picker
    UIImagePickerController *mediaUI = [[[UIImagePickerController alloc] init] autorelease];
    
    if (sender == self.btnTakePicture) {
        picMode = PickingModePhoto;
        mediaUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else if (sender == self.btnTakeVideo) {
        mediaUI.sourceType = UIImagePickerControllerSourceTypeCamera;
        mediaUI.mediaTypes = [[NSArray alloc] initWithObjects:
                      (NSString *) kUTTypeMovie , nil];
        mediaUI.videoQuality = UIImagePickerControllerQualityTypeHigh;
        
    } else if (sender == self.btnOpenLibrary) {
        picMode = PrickingModeLibrary;
        mediaUI.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        mediaUI.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, (NSString *)kUTTypeImage, nil];
    }
    
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
    
    // video
    if (CFStringCompare ((CFStringRef)mediaType, kUTTypeMovie, 0) == kCFCompareEqualTo) {
        NSURL *url = [info objectForKey:UIImagePickerControllerMediaURL];
        [self addWaterMarkOnVideo:url];
        // photo
    } else if (CFStringCompare ((CFStringRef)mediaType, kUTTypeImage, 0) == kCFCompareEqualTo) {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        if (picMode == PickingModePhoto) {
            [self addWaterMarkOnPhoto:image];
        } else if (picMode == PrickingModeLibrary) {
            NSArray* actItems = [NSArray arrayWithObjects:image, nil];
            
            UIActivityViewController *activityView = [[[UIActivityViewController alloc] initWithActivityItems:actItems applicationActivities:nil] autorelease];
            
            [self presentViewController:activityView animated:YES completion:^{
            }];
        }
    }
}

// For responding to the user tapping Cancel.
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {

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

//2枚のUIImageを合成する
- (UIImage*)getWImage:(UIImage*)bottomImage frontImage:(UIImage*)frontImage {
    int width = bottomImage.size.width;
    int height = bottomImage.size.height;
    
    CGSize newSize = CGSizeMake(width, height);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    CGRect bottomFrame = CGRectMake(0,0,newSize.width,newSize.height);
    [bottomImage drawInRect:bottomFrame];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSDictionary *dic = [ud dictionaryForKey:settingSaveKey];
    float alpha = [[dic objectForKey:WMOpacityValueSaveKey] floatValue];
    
    // 写真サイズとロゴの比率
    CGFloat widthRatio = bottomFrame.size.width / frontImage.size.width;
    CGFloat heightRatio = bottomFrame.size.height / frontImage.size.height;
    
    CGRect displayRect = CGRectMake(0, 0, frontImage.size.width * widthRatio, frontImage.size.height * heightRatio);

    [frontImage drawInRect:displayRect blendMode:kCGBlendModeNormal alpha:alpha];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

//写真にwatermarkをつける
- (void)addWaterMarkOnPhoto:(UIImage *)sourceImage {
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    path = [path stringByAppendingPathComponent:@"logo.png"];
    UIImage *image = [UIImage imageWithContentsOfFile:path];

    [SVProgressHUD showWithStatus:@"Saving Photo"];
    UIImage *newImage = [self getWImage:sourceImage frontImage:image];
    UIImageWriteToSavedPhotosAlbum(newImage, self, @selector(savingImageIsFinished:didFinishSavingWithError:contextInfo:), nil);
}

// 写真の保存が完了したら呼ばれるメソッド
- (void)savingImageIsFinished:(UIImage*)image
    didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo{
    
    [SVProgressHUD dismiss];
    if (error) {
        [SVProgressHUD showErrorWithStatus:@"Failed To Save The Photo"];
    } else {
        // Alertを表示する
        [SVProgressHUD showSuccessWithStatus:@"Save The Photo To Camera Roll"];
    }
}

//ビデオにwatermarkをつける
- (void)addWaterMarkOnVideo:(NSURL *)sourceUrl {
    [SVProgressHUD showWithStatus:@"Saving Video"];
    //***** 1. ベースとなる動画のコンポジションを作成。*****//
    
    // 動画URLからアセットを生成
    AVURLAsset *videoAsset = [[AVURLAsset alloc] initWithURL:sourceUrl options:nil];
    
    // コンポジション作成
    AVMutableComposition* mixComposition = [AVMutableComposition composition];
    AVMutableCompositionTrack *compositionVideoTrack =
    [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo
                                preferredTrackID:kCMPersistentTrackID_Invalid];
    
    // アセットからトラックを取得
    AVAssetTrack *videoTrack = [[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    
    // コンポジションの設定
    [compositionVideoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration) ofTrack:videoTrack atTime:kCMTimeZero error:nil];
    [compositionVideoTrack setPreferredTransform:[[[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] preferredTransform]];
    
    //***** 2. 合成したいテキストやイラストをCALayerで作成して、合成用コンポジションを生成。*****//
    
    // ロゴのCALayer作成
    // 保存されているイメージを合成する
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    path = [path stringByAppendingPathComponent:@"logo.png"];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    if(image == nil) {
        return;
    } else {
        CALayer *logoLayer = [CALayer layer];
        logoLayer.contents = (id) image.CGImage;
        // 動画のサイズを取得
        CGSize videoSize = videoTrack.naturalSize;

        BOOL isPortrait = [self isVideoPortrait:videoAsset];
        if (isPortrait) {
            videoSize = CGSizeMake(videoSize.height, videoSize.width);
        }
        
        // 親レイヤーを作成
        CALayer *parentLayer = [CALayer layer];
        CALayer *videoLayer = [CALayer layer];
        parentLayer.frame = CGRectMake(0, 0, videoSize.width, videoSize.height);
        videoLayer.frame  = CGRectMake(0, 0, videoSize.width, videoSize.height);
        [parentLayer addSublayer:videoLayer];
        
        NSDictionary *dic = [ud dictionaryForKey:settingSaveKey];
        
        //ロゴのフレームサイズ
        // 写真サイズとロゴの比率
        CGFloat widthRatio = parentLayer.frame.size.width / image.size.width;
        CGFloat heightRatio = parentLayer.frame.size.height / image.size.height;
        
        logoLayer.frame = CGRectMake(0, 0, image.size.width * widthRatio, image.size.height * heightRatio);
        //ロゴの透明度
        NSString *opacity = [NSString stringWithFormat:@"%.01f", [[dic objectForKey:WMOpacityValueSaveKey] floatValue]];
        logoLayer.opacity = [opacity floatValue];
        
        [parentLayer addSublayer:logoLayer];
        
        // 合成用コンポジション作成
        AVMutableVideoComposition* videoComp = [AVMutableVideoComposition videoComposition];
        mixComposition.naturalSize = videoSize;
        videoComp.renderSize = videoSize;
        videoComp.frameDuration = CMTimeMake(1, 30);    // 30 fps
        videoComp.animationTool =
        [AVVideoCompositionCoreAnimationTool videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer
                                                                                                     inLayer:parentLayer];
        // インストラクション作成
        AVMutableVideoCompositionInstruction *instruction =
        [AVMutableVideoCompositionInstruction videoCompositionInstruction];
        instruction.timeRange = CMTimeRangeMake(kCMTimeZero, [mixComposition duration]); // 時間を設定
        AVMutableVideoCompositionLayerInstruction* layerInstruction =
        [AVMutableVideoCompositionLayerInstruction
         videoCompositionLayerInstructionWithAssetTrack:videoTrack];
        [layerInstruction setTransform:videoTrack.preferredTransform atTime:kCMTimeZero];

        instruction.layerInstructions = [NSArray arrayWithObject:layerInstruction];
        
        // インストラクションを合成用コンポジションに設定
        videoComp.instructions = [NSArray arrayWithObject: instruction];
        
        //***** 3. AVAssetExportSessionを使用して1と2のコンポジションを合成。*****//
        
        // 1のコンポジションをベースにAVAssetExportを生成
        AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition
                                                                          presetName:AVAssetExportPresetHighestQuality];
        
        // 2の合成用コンポジションを設定
        exporter.videoComposition = videoComp;
        
        NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
        [dateFormatter setDateFormat:@"yyyy-MM-dd-HH-mm-ss"];
        
        NSString *videoName = [NSString stringWithFormat:@"mergeVideo%@-%d.mov", [dateFormatter stringFromDate:[NSDate date]] , arc4random() % 10000];
        
        NSString *exportPath = [NSTemporaryDirectory() stringByAppendingPathComponent:videoName];
        NSURL *url = [NSURL fileURLWithPath:exportPath];
        
        // ファイルが存在している場合は削除
        if ([[NSFileManager defaultManager] fileExistsAtPath:exportPath])
        {
            [[NSFileManager defaultManager] removeItemAtPath:exportPath error:nil];
        }
        
        exporter.outputURL = url;
        exporter.outputFileType = AVFileTypeQuickTimeMovie;
        exporter.shouldOptimizeForNetworkUse = YES;
        
        [exporter exportAsynchronouslyWithCompletionHandler:^{
                switch (exporter.status) {
                    case AVAssetExportSessionStatusCompleted:
                    {
                        NSURL *outputURL = exporter.outputURL;
                        if ([self.library videoAtPathIsCompatibleWithSavedPhotosAlbum:outputURL]) {
                            [self.library writeVideoAtPathToSavedPhotosAlbum:outputURL completionBlock:^(NSURL *assetURL, NSError *error){
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    if (error) {
                                        [SVProgressHUD showErrorWithStatus:@"Failed to Save The Video"];
                                    } else {
                                        [SVProgressHUD showSuccessWithStatus:@"Save The Video To Camera Roll"];
                                    }
                                });
                            }];
                        }
                        break;
                    }
                    case AVAssetExportSessionStatusFailed:
                    {
                        [SVProgressHUD showErrorWithStatus:@"Failed To Save The Video"];
                        NSLog(@"Failed:%@", exporter.error);
                        break;
                    }
                    case AVAssetExportSessionStatusCancelled:
                    {
                        [SVProgressHUD showErrorWithStatus:@"Canceled To Save the Video"];
                        NSLog(@"Canceled:%@",exporter.error);
                        break;
                    }
                    default:
                        break;
                }
//            });
        }];
    }
}

-(BOOL) isVideoPortrait:(AVAsset *)asset
{
    BOOL isPortrait = FALSE;
    NSArray *tracks = [asset tracksWithMediaType:AVMediaTypeVideo];
    if([tracks    count] > 0) {
        AVAssetTrack *videoTrack = [tracks objectAtIndex:0];
        
        CGAffineTransform t = videoTrack.preferredTransform;
        // Portrait
        if(t.a == 0 && t.b == 1.0 && t.c == -1.0 && t.d == 0)
        {
            isPortrait = YES;
        }
        // PortraitUpsideDown
        if(t.a == 0 && t.b == -1.0 && t.c == 1.0 && t.d == 0)  {
            
            isPortrait = YES;
        }
        // LandscapeRight
        if(t.a == 1.0 && t.b == 0 && t.c == 0 && t.d == 1.0)
        {
            isPortrait = FALSE;
        }
        // LandscapeLeft
        if(t.a == -1.0 && t.b == 0 && t.c == 0 && t.d == -1.0)
        {
            isPortrait = FALSE;
        }
    }
    return isPortrait;
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
    return NO;
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
