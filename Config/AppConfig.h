//
//  Config.h
//  EstateBiz
//
//  Created by Ender on 10/21/15.
//  Copyright © 2015 Magicsoft. All rights reserved.
//

#ifndef Config_h
#define Config_h


#pragma mark - 服务器地址
#pragma mark - 中铁建服务器
#define CRCCBASE_URL_1 @"http://crcc.kakatool.cn:8091/api/" //中铁建正式服务器
//#define CRCCBASE_URL_1 @"https://crcc.kakatool.cn/api" //中铁建正式服务器(https)
#define CRCCBASE_URL_2  @"http://wttest.kakatool.cn:8080/api/"//中铁建测试服务器

#pragma mark - 卡卡兔服务器
#define KAKABASE_URL_1 @"https://api.kakatool.com/"//卡卡兔服务器
#define KAKABASE_URL_2 @"http://test.kakatool.cn:8082/"    //卡卡兔外部测试
#define KAKABASE_URL_3 @"http://gaoye.kakatool.com/"   //外部正式测试

#pragma mark - ice服务器
#define ICEBASE_URL_1 @"http://120.77.55.129:8081/v1/"//ice服务器

#define RAPBASE_URL_1 @"http://rap.taobao.org/mockjs/7227/"//rap服务器


#pragma mark - 公共参数
#define KAppId @"ICEYDSL0-5A04-4926-BDC8-51C3B3D27699"
#define kAppToken @"903E482F8AABB814130F"
#define KAppSignKay @"false"


#pragma mark - 接口

//不同社区应用不同，不区分appstore版本和企业版本
#define APP_ID @"124"

//如果是星生活appid=111，任享生活appid=118，乐享生活appid=121，则详情只有一页
#define IS_DONGHUA [APP_ID isEqualToString:@"111"] || [APP_ID isEqualToString:@"118"] || [APP_ID isEqualToString:@"121"]

//不同社区应用不同，区分appstore版本和企业版本
#define APP_PLATFORM @"appztfcios"

//appstore的appid（用于appstore版本升级）
#define APPSTOREID @"1130895254"

#pragma mark - 企业版本升级
#define CHECK_UPGRADE_URL @"v1/version/ver" //版本升级
#define CHECK_UPGRADE_URL_ICE  @"YDSL/version/update"
#pragma mark - 注册

//注册获取验证码
#define REGISTER_CODE @"v1/user/getsmscheckcode"
#define REGISTER_CHECK_CODE @"v1/user/checksmscheckcode"
#define REGISTER_URL @"v1/user/register"

#pragma mark - 登录

//登录
#define LOGIN_NORMAL @"v1/user/loginbykkt"
#define LOGIN_NORMAL_ICE @"YDSL/user/login"//ice登录接口
#define LOGIN_INVITECODE @"v1/user/login4invitecode"
#define LOGIN_COLORCLOUD @"v1/user/login4color"

#pragma mark - 首页
//动态功能栏
#define HOME_FUNCTIONLIST @"v1/module/get"

//获取天气信息
#define WEATHER_URL @"v1/weather/getbycommunity"
//更多界面功能栏
#define MORE_FUNCTIONLIST @"v1/module/more"

//功能栏公告列表
#define NOTICE_LIST @"v1/notice/getnotice"

//轮播广告
#define HOME_AD @"v1/notice/getadv"
#define HOME_ICEAD @"YDSL/member/banner/getBannerList"//轮播广告
#define HOME_ACTIVITY @"YDSL/member/activity/getActivityList"//活动栏
//用户能授权的所有小区
#define HOME_COMMUNITYALL @"v1/user/communityalllist"

//用户已授权的小区列表
#define HOME_COMMUNITYLIST @"v1/authorization/listCommunityCard"

//门禁授权
#define AUTHORITY_COMMUNITYLIST @"v1/user/communitylist"

//获取蓝牙开门权限
#define BLE_OPENDOOR_LIMIT @"v1/door/getofflinedoors"

