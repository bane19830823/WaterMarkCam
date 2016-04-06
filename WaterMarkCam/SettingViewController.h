//
//  SettingViewController.h
//  WaterMarkCam
//
//  Created by Bane on 2013/06/08.
//  Copyright (c) 2013年 Bane. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SliderCell.h"
#import "QBFlatButton.h"

@interface SettingViewController : UIViewController <SliderCellDelegate> {
    
    UITableView *topTableView;
    UIBarButtonItem *btnCancel;
    UIBarButtonItem *btnSave;
    
    //表示するロゴ
    UIImageView *waterMarkView;
    
    SliderCell *sliderCell;
}

@property (nonatomic, retain) IBOutlet UITableView *topTableView;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *btnCancel;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *btnSave;
@property (nonatomic, retain) IBOutlet UIButton *btnUpperLeft;
@property (nonatomic, retain) IBOutlet UIButton *btnUpperRight;
@property (nonatomic, retain) IBOutlet UIButton *btnBottomLeft;
@property (nonatomic, retain) IBOutlet UIButton *btnBottomRight;
@property (nonatomic, retain) IBOutlet QBFlatButton *btnSizeSetting;
@property (nonatomic, retain) IBOutlet QBFlatButton *btnChooseLogo;
@property (nonatomic, retain) IBOutlet UIImageView *waterMarkView;
@property (nonatomic, retain) SliderCell *sliderCell;
@property (nonatomic, assign) float alphaOfLogo;

- (IBAction)logoSelect:(id)sender;
- (IBAction)logoSizeSetting:(id)sender;
- (IBAction)cancelSetting:(id)sender;
- (IBAction)saveSetting:(id)sender;

@end
