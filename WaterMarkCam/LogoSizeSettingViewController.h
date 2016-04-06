//
//  LogoSizeSettingViewController.h
//  WaterMarkCam
//
//  Created by Bane on 2013/06/23.
//  Copyright (c) 2013年 Bane. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LogoSizeSettingViewController : UIViewController

@property (nonatomic, retain) IBOutlet UIView *logoSetView;
@property (nonatomic, assign) float alphaOfLogo;
@property (nonatomic, assign) CGAffineTransform currentTransForm;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil alphaOfLogo:(CGFloat)alpha;

@end
