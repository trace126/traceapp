//
//  TKWebViewController.m
//  tracedemo
//
//  Created by cmcc on 16/3/16.
//  Copyright © 2016年 trace. All rights reserved.
//

#import "TKWebViewController.h"
#import "UIColor+TK_Color.h"
#import "Masonry.h"
#import "TKProxy.h"
#import "WebViewJavascriptBridge.h"
#import "TKPayProxy.h"



@interface TKWebViewController ()<UIWebViewDelegate>
{
    WebViewJavascriptBridge * bridge;
    bool load;

}



@end


@implementation TKWebViewController



+(void)showWebView:(NSString *)title url:(NSString *) url
{
    TKWebViewController *vc = [[TKWebViewController alloc] init];
    vc.hidDefaultBackBtn = NO;
    if(![url containsString:@"http"])
    {
        url = [[TKProxy proxy].tkBaseUrl stringByAppendingString:url];
        
    }
    vc.defaultURL = url;
    [[AppDelegate getMainNavigation] pushViewController:vc animated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self initView];
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(load)
    {
        [self.webView reload];
        
    }
    else
    {
        load = YES;
    }
}



-(void)initView
{
    self.webView.backgroundColor = [UIColor tkThemeColor1];
    [self.view addSubview:self.webView];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
        
    }];
    
    bridge = [WebViewJavascriptBridge bridgeForWebView:_webView webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"ObjC received message from JS: %@", data);
        responseCallback(@"Response for message from ObjC");
    }];
    WS(weakSelf)
    [bridge registerHandler:@"hiifitFunction" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSDictionary * dic = (NSDictionary *)data;
        NSString * actionString = [dic objectForKey:@"action"];
        [weakSelf handleJSONString:actionString withData:[dic objectForKey:@"data"]];
        
    }];
    
    NSURL * url = [NSURL URLWithString:_defaultURL];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    self.webView.scalesPageToFit = YES;
    [self.webView loadRequest:request];
}

-(UIWebView *)webView
{
    if(!_webView)
    {
        _webView = [[UIWebView alloc] init];
    }
    return _webView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    bridge = nil;
}

#pragma mark - PrivateFunction
/*
 hiifitJSBridge("hiifitFunction","howToMake",JSON.stringify({}));						//直达如何赚嗨豆
 hiifitJSBridge("hiifitFunction","color",JSON.stringify({"color":"#FFF000"}));		//标题栏颜色
 hiifitJSBridge("hiifitFunction","title",JSON.stringify({"title":"xxxxxxx"}));			//标题
 hiifitJSBridge("hiifitFunction","shareBtn",JSON.stringify({"hidden":false, "title":"title", "desc":"desc", "pic":"pic", "link":"link"}));			//标题栏是否展示分享按钮及分享按钮内容
 
 hiifitJSBridge("hiifitFunction","backToWhere",JSON.stringify({"url":"https://183.13.131.113:8080/CloudHealth/web/hiishop/index.html"}));
 hiifitJSBridge("hiifitFunction","backToWhere",JSON.stringify({"url":"home","data":{"webview":"1","schemeId":2,"isTested":isSelect,"finish":1}}));
 //为后退按钮添加事件，直达某页面或URL，page和url同时只会有一个值不为"",如果为url，清除webview历史记录，data中为原生页面相关参数，其中webview为必选项，=1时关闭当前webview，=0时保留当前webview
 hiifitJSBridge("hiifitFunction","clickToWhere",JSON.stringify({"url":"https://183.13.131.113:8080/CloudHealth/web/hiishop/index.html"}));
 hiifitJSBridge("hiifitFunction","clickToWhere",JSON.stringify({"url":"home","data":{"webview":1,"schemeId":2,"isTested":isSelect,"finish":1}}));
 //直接触发页面变化，直达某页面或URL，page和url同时只会有一个值不为"",如果为url，清除webview历史记录,data中为原生页面相关参数，其中webview为必选项，=1时关闭当前webview，=0时保留当前webview
 */
/*以下两个接口废止，统一通过clickToWhere调用
 hiifitJSBridge("hiifitFunction","seniorPlan",JSON.stringify({"schemeId":2,"isTested":isSelect,"finish":1}));//跳转到id为2，订阅情况为isSelect的原生方案页面
 hiifitJSBridge("hiifitFunction","moment",JSON.stringify({"modelId ":10000,"type":2,"finish":1}));	//跳转到心情贴发帖
 */
- (void)handleJSONString:(NSString *)actionString withData:(NSDictionary *)dataDic
{
    DDLogInfo(@"webcallBack %@  action %@",dataDic, actionString);
    
    if([@"pay" isEqualToString:actionString])// 支付
    {
        TK_PayArg * arg = [[TK_PayArg alloc] init];
        NSString * str = [dataDic objectForKey:@"fundType"];
        arg.fundType = [str integerValue];
        arg.payAmount = [dataDic objectForKey:@"payAmount"];
        arg.bigMoney = 0;
        arg.postrewardId = [dataDic objectForKey:@"postrewardId"];
        [TKPayProxy pay:arg withBlick:^(NSInteger result) {
           
            DDLogInfo(@"pay for web page , result = %ld",result);
        }];
    }
    else if([@"linkToNewWindow" isEqualToString:actionString]) // 打开新窗口
    {
        NSString * relativeUrl = [dataDic objectForKey:@"url"];
        [TKWebViewController showWebView:@"订单详情" url:relativeUrl];
        
    }
    
    
//    //改变navigation的背景色
//    if ([actionString isEqualToString:kColor]) {
//        [self changeNavigationColor:[dataDic objectForKey:kColor]];
//    }
//    //改变navigation的title
//    if ([actionString isEqualToString:kTitle]) {
//        //[self addNavigationTitle:[dataDic objectForKey:kTitle]];
//        //        [self.flashView setText:[dataDic objectForKey:kTitle]];
//    }
//    //是否在webview右上角添加分享按钮
//    if ([actionString isEqualToString:kShareBtn]) {
//        [self showShareButton:dataDic];
//    }
//    //load如何赚嗨豆的界面
//    if ([actionString isEqualToString:kHowToMake]) {
//        //        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:KGainHiBean]]];
//    }
//    //直接出发某个界面的更新
//    if ([actionString isEqualToString:kBackToWhere]) {
//        [self backToWhere:dataDic];
//    }
//    //点击按钮回退到某个新的url或进入iOS原生界面
//    if ([actionString isEqualToString:kClickToWhere]) {
//        [self clickButtonToWhere:dataDic];
//    }
//    //分享框弹出
//    if ([actionString isEqualToString:kShare]) {
//        [self showShareView:dataDic];
//    }
//    //友盟事件
//    if ([actionString isEqualToString:kUmeng]) {
//        [self doUmengEvent:[dataDic objectForKey:@"data"]];
//    }
//    //打开一个新的webview玩儿
//    if ([actionString isEqualToString:kNewWeb]) {
//        [self openNewWeb:dataDic];
//    }
}

@end
