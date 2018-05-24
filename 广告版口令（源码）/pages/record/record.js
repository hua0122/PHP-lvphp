//record.js
//获取应用实例
const app = getApp();
Page({
  data: {
    userInfo: {},
    hasUserInfo: false,
    canIUse: wx.canIUse('button.open-type.getUserInfo'),
    lists: [
      {
        nam:"共发出",
        je:"0.00",  // 总金额
        sl:"0",    // 总数量
        adv: {},    // 平台广告
        ls:[      // 发出的包列表
          // {
          //   quest:"恭喜发财",    // 口令
          //   id: 5,         // id
          //   enve_type: 0     // 
          //   show_amount:"1.00",          // 发出的金额
          //   add_time:"09月21日 20:06",    // 时间
          //   num: 3,           // 总个数
          //   receive_num: 3     // 已领取个数
          // }
        ]
      },{
        nam: "共收到",     
        je: "0.00",       // 收到的总金额
        sl: "0",         // 收到的个数
        adv: {},        // 平台广告
        ls: [      // 收到列表
          // {
          //   id:32,
          //   head_img: "https://wx.qlogo.cn/mmopen/vi_32/DYAIOgq83eq4Jsic8dPLibDhG0U6QHsSU5rsZriaWvCzsq3Cvic92lyntBepemiaM2hlXdjT3MTtrkhnbR2CIBb118A/0",     //  发的人微信头像链接
          //   nick_name: "豆腐干",      //  发的人微信名称
          //   receive_answer: 6,          // id
          //   receive_amount: "10.00",       //  拆包的金额
          //   best: 1,          //判断是否为最佳手气，1为最佳
          //   add_time: "09月22日 12:22"       // 时间
          // }
        ]
      }
    ],  //
    redPackettype: ['口令红包', '祝福红包', '问答红包'],
    pagel: 0,      //  发出的 页数
    pager: 0,      //  收到的 页数
    lower0: true,      //  触底加载控制器
    lower1: true,      //  触底加载控制器
    indicatorDots: false,   // 滑块参数
    duration: 500,      // 切换时间 
    current:0,     // 切换指数
    platformAdvImg: "/images/adv.png" //平台广告图片
    
  },
  //事件处理函数
  bindchange: function (e) {
    var ii = e.detail.current;
    this.setData({
      current: ii
    })      
    if (ii == 1 && this.data.pager == 0){
      this.loaddatar(); 
    }else if(ii == 0 && this.data.pagel == 0){
      this.loaddatal(); 
    }
  },
  // 触底加载数据
  lower:function(e){
    var that = this;
    var cd = e.target.dataset.current;
    if (this.data.lower0 && cd == 0){
      this.setData({
        lower0: false
      })
      this.loaddatal(); 
    }
    if (this.data.lower1 && cd == 1) {
      this.setData({
        lower1: false
      })
      this.loaddatar();
    }

  },
  //拨打电话
  tel: function () {
    wx.makePhoneCall({
      phoneNumber: '020-22096568'
    })
  },
  swichNav: function (e) {
    var that = this;
    if (this.data.current == e.currentTarget.dataset.current) {
      return false;
    } else {
      that.setData({
        current: e.currentTarget.dataset.current
      })
    }
  },
  bindtaphelp: function () {
    wx.navigateTo({
      url: '../help/help'
    })
  },
  onLoad: function () {
    var info = app.globalData.userInfo,
        tok = app.globalData.token;
    if (!info) {
      app.userInfoReadyCallback = res => {
        this.setData({
          userInfo: res.userInfo,
          token: tok,
          hasUserInfo: true
        })
      }
    } else {
      this.setData({
        userInfo: info,
        token: tok,
        hasUserInfo: true
      })
    }
    this.loaddatal();
  },

  // 发出的数据 加载
  loaddatal:function(){
    wx.showLoading({
      title: '加载中•••'
    })
    var tok = this.data.token;
    var postUrl = app.setConfig.url + '/index.php?g=Api&m=Enve',
        pag = this.data.pagel + 1,
        postData = {
          page: pag,
          token: tok
        };
    app.postLogin(postUrl, postData, this.initial); 
  },
  // 发出的
  initial: function (res) {
    if (res.data.code == 20000) {
      var datas = res.data;
      if (datas.data.length==0){
        this.setData({
          pagel: -1
        })
        return false;
      }
      var list0 = this.data.lists[0],
          list1 = this.data.lists[1],
          pagel = this.data.pagel+1;
      list0.je = datas.sum_info.sum_money;
      list0.sl = datas.sum_info.sum_num;
      list0.adv = datas.sum_info.adv;
      list0.ls = list0.ls.concat(datas.data);
      wx.hideLoading()
      this.setData({
        lists:[list0,list1],
        pagel: pagel,
        lower0: true
      })

    }
  },
  // 收到的数据 加载
  loaddatar:function(){
    wx.showLoading({
      title: '加载中•••'
    })
    var tok = this.data.token;
    var postUrl = app.setConfig.url + '/index.php?g=Api&m=Enve&a=reciveList',
        pag = this.data.pager + 1,
        postData = {
          page: pag,
          token: tok
        };
    app.postLogin(postUrl, postData, this.reciveList); 
  },
  //收到的包
  reciveList:function(res){
    if (res.data.code == 20000){
      var datas = res.data;
      if (datas.data.length == 0) {
        this.setData({
          pager: -1
        })
        return false;
      }
      var list0 = this.data.lists[0],
          list1 = this.data.lists[1],
          pager = this.data.pager + 1;
      list1.je = datas.sum_info.sum_money;
      list1.sl = datas.sum_info.sum_num;
      list1.adv = datas.sum_info.adv;
      list1.ls = list1.ls.concat(datas.data);
      wx.hideLoading();
      this.setData({
        lists: [list0, list1],
        pager:pager,
        lower1: true
      })
    }
  }
})
