//
//  SliderCell.m
//  WaterMarkCam
//
//  Created by Bane on 2013/06/08.
//  Copyright (c) 2013年 Bane. All rights reserved.
//

#import "SliderCell.h"

@implementation SliderCell

@synthesize slider;
@synthesize opacityLabel;
@synthesize delegate;

- (void)dealloc {
    self.slider = nil;
    self.opacityLabel = nil;
    self.delegate = nil;
    
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)sliderValueChanged:(UISlider *)sender {
    float value = sender.value;
    self.opacityLabel.text = [NSString stringWithFormat:@"%.0f", value * 100];
    
    if ([self.delegate respondsToSelector:@selector(sliderValueChanged:)]) {
        [self.delegate sliderValueChanged:value];
    }
}

@end
