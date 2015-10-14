//
//  VoiceView.m
//  NewRobooJoke
//
//  Created by 胡晓阳 on 15/7/3.
//  Copyright (c) 2015年 Roboo. All rights reserved.
//

#import "VoiceView.h"

@implementation VoiceView
{
    
    __weak IBOutlet UIView *line1;
    __weak IBOutlet UIView *line2;
    __weak IBOutlet UIView *line3;
    __weak IBOutlet UIView *line4;
    __weak IBOutlet UIView *line5;
    __weak IBOutlet UIView *line6;
    __weak IBOutlet UIView *line7;
    __weak IBOutlet UIView *line8;
    __weak IBOutlet UIView *line9;
    __weak IBOutlet UIView *line10;
    
    NSArray *volumeLinesArr;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)awakeFromNib
{
    [self initVolumeLinesArr];
}

-(void)initVolumeLinesArr
{
    [line1 setHidden:YES];
    [line2 setHidden:YES];
    [line3 setHidden:YES];
    [line4 setHidden:YES];
    [line5 setHidden:YES];
    [line6 setHidden:YES];
    [line7 setHidden:YES];
    [line8 setHidden:YES];
    [line9 setHidden:YES];
    [line10 setHidden:YES];
    volumeLinesArr = @[line1,line2,line3,line4,line5,line6,line7,line8,line9,line10];
    
    
}

-(void)updateVolumeLinesWithValue:(int)volumeValue
{
    //volumeValue 0~30
    //0-－5，显示1格
    //6-8，显示2格，
    //9-11，显示3格,以此类推
    int limit = volumeValue/3;
    if (limit == 0) {
        limit = limit+1;
    }
    for (int i = 0; i < volumeLinesArr.count; i++) {
        UIView *volumeView = [volumeLinesArr objectAtIndex:i];
        if (volumeView.tag <= limit) {
            [volumeView setHidden:NO];
        }else
        {
            [volumeView setHidden:YES];
        }
    }
   
}
@end
