//
//  Definition.h
//  HVoiceKeyboard
//
//  Created by 胡晓阳 on 15/10/14.
//  Copyright © 2015年 HXY. All rights reserved.
//

#ifndef Definition_h
#define Definition_h

//屏幕宽高
#define DeviceWidth [UIScreen mainScreen].bounds.size.width
#define DeviceHeight [UIScreen mainScreen].bounds.size.height


//色值 参数格式为：0xFFFFFF
#define kColorWithHex(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 \
green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0 \
blue:((float)(rgbValue & 0xFF)) / 255.0 alpha:1.0]

//色值 参数格式为：（222,222,222）
#define kColorWithRGB(r, g, b) [UIColor colorWithRed:(r) / 255.f green:(g) / 255.f blue:(b) / 255.f alpha:1.f]

//色值 参数格式为：（222,222,222，0.5）
#define kColorWithRGBA(r, g, b, a) [UIColor colorWithRed:(r) / 255.f green:(g) / 255.f blue:(b) / 255.f alpha:(a)]

//讯飞语音
#define APPID_VALUE           @"561db9a0"
#define URL_VALUE             @""                 // url
#define TIMEOUT_VALUE         @"20000"            // timeout      连接超时的时间，以ms为单位
#define BEST_URL_VALUE        @"1"                // best_search_url 最优搜索路径

#endif /* Definition_h */
