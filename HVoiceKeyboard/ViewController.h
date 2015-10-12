//
//  ViewController.h
//  HVoiceKeyboard
//
//  Created by 胡晓阳 on 15/10/9.
//  Copyright © 2015年 HXY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iflyMSC/IFlyRecognizerView.h>
#import <iflyMSC/IFlySpeechConstant.h>
#import <iflyMSC/IFlySpeechUtility.h>
#import <iflyMSC/IFlyRecognizerViewDelegate.h>
#import <iflyMSC/IFlySpeechRecognizer.h>
#import <iflyMSC/IFlySetting.h>

@interface ViewController : UIViewController<UITextFieldDelegate, IFlySpeechRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *myTextField;

@end

