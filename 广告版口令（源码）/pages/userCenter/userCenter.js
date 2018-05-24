// pages/userCenter/userCenter.js
//获取应用实例
const app = getApp()
Page({
  data: {
    userInfo: {},
    hasUserInfo: false,
    token: '',
    canIUse: wx.canIUse('button.open-type.getUserInfo'),
    amount: '0.00',   // 账户余额
    advpt:{}      // 广告
  },

  //获取登录信息
  onShow: function () {
    var tok = app.globalData.token;
    var info = app.globalData.userInfo;
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
    var postUrl = app.setConfig.url + '/index.php?g=User&m=Consumer&a=moneyAndAdv',
      postData = {
        token: tok
      };
    app.postLogin(postUrl, postData, this.initial);
  },
  initial: function (res) {
    if (res.data.code == 20000) {
      var data = res.data;
      this.setData({
        amount: data.amount,
        advpt: data.adv
      })
    }
  }
})