//上传蓝牙开门纪录
#define BLE_OPENDOOR_LOG @"v1/door/offlineopenlog"

//小区信息
#define HOME_NOTICELIST @"v1/notice/getlastall"

//会员卡列表
#define HOME_CARDLIST @"v1/membercard/cardlist"
//退订商户卡
#define HOME_CARD_DELETE @"v1/membercard/removeonlinecard"
//推荐卡详情
#define HOME_RECOMMEND_CARD @"v1/membercard/get"

//收藏
//收藏列表
#define COLLECTCARD_LIST @"v1/favcard/getfavlist2"
//添加收藏
#define COLLECTCARD_ADD @"v1/favcard/addfav"
//移除收藏
#define COLLECTCARD_REMOVE @"v1/favcard/removefav"

//推荐卡列表
#define HOME_RECOMMANDCARD_LIST @"v1/membercard/recommendcard"

#pragma mark - 楼栋管家
#define HOME_EMPLOYEE_LIST @"YDSL/member/employee/search"//获取楼栋管家列表
#define HOME_EMPLOYEE_DETAIL @"YDSL/member/employee/detail"//获取楼栋管家详情
#define HOME_EMPLOYEE_BIND @"YDSL/member/employee/bind"//绑定楼栋管家
#define HOME_ENPLOYEE_UNBIND @"YDSL/member/employee/unbind"//解绑楼栋管家
#define HOME_EMPLOYEE_MESSAGE_LIST @"YDSL/member/message/search"//获取顾问消息列表
#define HOME_EMPLOYEE_MESSAGE_DETAIL @"YDSL/member/message/detail"//获取顾问消息详情


#define HOME_GETEMPLOYEE_MESSAGE_PUSH @"YDSL/member/message/count"//获取顾问消息的推送消息计数
#define HOME_CLEAREMPLOYEE_MESSAGE_PUSH @"YDSL/member/message/markRead"//会员清顾问消息的推送除消息计数

#define HOME_MYEMPLOYEE @"YDSL/member/employee/mine"//获取我的楼栋管家


#define HOME_COMMUNITY_LIST @"YDSL/member/communitys"//获取所有的小区列表


#pragma mark - 搜索会员卡

//搜索卡
#define SEARCH_MEMBERCARD_URL @"v1/membercard/search"
//热门搜索
#define SEARCH_HOTL_LIST @"v1/membercard/topsearch"


#pragma mark - 门禁

//是否有授权权限
#define ENTRANCE_ISGRANTED @"v1/authorization/isgranted"
//查询授权人
#define ENTRANCE_SEARCH_AUTH_USER @"v1/user/searchauthorizeduser"
//查询被授权人
#define ENTRANCE_SEARCH_USER @"v1/user/searchuser"
//申请
#define ENTRANCE_APPLY @"v1/apply/apply4mobile"
//再次申请
#define ENTRANCE_APPLY_AGAIN @"v1/apply/apply1"
//申请批复列表
#define ENTRANCE_APPROVE_LIST @"v1/authorization/getlist4top"
//申请批复(通过或拒绝)
#define ENTRANCE_APPLY_APPROVE @"v1/apply/approve"
//我的申请
#define ENTRANCE_APPLY_HISTORYLIST @"v1/authorization/getlist4topByToID"
//历史授权
#define ENTRANCE_APPLY_HISTORY @"v1/apply/gethistorylist"
//当前授权
#define ENTRANCE_CURRENT_AUTH @"v1/authorization/getlist"
//历史授权
#define ENTRANCE_AUTH_HISTORY @"v1/authorization/gethistorylist"
//授权
#define ENTRANCE_AUTH @"v1/authorization/authorize4mobile"
//再次授权
#define ENTRANCE_AUTH_AGAIN @"v1/authorization/authorize"
//取消授权
#define ENTRANCE_AUTH_CANCEL @"v1/authorization/unauthorize"
//开门
#define ENTRANCE_OPENDOOR @"v1/door/open"
//门信息
#define ENTRANCE_INFO @"v1/door/get"


