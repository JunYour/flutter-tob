//
//  MagicWindowApi.h
//  Created by 刘家飞 on 14/11/18.
//  Copyright (c) 2014年 MagicWindow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MWCampaignConfig.h"
#import <CoreLocation/CoreLocation.h>
#import "MWApiObject.h"

#define DEPRECATED(_version) __attribute__((deprecated))

/**
 *  当活动有更新的时候会触发该notification
 **/
#define MWUpdateCampaignNotification            @"MWUpdateCampaignNotification"
/**
 *  活动详情页面即将打开的时候会触发
 **/
#define MWWebViewWillAppearNotification         @"MWWebViewWillAppearNotification"
/**
 *  活动详情页面关闭的时候会触发
 **/
#define MWWebViewDidDisappearNotification       @"MWWebViewDidDisappearNotification"
/**
 *  @deprecated This method is deprecated starting in version 3.66
 *  @note Please use @code MWUpdateCampaignNotification @code instead.
 **/
#define MWRegisterAppSuccessedNotification      @"MWRegisterAppSuccessedNotification"  DEPRECATED(3.66)


typedef  void (^ _Nullable CallbackWithCampaignSuccess) (NSString *__nonnull key, UIView *__nonnull view, MWCampaignConfig *__nonnull campaignConfig);
typedef void (^ _Nullable CallbackWithCampaignFailure) (NSString *__nonnull key, UIView *__nonnull view, NSString *__nullable errorMessage);
typedef  BOOL (^ CallbackWithTapCampaign) (NSString *__nonnull key, UIView *__nonnull view);
typedef void(^ _Nullable CallBackMLink)(NSURL * __nonnull url ,NSDictionary * __nullable params);
typedef  NSDictionary * _Nullable (^ CallbackWithMLinkCampaign) (NSString *__nonnull key, UIView *__nonnull view);
typedef  NSDictionary * _Nullable (^ CallbackWithMLinkLandingPage) (NSString *__nonnull key, UIView *__nonnull view);
typedef  NSDictionary * _Nullable (^ CallbackWithReturnMLink) (NSString *__nonnull key, UIView *__nonnull view);

@interface MWApi : NSObject

#pragma mark - 过期的方法，建议使用 JMLinkService中的新接口

/**
 *  注册app
 *  需要在 application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions 中调用
 *  @param appKey 魔窗后台注册的appkey
 */
+ (void)registerApp:(nonnull NSString *)appKey __attribute__((deprecated("JMLink 1.0.0 版本已过期,请使用JMLinkService类的setupWithConfig:方法")));


/**
 * 注册一个mLink handler，当接收到URL的时候，会根据mLink key进行匹配，当匹配成功会调用相应的handler
 * 需要在 AppDelegate 的 didFinishLaunchingWithOptions 中调用
 * @param key 后台注册mlink时生成的mlink key
 * @param handler mlink的回调
 */
+ (void)registerMLinkHandlerWithKey:(nonnull NSString *)key handler:(CallBackMLink)handler __attribute__((deprecated("JMLink 1.0.0 版本已过期,请使用JMLinkService类的registerMLinkHandlerWithKey:handler:方法")));

/**
 * 注册一个默认的mLink handler，当接收到URL，并且所有的mLink key都没有匹配成功，就会调用默认的mLink handler
 * 需要在 AppDelegate 的 didFinishLaunchingWithOptions 中调用
 * @param handler mlink的回调
 */
+ (void)registerMLinkDefaultHandler:(CallBackMLink)handler __attribute__((deprecated("JMLink 1.0.0 版本已过期,请使用JMLinkService类的registerMLinkDefaultHandler:方法")));

/**
 * 根据不同的URL路由到不同的app展示页
 * 需要在 application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation 中调用
 * @param url 传入上面方法中的openUrl
 */
+ (void)routeMLink:(nonnull NSURL *)url __attribute__((deprecated("JMLink 1.0.0 版本已过期,请使用JMLinkService类的routeMLink:方法")));

/**
 *  根据universal link路由到不同的app展示页
 *  需要在 application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void(^)(NSArray * __nullable restorableObjects))restorationHandler 中调用
 *  @param userActivity 传入上面方法中的userActivity
 *  @return BOOL
 */
+ (BOOL)continueUserActivity:(nonnull NSUserActivity *)userActivity NS_AVAILABLE_IOS(8.0) __attribute__((deprecated("JMLink 1.0.0 版本已过期,请使用JMLinkService类的continueUserActivity:方法")));


/**
 *  获取无码邀请中传回来的相关值
 */
+ (nullable id)getMLinkParam:(nonnull NSString *)paramKey __attribute__((deprecated("JMLink 1.0.0 版本已过期,请使用JMLinkService类的getMLinkParam:handler:方法")));

