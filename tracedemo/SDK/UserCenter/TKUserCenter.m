//
//  TKUserCenter.m
//  tracedemo
//
//  Created by cmcc on 15/11/11.
//  Copyright © 2015年 trace. All rights reserved.
//

#import "TKUserCenter.h"
#import "TK_LoginAck.h"
#import "GlobNotifyDefine.h"

@interface TKUser(){

    
}

@end
@implementation TKUser



@end

@interface TKUserCenter(){

}

@property(nonatomic,strong,readwrite)TKUser * user;
@end

@implementation TKUserCenter


SYNTHESIZE_SINGLETON_FOR_CLASS_PROTOTYPE(TKUserCenter,instance);


-(TKUser *)user{

    if(!_user){
    
        _user  = [[TKUser alloc] init];
    }
    return _user;
}

-(TKUser *)tempUserData{

    if(!_tempUserData){
    
        _tempUserData = [[TKUser alloc] init];
    }
    return _tempUserData;
}


-(BOOL)isLogin{
    return self.user && self.user.isLogin;
}

-(void)onLoginSuccess:(TKUser *)user{
    
    self.user  = user;
    self.user.isLogin = YES;
    // TODO test 下面是测试代码
    self.user.address = @"浙江省杭州市西湖区西溪路555号7号楼401";
    self.user.signature = @"走自己的路，让别人的BB吧";
    self.user.headPortraitUrl = TKDefaultHead;
    [[NSNotificationCenter defaultCenter] postNotificationName:TKUserLoginSuccess object:nil];
}



-(void)doLogin:(NSString *)userName password:(NSString *)password{

    
    //deviceId=123&mobile=18867102687&password=123456
    [[TKProxy proxy].userProxy login:@"18867102687" withValue:@"123456" withBlock:^(HF_BaseAck * ack){
        if(ack.sucess){
            TK_LoginAck * loginAck = (TK_LoginAck *)ack;
            LoginAckData * loginData = (LoginAckData *)loginAck.data;
            TKUser * user = [[TKUser alloc] init];
            user.userId = loginData.id;
            user.nickName = loginData.nickName;
            user.mobile = loginData.mobile;
            user.signature = loginData.signature;
            user.headPortraitUrl = loginData.headerUrl;
            [self performSelectorOnMainThread:@selector(onLoginSuccess:) withObject:user waitUntilDone:NO];

        }
        
    }];

}

-(void)initFromLocalHistory{
    _user = [[TKUser alloc] init];
    _user.userId = @"100000";
    _user.nickName = @"trace990";
}

-(TKUser *)getUser{

    return _user;
}

-(TK_UserNormalViewModel *)userNormalVM{

    if(!_userNormalVM){
    
        _userNormalVM = [[TK_UserNormalViewModel alloc] init];
    }
    return _userNormalVM;
    
}

@end