#pragma mark - 楼盘

#define PROJECT_NEARESTCITY @"YDSL/member/resource/nearestCity"//最近有楼盘城市

#define PROJECT_LIST @"YDSL/member/project/search"//楼盘列表
#define PROJECT_DETAIL @"YDSL/member/project/detail"//楼盘详情
#define PROJECT_COLLECT @"YDSL/member/project/favorite"//收藏楼盘
#define PROJECT_CANCELCOLLECT @"YDSL/member/project/favoriteRevoke"//取消收藏楼盘
#define PROJECT_APPOINTMENT @"YDSL/member/appointment"//预约楼盘
#define PROJECT_GETOPTION @"YDSL/member/options/projectOptions"//获取会员项目列表搜索选项
#define PROJECT_SELECT_CITY @"YDSL/member/resource/regions"//选择城市

#define PROJECT_HOUSETYPE_LIST @"YDSL/member/houseType/list"//户型列表
#define PROJECT_HOUSETYPE_COLLECT @"YDSL/member/houseType/favorite"//户型收藏

#define PROJECT_HOUSETYPE_CANCELCOLLECT @"YDSL/member/houseType/favoriteRevoke"//取消户型收藏

#define PROJECT_APPOINTMENT_LIST @"YDSL/member/appointment/listByProject"//楼盘详情预约历史
#define PERSON_APPOINTMENT_LIST @"YDSL/member/appointment/listMine"//个人中心我的预约看房列表
#define CANCEL_APPOINTMENT @"YDSL/member/appointment/cancel"//取消预约
#define COMPLETE_APPOINTMENT @"YDSL/member/appointment/complete"//完成预约
#define PERSON_PROJECTCOLLECT_LIST @"YDSL/member/project/favoriteList"//楼盘收藏列表
#define PERSON_HOUSETYPECOLLECT_LIST @"YDSL/member/houseType/favoriteList"//户型收藏列表

#pragma mark - 消息中心

//消息列表
#define MSGCENTER_GETLIST_URL @"v1/messagecenter/getlist"
//未读列表
#define MSGCENTER_UNREAD_URL @"v1/messagecenter/getunreadlist"
//已读设置
#define MSGCENTER_SETREAD_URL @"v1/messagecenter/setread"
//未读统计
#define MSGCENTER_UNREADSTATISTICS_URL @"v1/messagecenter/countunread"
//删除消息
#define MSGCENTER_DELETE_URL @"v1/messagecenter/delmsg"
//设置全部信息已读
#define MSGCENTER_SETREAD_ALL @"v1/messagecenter/setallread"
//消息详情
#define MSGCENTER_MSG_DETAIL @"v1/messagecenter/getmsginfo"
//预约详情
#define MSGCENTER_BOOK_DETAIL @"v1/messagecenter/getappointmentinfo"
//反馈详情
#define MSGCENTER_FEEDBACK_DETAIL @"v1/messagecenter/getfeedbackinfo"

#pragma mark - 优惠券

#define COUPON_MYLIST_URL @"v1/coupon/getmylist"
#define COUPON_OVERDUE @"v1/coupon/getcouponlistbysnid4open"
#define COUPON_EXPIRELIST @"v1/coupon/getmyexpirelist"

#pragma mark - 推送

#define REGISTER_DEVICE_URL @"v1/pushtoken/regtoken"
#define UNREGISTER_DEVICE_URL @"v1/pushtoken/unregtoken"
//检查设备唯一性
#define CHECK_DEVICE_VALID_URL @"v1/pushtoken/checktoken"

#pragma mark - 设置

#define SETTING_COMMENT_URL @"v1/comment/add"

#pragma mark - 账号

#define WETOWN_USER_CHANGEPSW @"v1/user/changepasswd"
#define WETOWN_USER_UPDATE @"v1/user/update"
#define UWETOWN_USER_UPDATEMOBILE @"v1/user/updatemobile"

#pragma mark - 找回密码