/**
 *  设置是否打印sdk的log信息,默认不开启,在release情况下，不要忘记设为NO.
 *  @param enable YES:打开,NO:关闭
 */
+ (void)setLogEnable:(BOOL)enable __attribute__((deprecated("JMLink 1.0.0 版本已过期,请使用JMLinkService类的setDebug:方法")));

/**
 *  设置是否抓取crash信息,默认开启.
 *  @param enable YES:打开,NO:关闭
 */
+ (void)setCaughtCrashesEnable:(BOOL)enable __attribute__((deprecated("JMLink 1.0.0 版本已过期,请使用JMLinkService类的crashLogON:方法")));


#pragma mark - 废弃的接口


/**
 * 获得最近一次的mLink短链接的渠道来源
 * @return stirng
 */
+ (nullable NSString *)getLastChannelForMLink __attribute__((deprecated("JMLink 1.0.0 版本已废弃")));

/**
 *  设置渠道,默认为appStore
 *  @param channel 渠道key
 */
+ (void)setChannelId:(nonnull NSString *)channel __attribute__((deprecated("JMLink 1.0.0 版本已废弃")));




+ (void)setMlinkEnable:(BOOL)enable __attribute__((deprecated("JMLink 1.0.0 版本已废弃")));

/**
 * 用来获得当前sdk的版本号
 * return 返回sdk版本号
 */
+ (nonnull NSString *)sdkVersion __attribute__((deprecated("JMLink 1.0.0 版本已过期")));

#pragma mark Campaign
/**
 *  获取UserAgent
 *  当使用自己的WebView打开活动的时候，需要修改UserAgent（新UserAgent=原UserAgent + SDK的UserAgent），用作数据监测和统计
 *  @param key 魔窗位key
 *  @return SDK的UserAgent
 */
+ (nullable NSString *)getUserAgentWithKey:(nonnull NSString *)key __attribute__((deprecated("JMLink 1.0.0 版本已废弃")));

/**
 *  获取活动相关配置信息
 *  适用于pushViewController
 *  @param key 魔窗位key
 *  @param view 展示活动简介的view
 *  @param success callback 当成功获取到该魔窗位上活动的时候会调用这个回调
 *  @param failure callback 当获取到该魔窗位上活动失败的时候会调用这个回调
 */
+ (void)configAdViewWithKey:(nonnull NSString *)key withTarget:(nonnull UIView *)view
                    success:(CallbackWithCampaignSuccess)success
                    failure:(CallbackWithCampaignFailure)failure __attribute__((deprecated("JMLink 1.0.0 版本已废弃")));

/**
 *  获取活动相关配置信息
 *  适用于presentViewController
 *  @param key 魔窗位key
 *  @param view 展示活动简介的view
 *  @param controller 展示活动简介的UIViewController
 *  @param success callback 当成功获取到该魔窗位上活动的时候会调用这个回调
 *  @param failure callback 当获取到该魔窗位上活动失败的时候会调用这个回调
 */
+ (void)configAdViewWithKey:(nonnull NSString *)key withTargetView:(nonnull UIView *)view withTargetViewController:(nonnull UIViewController *)controller
                    success:(CallbackWithCampaignSuccess)success
                    failure:(CallbackWithCampaignFailure)failure __attribute__((deprecated("JMLink 1.0.0 版本已废弃")));

/**
 *  获取活动相关配置信息
 *  适用于所有的UIViewController
 *  @param key 魔窗位key
 *  @param view 展示活动简介的view
 *  @param controller 展示活动简介的UIViewController
 *  @param success callback 当成功获取到该魔窗位上活动的时候会调用这个回调
 *  @param failure callback 当获取到该魔窗位上活动失败的时候会调用这个回调
 *  @param tap callback 当点击该魔窗位上活动的时候会调用这个回调，return YES 允许跳转，NO 不允许跳转
 */
+ (void)configAdViewWithKey:(nonnull NSString *)key withTargetView:(nonnull UIView *)view withTargetViewController:(nullable UIViewController *)controller
                    success:(CallbackWithCampaignSuccess)success
                    failure:(CallbackWithCampaignFailure)failure
                        tap:(nullable CallbackWithTapCampaign)tap __attribute__((deprecated("JMLink 1.0.0 版本已废弃")));

/**
 *  获取活动相关配置信息
 *  适用于所有的UIViewController
 *  @param key 魔窗位key
 *  @param view 展示活动简介的view
 *  @param controller 展示活动简介的UIViewController
 *  @param success callback 当成功获取到该魔窗位上活动的时候会调用这个回调
 *  @param failure callback 当获取到该魔窗位上活动失败的时候会调用这个回调
 *  @param tap callback 当点击该魔窗位上活动的时候会调用这个回调，return YES 允许跳转，NO 不允许跳转
 *  @param mLinkHandler callback 当活动类型为mlink的时候，点击的该活动的时候，会调用这个回调，return mlink需要的相关参数
 */
