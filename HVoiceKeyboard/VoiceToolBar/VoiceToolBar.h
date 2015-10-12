//
//  voiceToolBar.h
//  HVoiceKeyboard
//
//  Created by 胡晓阳 on 15/10/12.
//  Copyright © 2015年 HXY. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VoiceToolBarDelegate <NSObject>

@optional
/**
 *  按着voiceButton
 */
-(void)beginToTouchVoiceButton;

/**
 *  松开手指
 */
-(void)beginToReleaseFinger;

/**
 *  手指拖动离开
 */
-(void)beginToMoveFinger;

@end

@interface VoiceToolBar : UIToolbar

@property (nonatomic, assign) id<VoiceToolBarDelegate> myDelegate;
-(instancetype)initWithFrame:(CGRect)frame;

@end
