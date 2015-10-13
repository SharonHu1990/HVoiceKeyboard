//
//  ViewController.m
//  HVoiceKeyboard
//
//  Created by 胡晓阳 on 15/10/9.
//  Copyright © 2015年 HXY. All rights reserved.
//



#import "ViewController.h"
#import "VoiceView.h"
#import "ISRDataHelper.h"
#import "VoiceToolBar.h"

@interface ViewController ()<VoiceToolBarDelegate>
{
    float keyboartHeight;//键盘高度
    IFlySpeechRecognizer *_iFlySpeechRecognizer;//无界面的语音识别对象
    VoiceView *voiceView;//语音识别的反馈效果
    UIView *voiceBackView;//背景
    BOOL isCanceled;//是否取消语音识别
    NSString *speachResult;

    __weak IBOutlet UILabel *stateLB;//显示状态
    
//    MBProgressHUD *hud;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    [self.myTextField becomeFirstResponder];
    
    [self addKeyboardVoiceToolBar];
    
    //监听键盘出现
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    
    //初始化语音识别控件
    NSString *initString = [NSString stringWithFormat:@"%@=%@",[IFlySpeechConstant APPID],FLYAPPID];
    
    //所有服务启动前，需要确保执行createUtility
    [IFlySpeechUtility createUtility:initString];
    
    
    voiceView = [[[NSBundle mainBundle] loadNibNamed:@"VoiceView" owner:nil options:nil] lastObject];
    [voiceView.layer setCornerRadius:4.f];
    voiceBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DeviceWidth, DeviceHeight)];
    [voiceBackView setBackgroundColor:[UIColor whiteColor]];
    [voiceBackView setAlpha:0.f];
    [self.view addSubview:voiceBackView];
    
//    hud = [[MBProgressHUD alloc] initWithView:self.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/**
 *  Step 1 - 键盘上方添加工具条
 */
-(void)addKeyboardVoiceToolBar{
    //定义一个toolBar
    //    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 30)];
    VoiceToolBar *keyboardVoiceToolBar = [[VoiceToolBar alloc] initWithFrame:CGRectMake(0, 0, DeviceWidth, 30)];
    keyboardVoiceToolBar.myDelegate = self;
    [self.myTextField setInputAccessoryView:keyboardVoiceToolBar];
}


/**
 *  Step 2 - 监听键盘的出现，获取键盘高度, 用键盘高度确定音量View的位置
 *
 *  @param notification <#notification description#>
 */
-(void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    
    CGRect keyboardRect = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSLog(@"keyboardRect Hight:%f",keyboardRect.size.height);
    keyboartHeight = keyboardRect.size.height;
}




/**
 *  Step 3 - 执行VoiceButton代理事件
 *
 */
#pragma mark - VoiceToolBarDelegate Methods
-(void)beginToTouchVoiceButton{
    [self startVoiceRecognition];
    [self showVoiceView];
}

-(void)beginToReleaseFinger
{
    [_iFlySpeechRecognizer stopListening];
    
//    hud.mode = MBProgressHUDModeIndeterminate;
//    hud.labelText = @"正在识别...";
//    [hud show:YES];
    //    [[JokeHintService share] showLoadingIndicator:self.view indicatorTitle:@"正在识别..."];
    [self.myTextField resignFirstResponder];
    [self hideVoiceView];

}

-(void)beginToMoveFinger{
    [self hideVoiceView];
    //停止语音
    [_iFlySpeechRecognizer cancel];
}

#pragma mark - 执行讯飞语音业务


/**
 *  初始化讯飞语音识别
 */