+ (void)configAdViewWithKey:(nonnull NSString *)key withTargetView:(nonnull UIView *)view withTargetViewController:(nullable UIViewController *)controller
                    success:(CallbackWithCampaignSuccess)success
                    failure:(CallbackWithCampaignFailure)failure
                        tap:(nullable CallbackWithTapCampaign)tap
               mLinkHandler:(nullable CallbackWithMLinkCampaign)mLinkHandler __attribute__((deprecated("JMLink 1.0.0 版本已废弃")));

/**
 *  获取活动相关配置信息
 *  适用于所有的UIViewController
 *  @param key 魔窗位key
 *  @param view 展示活动简介的view
 *  @param controller 展示活动简介的UIViewController
 *  @param success callback 当成功获取到该魔窗位上活动的时候会调用这个回调
 *  @param failure callback 当获取到该魔窗位上活动失败的时候会调用这个回调
 *  @param tap callback 当点击该魔窗位上活动的时候会调用这个回调，return YES 允许跳转，NO 不允许跳转
 *  @param mLinkHandler callback 当活动类型为mlink的时候，点击的该活动的时候，会调用这个回调，return mlink需要的相关参数
 *  @param landingPageHandler callback 当活动类型为mlink landing page的时候，点击的该活动的时候，会调用这个回调，return mlink landing page需要的相关参数
 */
+ (void)configAdViewWithKey:(nonnull NSString *)key withTargetView:(nonnull UIView *)view withTargetViewController:(nullable UIViewController *)controller
                    success:(CallbackWithCampaignSuccess)success
                    failure:(CallbackWithCampaignFailure)failure
                        tap:(nullable CallbackWithTapCampaign)tap
               mLinkHandler:(nullable CallbackWithMLinkCampaign)mLinkHandler
    mLinkLandingPageHandler:(nullable CallbackWithMLinkLandingPage)landingPageHandler __attribute__((deprecated("JMLink 1.0.0 版本已废弃")));

/**
 *  获取活动相关配置信息，支持A跳到B，B返回A，魔窗位即代表A
 *  适用于所有的UIViewController
 *  @param key 魔窗位key
 *  @param view 展示活动简介的view
 *  @param controller 展示活动简介的UIViewController
 *  @param callBackMLinkKey : mLink key ,当从B返回回来的时候，会根据mLink key来跳转到相应的页面
 *  @param success callback 当成功获取到该魔窗位上活动的时候会调用这个回调
 *  @param failure callback 当获取到该魔窗位上活动失败的时候会调用这个回调
 *  @param tap callback 当点击该魔窗位上活动的时候会调用这个回调，return YES 允许跳转，NO 不允许跳转
 *  @param mLinkHandler callback 当活动类型为mlink的时候，点击的该活动的时候，会调用这个回调，return mlink需要的相关参数
 *  @param landingPageHandler callback 当活动类型为mlink landing page的时候，点击的该活动的时候，会调用这个回调，return mlink landing page需要的相关参数
 *  @param mLinkCallBackParamas callback 当从B返回过来的时候，需要的相关参数
 */
+ (void)configAdViewWithKey:(nonnull NSString *)key withTargetView:(nonnull UIView *)view withTargetViewController:(nullable UIViewController *)controller WithCallBackMLinkKey:(nullable NSString *)callBackMLinkKey
                    success:(CallbackWithCampaignSuccess)success
                    failure:(CallbackWithCampaignFailure)failure
                        tap:(nullable CallbackWithTapCampaign)tap
                      mLinkHandler:(nullable CallbackWithMLinkCampaign)mLinkHandler
                mLinkLandingPageHandler:(nullable CallbackWithMLinkLandingPage)landingPageHandler
       MLinkCallBackParamas:(nullable CallbackWithReturnMLink)mLinkCallBackParamas __attribute__((deprecated("JMLink 1.0.0 版本已废弃")));

/**
 *  发送展现日志
 *  @param key 魔窗位key
 *  确定视图显示在window上之后再调用trackImpression，不要太早调用，在tableview或scrollview中使用时尤其要注意
 */
+ (void)trackImpressionWithKey:(nonnull NSString *)key __attribute__((deprecated("JMLink 1.0.0 版本已废弃")));

/**
 *  判断单个魔窗位上是否有活动
 *  @param mwkey 魔窗位key
 *  @return yes:有处于活跃状态的活动；no：没有处于活跃状态的活动
 */
+(BOOL)isActiveOfmwKey:(nonnull NSString *)mwkey __attribute__((deprecated("JMLink 1.0.0 版本已废弃")));

/**
 *  批量判断魔窗位上是否有活动
 *  @param mwKeys 魔窗位keys
 *  @return NSArray 有活动的魔窗位keys
 */
