// pages/squareHome/squareHome.js
//获取应用实例
const app = getApp();
Page({
  data: {
    allredPacket: '全部红包',
    rank: '综合排序',
    selectArea1: false,     // 红包类别筛选下拉框 true-开启
    selectArea2: false,     //  排序选择下拉框  true-开启
    hideedarkbg: true,    // 遮罩层 true为隐藏
    redPackettype: ['口令红包', '祝福红包', '问答红包'],

    redPacketList:[
      // {
      //   id: '5',            // 包id
      //   mode: 0,     //  模式控制参数
      //   advert: true,        // 广告开关
      //   adv_text: '广告语广告语广告语广告语广告语广告语广告语广告语',    // 广告语
      //   adimgsrc: 'https://hb.gzzh.co/adv_envelop/data/upload/adv/20171215/5a33a1c249fea.jpg',       // 图片路径
      //   ownerImg: '',           // 包主 头像
      //   ownerName: '东华大哥',       //包主 名字
      //   ownerzje: '10.00',      //包主 总金额
      //   num: vos[i].num,                // 总个数
      //   receive_num: vos[i].receive_num,    //领取个数
      //   senderDate: '12月12号 21：30'  //发送时间
      // }
    ],

    userInfo: {},
    hasUserInfo: false,
    canIUse: wx.canIUse('button.open-type.getUserInfo'),
    token: '',       //  用户登录
    advpt: {
      slide_id: '1',
      slide_pic: '/images/adv.png',
      slide_url: ''
    }, //   平台广告
    page:0,
    lower: true,      //  触底加载控制器
    PullDown:false,     // 是否下拉刷新
    Packetvalue1: 0,
    Packetvalue2: 0,
    Packetrange1: ["全部红包", "口令红包", "祝福红包", "问答红包", ],
    selections1: [-1,0,1,2],
    Packetrange2: ["综合排序", "最大金额", "最小金额", "最新发布", "最早发布"],
    selections2: ["", "show_amount_desc", "show_amount_asc","add_time_desc" ,"add_time_asc"],
    relay: '向你分享了一个口令红包广场 >>',    // 转发后显示的提示语
  },
  //点击选择红包类型
  clickredPacket: function () {
    var selectArea1 = this.data.selectArea1;
    if (!selectArea1) {
      this.setData({
        selectArea1: true,
        selectArea2: false,
        hideedarkbg: false,
      })
    } else {
      this.setData({
        selectArea1: false,
        hideedarkbg: true,
      })
    }
  },
  //点击选择综合排序
  clickrank: function () {
    var selectArea2 = this.data.selectArea2;
    if (!selectArea2) {
      this.setData({
        selectArea2: true,
        selectArea1: false,
        hideedarkbg: false,
      })
    } else {
      this.setData({
        selectArea2: false,
        hideedarkbg: true,
      })
    }
  },
  //点击切换
  mySelect1: function (e) {
    var i = parseFloat(e.target.dataset.range);
    this.setData({
      Packetvalue1: i,
      selectArea1: false,
      hideedarkbg: true,
      page: 0,
      lower: true
    })
    this.loaddatal();
  },
  mySelect2: function (e) {
    var i = parseFloat(e.target.dataset.range);
    this.setData({
      Packetvalue2: i,
      selectArea2: false,
      hideedarkbg: true,
      page: 0,
      lower: true
    })
    this.loaddatal();
  },
  //触底加载事件
  onReachBottom:function(e){
    if (this.data.lower) {
      this.setData({
        lower: false
      })
      this.loaddatal();
    }
  },
  // 转发
  onShareAppMessage: function (res) {
    var title = this.data.userInfo.nickName + ' ' + this.data.relay;
    if (res.from === 'button') {
      // 来自页面内转发按钮
      console.log(res.target)
    }
    return {
      title: title,
      path: '/pages/squareHome/squareHome',
      success: function (res) {
        // 转发成功
        wx.showToast({
          title: '转发成功',
          icon: 'success',
          duration: 2000
        })
      },
      fail: function (res) {
        // 转发失败
      }
    }
  },
  //下拉刷新数据
  onPullDownRefresh: function (e) {
    wx.stopPullDownRefresh();
    wx.showLoading({
      title: '正在刷新',
      mask: true
    })
    this.setData({
      page: 0,
      lower: true
    })
    this.loaddatal();
  },
  onLoad: function (option) {
    wx.showLoading({
      title: '加载中•••',
      mask: true
    })
    this.loop();
  },
  loop: function () {
    var that = this;
    if (!app.globalData.token) {
      setTimeout(function () { that.loop(); }, 100)
    } else {
      var info = app.globalData.userInfo,
        tok = app.globalData.token;
      if (!info) {
        app.userInfoReadyCallback = res => {
          this.setData({
            userInfo: res.userInfo,
            token: tok
          })
        }
      } else {
        this.setData({
          userInfo: info,
          token: tok
        })
      }
      this.loaddatal();
    }

  },

  // 数据 加载
  loaddatal: function (obj) {
    wx.showLoading({
      title: '加载中•••'
    })
    var tok = this.data.token,
      pag = this.data.page + 1,
      sel1 = this.data.Packetvalue1,
      sel2 = this.data.Packetvalue2;
    var postUrl = app.setConfig.url + '/index.php?g=Api&m=Enve&a=enve2SquareList',
      postData = {
        page: pag,
        enve_type: this.data.selections1[sel1],
        orderby: this.data.selections2[sel2],
        token: tok
      };
    app.postLogin(postUrl, postData, this.initial);
  },
  // 接收数据
  initial: function (res) {
    if (res.data.code == 20000) {
      var datas = res.data;
      if (datas.data.length == 0) {
        this.setData({
          page: -1
        })
        return false;
      }
      var vos = datas.data,
          page = this.data.page + 1,
          voices = page == 1 ? [] : this.data.redPacketList;
      for (var i = 0; i < vos.length; i++) {
        var adimgsrc = vos[i].is_adv == 1 ? !vos[i].adv_url ? '/images/ptgg.png' : app.setConfig.url + vos[i].adv_url : '/images/Noads.png';
        var voice = {
          id: vos[i].id,           // 包id     
          mode: parseFloat(vos[i].enve_type),    //  模式控制参数
          adv_text: vos[i].adv_text,       // 广告语
          adimgsrc: adimgsrc,       // 图片路径
          ownerImg: vos[i].head_img,           // 包主 头像
          ownerName: vos[i].user_name,       //包主 名字
          ownerzje: vos[i].show_amount,      //包主 总金额
          num: vos[i].num,                // 总个数
          receive_num: vos[i].receive_num,    //领取个数
          senderDate: vos[i].add_time  //发送时间
        };
        voices = voices.concat(voice);
      }
      wx.hideLoading()
      if(page == 1){
        wx.pageScrollTo({
          scrollTop: 0
        })
      }
      this.setData({
        redPacketList: voices,
        advpt: datas.adv,
        page: page,
        lower: true
      })

    }
  }
})