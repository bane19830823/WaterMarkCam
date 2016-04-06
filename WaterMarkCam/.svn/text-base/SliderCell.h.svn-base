//
//  SliderCell.h
//  WaterMarkCam
//
//  Created by Bane on 2013/06/08.
//  Copyright (c) 2013年 Bane. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SliderCell;

@protocol SliderCellDelegate <NSObject>

- (void)sliderValueChanged:(float)value;

@end

@interface SliderCell : UITableViewCell {
    //透明度スライダー
    UISlider *slider;
    //透明度ラベル
    UILabel *opacityLabel;
    id <SliderCellDelegate> delegate;
}

@property (nonatomic, retain) IBOutlet UISlider *slider;
@property (nonatomic, retain) IBOutlet UILabel *opacityLabel;
@property (nonatomic, assign) id <SliderCellDelegate> delegate;

- (IBAction)sliderValueChanged:(UISlider *)sender;

@end
