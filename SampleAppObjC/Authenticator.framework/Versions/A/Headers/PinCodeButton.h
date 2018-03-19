//
//  PinCodeButton.h
//  WhiteLabel
//
//  Created by ani on 11/8/16.
//  Copyright © 2016 LaunchKey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PinCodeButton : UIButton

@property (nonatomic, strong) UIColor *highlihgtedStateColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *lettersColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *bulletColor UI_APPEARANCE_SELECTOR;

-(void)setPinCodeButtonAsCircle:(BOOL)asCircle;
-(void)setBorderColor:(UIColor*)borderColor;
-(void)setBorderWidth:(CGFloat)borderWidth;

@end