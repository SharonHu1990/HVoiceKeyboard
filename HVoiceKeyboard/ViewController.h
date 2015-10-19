//
//  ViewController.h
//  HVoiceKeyboard
//
//  Created by 胡晓阳 on 15/10/9.
//  Copyright © 2015年 HXY. All rights reserved.
//

#import <UIKit/UIKit.h>
<<<<<<< HEAD
=======

#import <iflyMSC/iflyMSC.h>
>>>>>>> 6f27ba7b3117cacf89583355b94e5f1db913d720
#import <iflyMSC/IFlyRecognizerView.h>
#import <iflyMSC/IFlySpeechConstant.h>
#import <iflyMSC/IFlySpeechUtility.h>
#import <iflyMSC/IFlyRecognizerViewDelegate.h>
#import <iflyMSC/IFlySpeechRecognizer.h>
#import <iflyMSC/IFlySetting.h>

@interface ViewController : UIViewController<UITextFieldDelegate, IFlySpeechRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *myTextField;

@end