+(nullable NSArray *)mwkeysWithActiveCampign:(nonnull NSArray *)mwKeys __attribute__((deprecated("JMLink 1.0.0 版本已废弃")));

/**
 *  自动打开webView,显示活动
 *  只有在成功获取到活动信息的时候，该方法才有效
 *  @param key 魔窗位key
 *  @param view 展示活动简介的view
 */
+ (void)autoOpenWebViewWithKey:(nonnull NSString *)key withTargetView:(nonnull UIView *)view __attribute__((deprecated("JMLink 1.0.0 版本已废弃")));

/**
 *  判断是否发送webview的相关通知（进入webView，关闭webView）
 *  只有在成功获取到活动信息的时候，该方法才有效
 *  @param enable YES:打开，NO:关闭。默认状态为NO
 */
+ (void)setWebViewNotificationEnable:(BOOL)enable __attribute__((deprecated("JMLink 1.0.0 版本已废弃")));

/**
 *  是否自定义活动详情页面的导航条按钮
 *  @param enable YES:自定义，NO:不自定义。默认状态为NO
 */
+ (void)setWebViewBarEditEnable:(BOOL)enable __attribute__((deprecated("JMLink 1.0.0 版本已废弃")));

#pragma mark Custom event

/**
 *  标识某个页面访问的开始，在合适的位置调用,name不能为空。
 *  @param name 页面的唯一标示，不能为空
 */
+ (void)pageviewStartWithName:(nonnull NSString *)name __attribute__((deprecated("JMLink 1.0.0 版本已废弃")));

/**
 *  标识某个页面访问的结束，与pageviewStartWithName配对使用，name不能为空。
 *  @param name 页面的唯一标示，不能为空
 */
+ (void)pageviewEndWithName:(nonnull NSString *)name __attribute__((deprecated("JMLink 1.0.0 版本已废弃")));

/**
 * 自定义事件
 *  @param eventId 自定义事件的唯一标示，不能为空
 */
+ (void)setCustomEvent:(nonnull NSString *)eventId __attribute__((deprecated("JMLink 1.0.0 版本已废弃")));

/**
 * 自定义事件
 *  @param eventId 自定义事件的唯一标示，不能为空
 *  @param attributes 动态参数，最多可包含9个
 */
+ (void)setCustomEvent:(nonnull NSString *)eventId attributes:(nullable NSDictionary *)attributes __attribute__((deprecated("JMLink 1.0.0 版本已废弃")));


#pragma mark Location
/**
 *  设置经纬度信息
 *  @param latitude 纬度
 *  @param longitude 经度
 */
+ (void)setLatitude:(double)latitude longitude:(double)longitude __attribute__((deprecated("JMLink 1.0.0 版本已废弃")));

/** 
 *  设置经纬度信息
 *  @param location CLLocation 经纬度信息
 */
+ (void)setLocation:(nonnull CLLocation *)location __attribute__((deprecated("JMLink 1.0.0 版本已废弃")));

/**
 *  设置城市编码，以便获取相应城市的活动数据，目前仅支持到地级市
 *  国家标准的行政区划代码:http://files2.mca.gov.cn/www/201510/20151027164514222.htm
 *  @param code 城市编码
 */
+ (void)setCityCode:(nonnull NSString *)code __attribute__((deprecated("JMLink 1.0.0 版本已废弃")));

#pragma mark Share

/**
 *  处理第三方app通过URL启动App时传递的数据
 *  需要在 application:handleOpenURL中调用。
 *  @param url 启动App的URL
 *  @param delegate 用来接收第三方app触发的消息。
 *  @return 成功返回YES，失败返回NO。
 */
+ (BOOL)handleOpenURL:(nonnull NSURL *)url delegate:(nullable id)delegate __attribute__((deprecated("JMLink 1.0.0 版本已废弃,请使用JMLinkService类的routeMLink:方法")));

/**
 *  @deprecated This method is deprecated starting in version 3.66
 *  @note Please use @code handleOpenURL:delegate: @code instead.
 **/
+ (BOOL)handleOpenURL:(nonnull NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(nullable id)annotation delegate:(nullable id)delegate __attribute__((deprecated("JMLink 1.0.0 版本已废弃,请使用JMLinkService类的routeMLink:方法")));

#pragma mark mLink




/**
 *  A跳B，B判断是否需要返回A
 *  @return BOOL YES：需要返回，NO：不需要返回
 */
+ (BOOL)callbackEnable __attribute__((deprecated("JMLink 1.0.0 版本已废弃")));

/**
 *  A跳B，B返回A的时候，调用此方法
 *  @param params 返回A时需要传入的参数
 *  @return BOOL YES：成功返回，NO：失败
 */
+ (BOOL)returnOriginAppWithParams:(nullable NSDictionary *)params __attribute__((deprecated("JMLink 1.0.0 版本已废弃")));


@end
