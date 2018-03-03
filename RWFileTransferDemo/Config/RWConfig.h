//
//  RWConfig.h
//  XKFM
//
//  Created by RyanWong on 2017/10/14.
//  Copyright © 2017年 com.nest. All rights reserved.
//

#ifndef RWConfig_h
#define RWConfig_h

#define RWRGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

#define RWHEXCOLOR(s) [UIColor colorWithRed:(((s & 0xFF0000) >> 16))/255.0 green:(((s &0xFF00) >>8))/255.0 blue:((s &0xFF))/255.0 alpha:1.0]

#define RWHEXCOLORA(s,a) [UIColor colorWithRed:(((s & 0xFF0000) >> 16))/255.0 green:(((s &0xFF00) >>8))/255.0 blue:((s &0xFF))/255.0 alpha:a]

#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height
#define kScale [UIScreen mainScreen].scale

#define UI_IS_IPAD              ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
#define UI_IS_IPHONE            ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
#define UI_IS_IPHONE4           (UI_IS_IPHONE && [[UIScreen mainScreen] bounds].size.height < 568.0)
#define UI_IS_IPHONE5           (UI_IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 568.0)
#define UI_IS_IPHONE6           (UI_IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 667.0)
#define UI_IS_IPHONE6PLUS       (UI_IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 736.0 || [[UIScreen mainScreen] bounds].size.width == 736.0) // Both orientations
#define UI_IS_IPHONEX           (UI_IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 812.0)

/*******************************************************************
 * -- 本地化
 *******************************************************************/
#define Language(key) (NSString *)[[NSBundle mainBundle] localizedStringForKey:(key) value:key table:nil]
#define LanguageWRV(key, value1) (NSString *)[Language(key) stringByReplacingOccurrencesOfString:@"[P0]" withString:value1]
#define LanguageWRVS(key, value1, value2) (NSString *)[[Language(key) stringByReplacingOccurrencesOfString:@"[P0]" withString:value1] stringByReplacingOccurrencesOfString:@"[P1]" withString:value2]

#endif /* RWConfig_h */