#define FINDPWD_CHECKCODE @"v1/user/getcode4findpassword"
#define FINDPWD_RESETPWD @"v1/user/resetpassword"

#pragma mark - 我的铁豆

#define MYDROP_GETLEFTMONEY @"YDSL/member/pay/getLeftMoney"//获取剩余铁豆
#define MYDROP_GETINCOMELIST @"YDSL/member/pay/getIncomeList"//获取收入流水
#define MYDROP_GETPAYLIST @"YDSL/member/pay/getPayList"//获取支付流水

#define MYDROP_FORGETPWD_CHECKCODE @"YDSL/member/pay/sendsms"//忘记密码发送短信
#define MYDROP_SETPASSWORD @"YDSL/member/pay/modifyPassword"//设置密码
#define MYDROP_EXISTPASSWORD @"YDSL/member/pay/existPassword"//支付密码是否存在
#define MYDROP_GOVEMONEY @"YDSL/member/pay/giveMoney"//赠送铁豆
#define MYDROP_GETUSERINFO @"YDSL/member/userinfo" //获取转赠会员详情

#define MYDROP_GETGALLERY @"YDSL/member/tpluspay/check"//获取支付通道

#define MYDROP_SCAN_PAY @"YDSL/member/tpluspay/pay"//扫码铁豆支付
//扫码铁豆支付


#pragma mark - 小区（卡卡兔接口）

//搜索小区
#define COMMUNITY_SEARCH @"v1/community/search"

//最近的一个小区
#define COMMUNITY_NEAR @"v1/community/getnearestcommunity"

#pragma mark - 周边(卡卡兔接口)

//附件小区小区
#define SURROUNDING_NEARCOMMUNITY @"v1/community/getlocalcommunity"

//周边商户
#define SURROUNDING_NEARSHOP @"v1/community/searchbygis4open"


//小区列表
#define SURROUNDING_GETLIST @"v1/community/getlist"

#pragma mark - 支付
//查询在线支付信息
#define PAY_GETPARAM @"v1/kakapay/getparam"//订单信息
#define PAY_GETPREPAYMENT @"v1/kakapay/prepay"//预付单
#define PAY_GETLIST @"v1/bizorder/getlist"//在线支付订单列表
#define PAY_CHECK_KAKAPAY @"v1/kakapay/check"//是否支持在线支付

#define RECHARGE_GETCOMBO @"v1/rechargepackage/getlist"//获取充值套餐
#define RECHARGE_REPLAYCOMBO @"v1/rechargepackage/deposite"//申请充值
#define RECHARGE_GETCOMBOINFO @"v1/rechargepackage/getinfo"//获取充值套餐详情

#pragma mark - 燕山石化投诉与建议
//维修
#define YSSH_REPAIR_LISTUNCOMMENT @"yssh/maintain/listuncomments" //未评价订单列表
#define YSSH_REPAIR_COMMENT @"yssh/maintain/comments"//评价
#define YSSH_REPAIR_UNIT @"yssh/maintain/getunit"//个人维修获取单元地址信息
#define YSSH_REPAIR_SUBTYPE @"yssh/maintain/subtypes"//维修种类
#define YSSH_REPAIR_APPLY @"yssh/maintain/apply" //申请

//投诉与建议
#define YSSH_COMPLAINT_LISTUNCOMMENT @"yssh/complain/listuncomments" //未评价订单列表
#define YSSH_COMPLAINT_COMMENT @"yssh/complain/comments"//评价
#define YSSH_COMPLAINT_APPLY @"yssh/complain/apply" //申请

#pragma mark - 根据bid和cid获取会员卡

#define BIZSTORE_GET_SINGLE @"v1/bizstore/get4Open" //获取会员卡

#pragma mark-社区活动

#define COMACTIVITY_LISTCOMMUNITY @"v1/activity/listcommunity"//获取有活动的小区
#define COMACTIVITY_LISTACTIVITY @"v1/activity/listactivity"//获取小区的活动
#define COMACTIVITY_LISTJOIN @"v1/activity/listjoin"//获取已参加活动列表
#define COMACTIVITY_JOIN @"v1/activity/join"//报名参加
#define COMACTIVITY_GETINFO @"v1/activity/getinfo"//活动详情



