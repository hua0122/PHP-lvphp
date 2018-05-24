//share.js
//获取应用实例
const app = getApp()

Page({
  data: {
    userInfo: {},
    hasUserInfo: false,
    canIUse: wx.canIUse('button.open-type.getUserInfo'),
    mode: 0,
    pid:'',       // id
    cid:'0',       // 页面入口标识
    ownerImg: '',           // 头像
    ownerName: '',       // 名字
    wenan:{ 
        redtips: '发起了一个口令游戏', 
        describe: ['向你发出了一个口令红包', '向你发出了一个祝福红包', '向你发出了一个问答红包']
    },   // 口令提示语/口令描述
    xcxewm:'',
    advImg: "", //广告图片
  },

  //拨打电话
  tel: function () {
    wx.makePhoneCall({
      phoneNumber: '020-22096568'
    })
  },
  //事件处理函数
  mytry: function () {
    var id = this.data.pid,
        cid = this.data.cid;
    if(cid == 0){
      wx.navigateTo({
        url: '../recordDetails/recordDetails?pid='+id
      })
    }else{
      wx.navigateBack({
        delta: 1
      })
    }
  },
  //转发
  onShareAppMessage: function (res) {
    var id = this.data.pid,
        mode = this.data.mode,
        title = this.data.ownerName + ' ' + this.data.wenan.describe[mode];
    if (res.from === 'button') {
      // 来自页面内转发按钮
      console.log(res)
    }
    return {
      title: title,
      path: '/pages/recordDetails/recordDetails?pid='+id,
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
  //生成朋友圈分享图
  sheng:function(){
    var fximg = this.data.xcxewm;
    wx.previewImage({
      current: '', // 当前显示图片的http链接
      urls: [fximg] // 需要预览的图片http链接列表
    })
  },
  //获取登录信息
  onLoad: function (option) {
    var that = this;
    var info = app.globalData.userInfo,
        tok = app.globalData.token,
        mode = parseFloat(option.mode);
    that.setData({
      userInfo: info,
      token: tok,
      mode: mode,
      pid: option.pid,
      cid: option.cid,
      hasUserInfo: true,
      ownerName: info.nickName,
      ownerImg: info.avatarUrl
    })
    wx.showLoading({
      title: '二维码生成中',
      mask: true
    })

    //二维码
    var postUrl = app.setConfig.url + '/index.php?g=Api&m=ToCode&a=get_code',
      postData = {
        token: tok,
        pid: option.pid,
        tit: this.data.ownerName,
        con: this.data.wenan.describe[mode],
        page: 'pages/recordDetails/recordDetails'
      };
    app.postLogin(postUrl, postData, this.setCode);  
  },
  setCode: function(res){
    if(res.data.code === 20000){
      var datas = res.data;
      this.setData({
        xcxewm: app.setConfig.url + '/' + datas.data,
        advImg: datas.adv
      })
      wx.showToast({
        title: '生成成功',
        icon: 'success',
        duration: 1200
      })
    }

  }
})
