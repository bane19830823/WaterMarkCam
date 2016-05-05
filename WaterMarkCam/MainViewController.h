//
//  ViewController.h
//  WaterMarkCam
//
//  Created by Bane on 2013/06/04.
//  Copyright (c) 2013年 Bane. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "QBFlatButton.h"
#import "NADView.h"

typedef enum {
    PickingModePhoto,
    PrickingModeLibrary
} PickingMode;

@interface MainViewController : UIViewController <NADViewDelegate,
UINavigationControllerDelegate, UIImagePickerControllerDelegate>

{
    PickingMode picMode;
}

@property (nonatomic, retain) ALAssetsLibrary *library;
@property (nonatomic, retain) IBOutlet QBFlatButton *btnOpenLibrary;
@property (nonatomic, retain) IBOutlet QBFlatButton *btnTakePicture;
@property (nonatomic, retain) IBOutlet QBFlatButton *btnTakeVideo;
@property (nonatomic, retain) IBOutlet QBFlatButton *btnSetting;

@property (nonatomic, retain) IBOutlet UIView *buttonView;
@property (nonatomic, retain) NADView *nadViewHeader;
@property (nonatomic, retain) NADView *nadViewFooter;

@end