//用户接口
//登录
#define USER_LOGIN_URL @"v1/user/login"

//邀请码登录
#define USER_LOGINREC_URL @"v1/user/loginv3"

//注册
#define USER_REGISTE_URL @"v1/user/register"
//注册2
#define USER_REGISTE2_URL @"v1/user/register2"

//注册3
#define USER_REGISTE3_URL @"v1/user/registerv3"

//注册获取验证码
#define USER_REGISTE3_SMSCODE_URL @"v1/user/getsmscheckcode"

//更新
#define USER_UPDATE_URL @"v1/user/update"
//详细信息
#define USER_USERDETAIL_URL @"v1/user/getuserdetailinfo"
//设置锁定密码
#define USER_SETPAYPASS_URL @"v1/user/setpaypass"
//取消锁定密码
#define USER_CANCELPAYPASS_URL @"v1/user/delpaypass"

//输入用户名密码取消锁定密码
#define USER_WITHACCOUNT_CANCELPAYPASS_URL @"v1/user/resetpaypass"

//设置用户Logo
#define UPDATE_USER_LOGO @"v1/user/updateavatar"
//修改密码
#define USER_CHANGEPASS_URL @"v1/user/changepasswd"

//(找回密码和修改密码)获取短信验证码
#define USER_GETSMSCHECKCODE @"v1/user/findpasswdv3"

//获取短信验证码
#define USER_GETCHECKCODE_MOBILE @"v1/user/getsmscheckcode"
//找回密码
#define USER_RESETPASSWORD_URL @"v1/user/resetpasswordv3"
//修改密码
#define USER_APP_RESETPASSWORD_URL @"v1/user/appresetpasswordv3"

//更新手机号码
#define USER_UPDATEMOBILE @"v1/user/updatemobile"

//验证验证码接口
#define USER_CHECKSMSCHECKCODE @"v1/user/checksmscheckcode"

//扫描三方平台二维码交易
#define TRANS_TRIPARTITEPLATFORM_URL @"v1/corp/qrcode"

//二维码交易接口
//确认交易
#define TRANSACTION_CONFIRM_URL @"v1/transaction/confirmtrsrequest"
//积分交易确认(新)
#define TRANSACTIONPOINTS_CONFIRM_URL @"v1/pointstransaction/confirmtrsrequest"

//二维码交易信息
#define TRANSACTION_DETAIL_URL @"v1/transaction/trsinfobytnum"
//积分二维码交易信息(新)
#define TRANSACTIONPOINTS_DETAIL_URL @"v1/pointstransaction/trsinfobytnum"
//根据代理商二维码获取交易号
#define FETCHTRANSNO_BYCODE @"v1/transaction/qrtrsrequest"

//交易列表
#define TRANSACTION_LIST_URL @"v1/transaction/trslist"
//消息中心->交易详情V3
#define TRANSACTION_TDETAIL_URL @"v1/transaction/trsinfov3"
//积分交易列表
#define POINTS_TRANSACTION_LIST_URL @"v1/pointstransaction/trslist"
//交易记录删除
#define TRANSACTION_EDIT @"v1/transaction/delete"
//积分交易详情
#define POINTS_TRANSACTION_DETAIL @"v1/pointstransaction/detailinfo4msgcenter"


