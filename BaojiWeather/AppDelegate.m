//
//  AppDelegate.m
//  BaojiWeather
//
//  Created by Tcy on 2017/2/15.
//  Copyright © 2017年 Tcy. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"

//#import "SocketCenter.h"

#import <AMapFoundationKit/AMapFoundationKit.h>


@interface AppDelegate ()<QQApiInterfaceDelegate,WeiboSDKDelegate>
@property (nonatomic) NSString *wxAppId;
@property (nonatomic) NSString *xlAppId;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self monitoringNetworkStatus];
    self.window.backgroundColor = [UIColor whiteColor];
    
    MainViewController *centerVC = [[MainViewController alloc] init];
    UINavigationController *centerNC = [[UINavigationController alloc] initWithRootViewController:centerVC];
    
    self.window.rootViewController = centerNC;
    
    [self.window makeKeyAndVisible];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    _wxAppId=@"";
    [[AMapServices sharedServices] setEnableHTTPS:YES];
    //[[SocketCenter sharedInstance] connect];
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isclear"];

    [[TencentOAuth alloc] initWithAppId:qqAppId andDelegate:nil]; //注册
    [WeiboSDK enableDebugMode: YES];
    [WeiboSDK registerApp:wbKey];
    [AMapServices sharedServices].apiKey =@"96e9f614a8be6823cec78a4e339e2dc0";
    return YES;
}
- (void)monitoringNetworkStatus {
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        self.status = status;
        if (NetWorkStatus==0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"未连接互联网，请检查网络连接" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    }];
    [manager startMonitoring];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    return [TencentOAuth HandleOpenURL:url]||[WeiboSDK handleOpenURL:url delegate:self];
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return [TencentOAuth HandleOpenURL:url]||[WeiboSDK handleOpenURL:url delegate:self];
}
- (BOOL)application:(UIApplication *)application openURL:(nonnull NSURL *)url options:(nonnull NSDictionary<NSString *,id> *)options {
    // 因为在我们的应用中可能不止实现一种分享途径，可能还有微信啊 微博啊这些，所以在这里最好判断一下。
    // QQAPPID:是你在QQ开放平台注册应用时候的AppID
    NSDictionary * dic = options;
    NSLog(@"%@", dic);
    if ([options[UIApplicationOpenURLOptionsSourceApplicationKey] isEqualToString:@"com.sina.weibo"]) {
        
        return [WeiboSDK handleOpenURL:url delegate:self];
    }else if ([options[UIApplicationOpenURLOptionsSourceApplicationKey] isEqualToString:@"com.tencent.xin"]){
        
       // return [WXApi handleOpenURL:url delegate:[WTShareManager shareWTShareManager]];
    }else if ([options[UIApplicationOpenURLOptionsSourceApplicationKey] isEqualToString:@"com.tencent.mqq"]){
        
        return [TencentOAuth HandleOpenURL:url];
    }
    return YES;
    
    
    
//    if ([url.scheme isEqualToString:_wxAppId]) {
//       // return [WXApi handleOpenURL:url delegate:self];
//        return nil;
//    }else if ([url.scheme isEqualToString:[NSString stringWithFormat:@"tencent%@",qqAppId]]) {
//        return [QQApiInterface handleOpenURL:url delegate:self];
//    }else {
//        return YES;
//    }
}



-(void)didReceiveWeiboRequest:(WBBaseRequest *)request{}
/**
 收到一个来自微博客户端程序的响应
 
 收到微博的响应后，第三方应用可以通过响应类型、响应的数据和 WBBaseResponse.userInfo 中的数据完成自己的功能
 @param response 具体的响应对象
 */
- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    /**
     
     WeiboSDKResponseStatusCodeSuccess               = 0,//成功
     WeiboSDKResponseStatusCodeUserCancel            = -1,//用户取消发送
     WeiboSDKResponseStatusCodeSentFail              = -2,//发送失败
     WeiboSDKResponseStatusCodeAuthDeny              = -3,//授权失败
     WeiboSDKResponseStatusCodeUserCancelInstall     = -4,//用户取消安装微博客户端
     WeiboSDKResponseStatusCodePayFail               = -5,//支付失败
     WeiboSDKResponseStatusCodeShareInSDKFailed      = -8,//分享失败 详情见response UserInfo
     WeiboSDKResponseStatusCodeUnsupport             = -99,//不支持的请求
     WeiboSDKResponseStatusCodeUnknown               = -100,
     */
    
    if (response.statusCode == WeiboSDKResponseStatusCodeSuccess) {
        //NSLog(@"微博----分享成功!!!");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"新浪微博分享成功" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];

    }else if(response.statusCode == WeiboSDKResponseStatusCodeUserCancel)
    {
        //        NSLog(@"微博----用户取消发送");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"取消分享" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];

    }else if (response.statusCode == WeiboSDKResponseStatusCodeSentFail){
        //        NSLog(@"微博----发送失败!");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"新浪微博分享失败" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];

    }
    
    
    //    NSLog(@"%@", response);
}


#pragma mark - WXApiDelegate 从微信那边分享过来传回一些数据调用的方法


/*! @brief 发送一个sendReq后，收到微信的回应
 *
 * 收到一个来自微信的处理结果。调用一次sendReq后会收到onResp。
 * 可能收到的处理结果有SendMessageToWXResp、SendAuthResp等。
 * @param resp具体的回应内容，是自动释放的
 */
//-(void) onResp:(BaseResp*)resp
//{
//    
//    // 成功回来
//    // errCode  0
//    // type     0
//    
//    // 取消分享回来
//    // errCode -2
//    // type 0
//    
//    if (resp.errCode == WTShareWeiXinErrCodeSuccess) {
//        //        NSLog(@"微信----分享成功!!");
//        self.shareResultlBlock(@"微信----分享成功!!");
//    }else{
//        //        NSLog(@"微信----用户取消分享!!");
//        self.shareResultlBlock(@"微信----用户取消分享!!");
//    }
//    //    NSLog(@"%@", resp);
//    
//}


#pragma mark -- QQApiInterfaceDelegate
// 处理来自QQ的请求，调用sendResp
- (void)onReq:(QQBaseReq *)req {
    
}

// 处理来自QQ的响应，调用sendReq
- (void)onResp:(QQBaseReq *)resp {
    switch (resp.type)
    {
        case ESENDMESSAGETOQQRESPTYPE:
        {
            SendMessageToQQResp* sendResp = (SendMessageToQQResp*)resp;
            if ([sendResp.result isEqualToString:@"0"]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"成功" message:@"QQ分享成功" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
            else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"失败" message:@"QQ分享失败" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
            break;
        }
        default:
        {
            break;
        }
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.lanou3g.ThreeViewsText" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"ThreeViewsText" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"ThreeViewsText.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
