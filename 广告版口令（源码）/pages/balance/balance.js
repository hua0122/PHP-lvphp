//balance.js
//获取应用实例
const app = getApp()

Page({
  data: {
    userInfo: {},
    hasUserInfo: false,
    token:'',
    canIUse: wx.canIUse('button.open-type.getUserInfo'),
    amount:'0.00',   // 账户余额
    sum:'',    // 提现金额
    minsum: '',   //最小提现金额
    maxnum: '',   // 最大提现次数
    num: '',   // 可以提现次数
    advpt: {}   //平台广告
  },
  //拨打电话
  tel: function () {
    wx.makePhoneCall({
      phoneNumber: '020-22096568'
    })
  },
  //事件处理函数
  bindtaphelp: function () {
    wx.navigateTo({
      url: '../help/help'
    })
  },
  //全部提现
  entirely: function(e){ 
    var amount = parseFloat(this.data.amount);
    if (amount == 0){
      wx.showToast({
        title: '没有余额',
        icon: 'loading',
        duration: 1000
      })
    }else{
      this.setData({
        sum: this.data.amount
      }) 
    }
  },
  // 提现输入框金额判断
  bindKeyInput:function(e){
    var inp = Math.round(e.detail.value*100)/100;
    var max = parseFloat(this.data.amount);
    if(max == 0&&inp != ''){
      wx.showToast({
        title: '没有余额',
        icon: 'loading',
        duration: 1000
      })
      return false;
    }
    inp = inp > max ? max : inp;
    var minsum = parseFloat(this.data.minsum);
    if (inp > 0){
      inp = inp < minsum ? minsum.toFixed(2) : inp.toFixed(2);
      inp = max < minsum ? max.toFixed(2) : inp;
    }else{
      inp = '';
    }
    this.setData({
      sum: inp
    })
  },
  // 表单提交
  formSubmit: function (e) {
    var that = this;
    var val = Math.round(e.detail.value.txje * 100) / 100,
        max = parseFloat(that.data.amount),
        minsum = parseFloat(that.data.minsum),
        maxnum = parseFloat(that.data.maxnum),
        num = parseFloat(that.data.num);
    if(num<1){
      wx.showLoading({
        title: '今日提现满'+maxnum+'次',
        mask: true,
        duration: 1500
      })
      return false;
    }
    val = val > max ? max : val;
    if (val > 0) {
      val = val < minsum ? minsum : val;
      val = max < minsum ? max : val;
    } else {
      val = '';
    }
    if (val >= minsum) {
      wx.showModal({
        title: '提示',
        content: '确定提现' + val.toFixed(2) + '元?',
        success: function (res) {
          if(res.confirm){
            var postUrl = app.setConfig.url + '/index.php?g=Api&m=Withdrawals&a=cash';
            var postData = {
              'amount': val.toFixed(2),
              'token': that.data.token,
            }
            app.postLogin(postUrl, postData, function (res) {
              if (res.data.code == 20000) {
                wx.showToast({
                  title: '提现成功',
                  icon: 'success',
                  duration: 1500
                })
                that.setData({
                  amount: (max - val).toFixed(2),
                  sum: ''
                })
              }
            });
          }
        }
      })
    } else if (val > 0){
      wx.showLoading({
        title: '提现最低' + minsum+'元起',
        mask: true,
        duration: 1200
      })
    }
  },
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
    var postUrl = app.setConfig.url + '/index.php?g=Api&m=Withdrawals&a=amountAndAdv',
      postData = {
        token: tok
      };
    app.postLogin(postUrl, postData, this.initial);  
  },
  initial:function(res){
    if (res.data.code == 20000) {
      var data = res.data;
      console.log(data)
      this.setData({
        amount: data.amount,
        minsum: data.min_withdrawals, 
        maxnum: data.max_withdrawal_time,
        num: data.withdrawal_time,
        advpt: data.adv
      })
    }
  }
})