//会员卡接口
//会员卡列表
#define CARDLIST @"v1/membercard/cardlist2"
//会员卡搜索
#define SEARCHCARD @"v1/membercard/searchcard"
//实体卡列表(新-冯万琦)
#define OFFLINE_CARDLIST @"v1/membercard/offlinecardlist"
//搜索实体卡
#define OFFLINE_SEARCH @"v1/membercard/offlinecardsearch"
//获取商户信息
#define SHOP_DETAIL_URL @"v1/membercard/getshopinfov3"
//加会员接口
#define ADDONLINECARD_URL @"v1/membercard/addonlinecard"
//领卡接口
#define TRANSFERCARD @"v1/membercard/transfercard"
//领卡获取信息
#define GETTEMPCARDINFO @"v1/membercard/gettempcardinfo"
//新增离线卡
#define ADDOFFLINECARD @"v1/membercard/addofflinecard"
//获取会员卡详细信息
#define GETCARDINFO @"v1/membercard/getcardinfo"
//更新离线卡
#define UPDATEOFFLINECARD @"v1/membercard/updateofflinecard"
//移除离线卡
#define REMOVEOFFLINECARD @"v1/membercard/removeofflinecard"
//退订商户卡
#define REMOVEONLINECARD @"v1/membercard/removeonlinecard"
//根据电话号码推荐卡
#define GETRECOMMENDCARD @"v1/membercard/getrecommendcard"
//批量领取卡
#define MEMBERCARD_TRANSFERMULTICARD @"v1/membercard/transfermulticard"
//推荐卡
#define BIZSTORE_LIST @"v1/bizstore/getrecommendlist"
//搜索卡
#define BIZSTORE_SEARCH @"v1/bizstore/search2"
//获取临时卡数量(新-冯万琦)
#define GETTEMPCARD_NUM @"v1/membercard/getrecommendcardnumrow"


//收藏
//收藏列表
#define FAVCARD_LIST_URL @"v1/favcard/getfavlist2"
//添加收藏
#define FAVCARD_ADD_URL @"v1/favcard/addfav"
//移除收藏
#define FAVCARD_REMOVE_URL @"v1/favcard/removefav"

//卡模板
//卡模板列表
#define CARDTEMPLATE_LIST_URL @"v1/cardtemplate/lists"
//更新卡模板
#define CARDTEMPLATE_UPDATE_URL @"v1/cardtemplate/updates"
//添加卡模板
#define CARDTEMPLATE_ADD_URL @"v1/cardtemplate/add"
//移除卡模板
#define CARDTEMPLATE_REMOVE_URL @"v1/cardtemplate/removetemplate"
//搜索卡库列表
#define CARDTEMPLATE_SEARCH_URL @"v1/cardtemplate/search"
//获取卡详细
#define CARDTEMPLATE_GETINFO_URL @"v1/cardtemplate/getinfo"

//会员反馈
//添加会员反馈
#define MEMBERFEEDBACK_ADD_URL @"v1/membercard/feedback"
//会员反馈列表
#define MEMBERFEEDBACK_LIST_URL @"v1/feedback/getlistbybid"
#define MEMBERFEEDBACK_DETAIL_URL @"v1/feedback/detailinfo4msgcenter"

//预约
//添加预约
#define APPOINTMENT_ADD_URL @"v1/membercard/appointment"
//预约列表
#define APPOINTMENT_GETLIST_URL @"v1/appointment/getlistbybid"
//预约详情
#define APPOINTMENT_DETAILINFO_URL @"v1/appointment/detailinfo4msgcenter"

//推送信息
#define REGISTER_DEVICE_URL @"v1/pushtoken/regtoken"
#define UNREGISTER_DEVICE_URL @"v1/pushtoken/unregtoken"
#define CHECK_DEVICE_VALID_URL @"v1/pushtoken/checktoken" //检查设备唯一性

//获取推送计数器
#define FETCHPUSHAMOUNTS @"v1/bizmessage/checkmsg"
#define FETCHPUSHAMOUNTS_ICE @"YDSL/member/message/count"
//清空推送计数器
#define CLEARPUSHAMOUNTS @"v1/bizmessage/checkmsgupdate"
#define CLEARPUSHAMOUNTS_ICE @"YDSL/member/message/markRead"

//订单列表
#define BIZORDER_ORDERLIST_URL @"v1/bizorder/getlist"
//订单详情
#define BIZORDER_ORDERDETAIL_URL @"v1/bizorder/getinfo"
//取消订单
#define BIZORDER_CANCLEORDER_URL @"v1/bizorder/cancel"


