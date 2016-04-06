//
//  LogoSizeSettingViewController.m
//  WaterMarkCam
//
//  Created by Bane on 2013/06/23.
//  Copyright (c) 2013年 Bane. All rights reserved.
//

#import "LogoSizeSettingViewController.h"
#import "UIScreen+is4inch.h"
#import <QuartzCore/QuartzCore.h>

@interface LogoSizeSettingViewController ()
@property (nonatomic, assign) CGRect logoFrame;
@property (nonatomic, retain) UIImageView *logoImageView;


@end

@implementation LogoSizeSettingViewController

#define VerticalTopMargin 64

@synthesize logoImageView = _logoImageView;
@synthesize alphaOfLogo = _alphaOfLogo;
@synthesize currentTransForm = _currentTransForm;
@synthesize logoFrame = _logoFrame;
@synthesize logoSetView = _logoSetView;

- (void)dealloc {
    self.logoImageView = nil;
    self.logoSetView = nil;
    
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil alphaOfLogo:(CGFloat)alpha
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.alphaOfLogo = alpha;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSData* imageData = [ud objectForKey:WMWaterMarkSaveKey];
    if(imageData) {
        UIImage* image = [UIImage imageWithData:imageData];
        self.logoImageView = [[UIImageView alloc] initWithImage:image];
        
        if ([ud objectForKey:WMLogoFrameSaveKey]) {
            CGRect savedRect = CGRectFromString([ud objectForKey:WMLogoFrameSaveKey]);
            self.logoImageView.frame = savedRect;
            self.logoFrame = savedRect;
        } else {
            self.logoImageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
            self.logoFrame = self.logoImageView.frame;
        }
        self.logoImageView.contentMode =  UIViewContentModeScaleAspectFit;
        [self.logoSetView addSubview:_logoImageView];
        
        NSDictionary *dic = [ud dictionaryForKey:settingSaveKey];
        
        if (dic == nil) {
            self.alphaOfLogo = 1.0;
        } else {
            //ロゴの透明度
            self.logoImageView.alpha = self.logoSetView.alpha =  self.alphaOfLogo;
            //ロゴの表示位置
            
            // ピンチジェスチャーを登録する
            UIPinchGestureRecognizer *pinch = [[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchAction:)] autorelease];
            [self.logoSetView addGestureRecognizer:pinch];
            
            // ドラッグジェスチャーを登録する
            UIPanGestureRecognizer *pan = [[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)] autorelease];
            [self.logoSetView addGestureRecognizer:pan];
        }
    } else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"表示するロゴを先に選択して下さい。" preferredStyle:UIAlertControllerStyleAlert];
        
        // addActionした順に左から右にボタンが配置されます
        [alertController addAction:[UIAlertAction actionWithTitle:@"はい" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
        }]];
    }
}

// ピンチジェスチャー発生時に呼び出されように設定したメソッド。
// ピンチジェスチャー中に何度も呼び出される。
- (void)pinchAction : (UIPinchGestureRecognizer *)sender {
    
    // ピンチジェスチャー発生時に、Imageの現在のアフィン変形の状態を保存する
    if (sender.state == UIGestureRecognizerStateBegan) {
        self.currentTransForm = self.logoImageView.transform;
    }
	
    // ピンチジェスチャー発生時から、どれだけ拡大率が変化したかを取得する
    // 2本の指の距離が離れた場合には、1以上の値、近づいた場合には、1以下の値が取得できる
    CGFloat scale = [sender scale];
    
    // ピンチジェスチャー開始時からの拡大率の変化を、imgViewのアフィン変形の状態に設定する事で、拡大する。
    self.logoImageView.transform = CGAffineTransformConcat(self.currentTransForm, CGAffineTransformMakeScale(scale, scale));
    self.logoFrame = self.logoImageView.frame;
    NSLog(@"logoFrame : %@", NSStringFromCGRect(self.logoFrame));
}

- (void)panAction : (UIPanGestureRecognizer *)sender {
	
    // ドラッグで移動した距離を取得する
    CGPoint p = [sender translationInView:self.view];
	
    // 移動した距離だけ、UIImageViewのcenterポジションを移動させる
    CGPoint movedPoint = CGPointMake(self.logoImageView.center.x + p.x, self.logoImageView.center.y + p.y);
    self.logoImageView.center = movedPoint;
    self.logoFrame = self.logoImageView.frame;
    NSLog(@"logoFrame : %@", NSStringFromCGRect(self.logoFrame));
	
    // ドラッグで移動した距離を初期化する
    // これを行わないと、[sender translationInView:]が返す距離は、ドラッグが始まってからの蓄積値となるため、
    // 今回のようなドラッグに合わせてImageを動かしたい場合には、蓄積値をゼロにする
    [sender setTranslation:CGPointZero inView:self.logoSetView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [ud setObject:NSStringFromCGRect(self.logoFrame) forKey:WMLogoFrameSaveKey];
    
    UIGraphicsBeginImageContextWithOptions(self.logoSetView.frame.size, NO, 0.0);
    [self.logoSetView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    // PNGの場合（view.alphaで指定した透明度も維持されるみたい）
    NSData *dataSaveImage = UIImagePNGRepresentation(image);
    
    // JPEGの場合
    //NSData *dataSaveImage = UIImageJPEGRepresentation(image, 1.0);
    
    // Documentsディレクトリに保存
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    [dataSaveImage writeToFile:[path stringByAppendingPathComponent:@"logo.png"] atomically:YES];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 60000
    [self dismissViewControllerAnimated:YES completion:nil];
#endif
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED < 60000
    [self dismissModalViewControllerAnimated:YES];
#endif
}

@end
