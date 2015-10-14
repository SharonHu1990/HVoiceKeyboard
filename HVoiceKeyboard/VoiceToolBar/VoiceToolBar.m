//
//  voiceToolBar.m
//  HVoiceKeyboard
//
//  Created by 胡晓阳 on 15/10/12.
//  Copyright © 2015年 HXY. All rights reserved.
//

#import "VoiceToolBar.h"

@implementation VoiceToolBar

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        [self setBarTintColor:kColorWithRGB(219, 224, 229)];
        //设置style
        [self setBarStyle:UIBarStyleDefault];
        
        UIButton *voiceBt = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, DeviceWidth, 30)];
        [voiceBt setTitle:@"按住 说出你要搜索的内容" forState:UIControlStateNormal];
        [voiceBt.titleLabel setFont:[UIFont systemFontOfSize:12.f]];
        [voiceBt setTitleColor:kColorWithRGB(161, 161, 161) forState:UIControlStateNormal];
        [voiceBt setBackgroundColor:kColorWithRGB(219, 224, 229)];
        [voiceBt setImage:[UIImage imageNamed:@"list_yyj"] forState:UIControlStateNormal];
        [voiceBt setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        
        [voiceBt addTarget:self action:@selector(pressedEvent:) forControlEvents:UIControlEventTouchDown];
        [voiceBt addTarget:self action:@selector(unpressedEvent:) forControlEvents:UIControlEventTouchUpInside];
        [voiceBt addTarget:self action:@selector(dragExitEvent:) forControlEvents:UIControlEventTouchDragExit];
        
        UIBarButtonItem *voiceBarBT = [[UIBarButtonItem alloc] initWithCustomView:voiceBt];
        //在toolBar上加上这些按钮
        NSArray * buttonsArray = [NSArray arrayWithObjects: voiceBarBT,nil];
        [self setItems:buttonsArray];

    }
    return self;
}

//长按
-(void)pressedEvent:(UIButton *)sender
{
    NSLog(@"按着");
    [_myDelegate beginToTouchVoiceButton];
}

//松开手指
-(void)unpressedEvent:(UIButton *)sender
{
    NSLog(@"松开手指");
    [_myDelegate beginToReleaseFinger];
    
}

//手指拖动离开
-(void)dragExitEvent:(UIButton *)sender
{
    NSLog(@"手指拖动离开");
    [_myDelegate beginToMoveFinger];
}


-(void)awakeFromNib{

}
@end