//卡信息
//卡包信息
#define CARDMSG_TEMPONLINEMSGLIST_URL @"v1/bizmessage/gettemponlinelistmsg"
//商户卡信息
#define CARDMSG_ONLINECARDMSGLIST_URL @"v1/bizmessage/getonlinecardmsg2"
//信息详情
#define CARDMSG_INFO_URL @"v1/bizmessage/getmsginfo"

//投票（新-冯万琦）
#define CARDMSG_VOTE_URL @"v1/vote/checked"

//活动（新-冯万琦）
#define CARDMSG_EVENT_URL @"v1/events/selected"

//优惠券
//获取我的优惠码列表
#define COUPON_GETMYLIST @"v1/coupon/getmylist"
//获取发送给我优惠券的所有商户（原在我的优惠券里面，后废除）
#define COUPON_GETBIZLIST @"v1/coupon/getbizlist"
//获取单个优惠码信息
#define COUPON_GETINFO @"v1/coupon/getinfo"
//转让优惠码（单个）
#define COUPON_GIVETOFRIENDS @"v1/coupon/giventofriends"
//转让优惠码（多个）
#define COUPON_GIVEMUTISN @"v1/coupon/givenmultitofriends"

//消息中心：优惠券详情
#define COUPON_DETAIL_URL @"v1/coupon/getinfobysnid"

//扫描优惠券二维码，领取优惠券
//优惠券信息
#define COUPON_INFO_URL @"v1/coupon/getinfo4scan"
//领取优惠券
#define COUPON_GET_URL @"v1/coupon/push4scan"

//消息中心
//消息列表
#define MSGCENTER_GETLIST_URL @"v1/messagecenter/getlist"
//未读列表
#define MSGCENTER_UNREAD_URL @"v1/messagecenter/getunreadlist"
//已读设置
#define MSGCENTER_SETREAD_URL @"v1/messagecenter/setread"
//未读统计
#define MSGCENTER_UNREADSTATISTICS_URL @"v1/messagecenter/countunread"
//删除消息
#define MSGCENTER_DELETE_URL @"v1/messagecenter/delmsg"


#pragma mark - 分享秘钥
//share
//#define AMAP_KEY  @"df0343dd597c2d1488860f387307633a"
#define AMAP_KEY    @"OozGwWQOd3cU1ppBlssTPS5vkAmN7rm7"
#define SHARE_SDK_KEY @"1412828a960c8"
#define SINA_SHARE @"91780073"
#define SINA_SHARE_SECRET @"327a3fe9e2865ed9636ca6673d432354"
#define QQ_SHARE_KEY @"1105447287"
#define QQ_SHARE_SECRET @"mYBLk7K2O3K6ZT4Q"
#define WECHAT_SHARE_KEY @"wx67d01793352b8f0e"
#define WECHAT_SECRET_KEY @"4aa43624d890e57eb2e7c739a77f9e48"

#define WECHAT_PAY_KEY @"wxcb08a8fbccb51cd6"
#define ALI_PAY_KEY @"alipayappztfc124"

typedef NS_ENUM(NSUInteger, LIMITYACTIVITY_STYLE) {
    LIMITYACTIVITY_STYLE_DEFAULT1 = 1, // 样式1
    LIMITYACTIVITY_STYLE_DEFAULT2 = 2, // 样式2
    LIMITYACTIVITY_STYLE_DEFAULT3 = 3, // 样式3
    LIMITYACTIVITY_STYLE_DEFAULT4 = 4, // 样式4
    LIMITYACTIVITY_STYLE_DEFAULT5 = 5, // 样式5
    LIMITYACTIVITY_STYLE_DEFAULT6 = 6, // 样式6
    LIMITYACTIVITY_STYLE_DEFAULT7 = 7, // 样式7
    LIMITYACTIVITY_STYLE_DEFAULT8 = 8, // 样式8
    LIMITYACTIVITY_STYLE_DEFAULT9 = 9, // 样式9
};




#endif /* Config_h */