-(void)initFlyRecognizer
{
    //单例模式，无UI的实例
    if (_iFlySpeechRecognizer == nil) {
        //打开输出在console的log开关
        [IFlySetting showLogcat:NO];
        _iFlySpeechRecognizer = [IFlySpeechRecognizer sharedInstance];
        
        [_iFlySpeechRecognizer setParameter:@"" forKey:[IFlySpeechConstant PARAMS]];
        
        //设置听写模式
        [_iFlySpeechRecognizer setParameter:@"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
    }
    _iFlySpeechRecognizer.delegate = self;
    
}

/**
 *  开始识别语音
 *
 *  @param sender <#sender description#>
 */
-(void)startVoiceRecognition
{
    
    isCanceled = NO;
    [self.myTextField setText:@""];
    
    
    if(_iFlySpeechRecognizer == nil){
        [self initFlyRecognizer];
    }
    
    
    //设置音频来源为麦克风
    [_iFlySpeechRecognizer setParameter:IFLY_AUDIO_SOURCE_MIC forKey:@"audio_source"];
    
    //设置听写结果格式为json
    [_iFlySpeechRecognizer setParameter:@"json" forKey:[IFlySpeechConstant RESULT_TYPE]];
    
    //保存录音文件，保存在sdk工作路径中，如未设置工作路径，则默认保存在library/cache下
    [_iFlySpeechRecognizer setParameter:@"asr.pcm" forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
    
    //设置不返回标点符号
    [_iFlySpeechRecognizer setParameter:[IFlySpeechConstant ASR_PTT_NODOT] forKey:[IFlySpeechConstant ASR_PTT]];
    
    [_iFlySpeechRecognizer setDelegate:self];
    
    BOOL ret = [_iFlySpeechRecognizer startListening];
    
    if (ret) {
        
    }else{
        //        [[JokeHintService share] showBubble:@"启动识别服务失败，请稍后重试"];//可能是上次请求未结束，暂不支持多路并发
//        hud.mode = MBProgressHUDModeText;
//        hud.labelText = @"启动识别服务失败，请稍后重试";
//        [hud show:YES];
//        [hud hide:YES afterDelay:3];
        NSLog(@"提示启动识别服务失败，请稍后重试");
    }
    
}


#pragma mark - 音量View的出现和隐藏

-(void)showVoiceView
{
    
    [UIView animateWithDuration:0.3 animations:^{
        [voiceBackView setAlpha:0.7];
    } completion:^(BOOL finished) {
        [voiceView setFrame:CGRectMake((voiceBackView.frame.size.width - 131)/2.0, voiceBackView.frame.size.height - 44 - (keyboartHeight+30)- 135, 131, 135)];
        [voiceBackView addSubview:voiceView];
    }];
}

-(void)hideVoiceView
{
    [UIView animateWithDuration:0.3 animations:^{
        [voiceBackView setAlpha:0.f];
    } completion:^(BOOL finished) {
        [voiceView removeFromSuperview];
    }];
}



#pragma  mark - IFlySpeechRecognizerDelegate
/** 开始录音回调
 
 当调用了`startListening`函数之后，如果没有发生错误则会回调此函数。如果发生错误则回调onError:函数
 */
- (void) onBeginOfSpeech
{
    NSLog(@"开始录音");
}

/** 停止录音回调
 
 当调用了`stopListening`函数或者引擎内部自动检测到断点，如果没有发生错误则回调此函数。如果发生错误则回调onError:函数
 */
- (void) onEndOfSpeech
{
    NSLog(@"停止录音");
//    [hud hide:YES];
}

/**
 听写结束回调（注：无论听写是否正确都会回调）
 error.errorCode =
 0     听写正确
 other 听写出错
 ****/
- (void) onError:(IFlySpeechError *) error
{
    //隐藏语音反馈
    [self hideVoiceView];
    [self.myTextField resignFirstResponder];
    
    NSString *errmsg;
    if(error.errorCode == 0)
            {
        if (isCanceled) {
            errmsg = @"已取消";
        }else
                {
            if ([self.myTextField.text length] != 0) {
                errmsg = @"识别成功";
            }else
                    {
                errmsg = @"无识别结果";
                    }
            
                }
        
            }else
                    {
                errmsg = error.errorDesc;
                    }
    
//    hud.mode = MBProgressHUDModeText;
//    hud.labelText = errmsg;
//    [hud show:YES];
//    [hud hide:YES afterDelay:3];
    
    NSLog(@"error:%@",errmsg);
}


/**
 无界面，听写结果
 results：听写结果
 isLast：表示最后一次
 ****/
- (void) onResults:(NSArray *) results isLast:(BOOL)isLast
{
    
    NSMutableString *resultString = [[NSMutableString alloc] init];
    NSDictionary *dic = results[0];
    for (NSString *key in dic) {
        [resultString appendFormat:@"%@",key];
    }
    speachResult = [ISRDataHelper stringFromJson:resultString];
    
    if (speachResult.length != 0) {
        
        //执行识别成功后的业务逻辑
        [self.myTextField setText:speachResult];
//        [self searchActionWithKeyword:speachResult];
        
        
        
    }
}


/** 取消识别回调
 
 当调用了`cancel`函数之后，会回调此函数，在调用了cancel函数和回调onError之前会有一个短暂时间，您可以在此函数中实现对这段时间的界面显示。
 */
-(void)onCancel
{
    NSLog(@"取消识别回调");
    isCanceled = YES;
}

/**
 音量回调函数
 volume 0－30
 ****/
-(void)onVolumeChanged:(int)volume
{
    [voiceView updateVolumeLinesWithValue:volume];
}



@end
