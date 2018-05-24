//recordDetails.js
//获取应用实例
const app = getApp();

Page({
  data: {
    userInfo: {},
    hasUserInfo: false,
    canIUse: wx.canIUse('button.open-type.getUserInfo'),
    token:'',       //  用户登录
    pid:'',            // 包id
    redPackettype: ['口令红包', '祝福红包','问答红包'],
    mode: 0,     //  模式控制参数
    ownerImg:'',           // 包主 头像
    ownerName:'',       //包主 名字
    textCN: "恭喜发财",       // 口令
    hints: ['按住说出口令领取赏金', '点击收听祝福领取赏金', '按住回答问题领取赏金', '已经领取了哦', '赏金都被领完了','红包已经失效啦','正在录入语音...'],
    hint: "点击收听寄语领取赏金",        // 按钮文字
    count: { 
      qtx: '去提现', 
      fhb: '发口令', 
      qzf: '去转发' 
    },
    voice_url:'',    // 祝福或问题语音路径
    voice_dura: 0,     // 祝福或问题语音时长ms
    owner_id: 1,          //  判断包主是否为自己  1-红包主 0-非包主
    zje:'0.00',        // 总金额
    zlq:0,          // 领取个数
    zgs:0,         // 总个数
    ls: [
    //   {              // 领取人列表
    //   imgurl: "https://wx.qlogo.cn/mmopen/vi_32/DYAIOgq83eq4Jsic8dPLibDhG0U6QHsSU5rsZriaWvCzsq3Cvic92lyntBepemiaM2hlXdjT3MTtrkhnbR2CIBb118A/0",     // 领取人头像
    //   name: '大法官',              // 领取人微信名
    //   best: 1,         // 1-手气最佳
    //   src: 'wxfile://store_1647083238o6zAJs-60GFZf1wXK_q-UYQ7hNZY9a9a06b9e5302da1cd7bac99d96cba9e.silk',        // 领取人语音路径
    //   width: '46%',     //  语音显示长度  
    //   duration: 3,        //  语音时长（秒）
    //   millisecond:3230,      //  语音时长（毫秒）
    //   time: '09月25日 13:23',     // 领取时间
    //   lsje: "88.00"      // 领取金额
    // }
    ],

    advert: false,        // 广告开关
    adimgsrc: '/images/advImg.png',       // 图片路径
    videosrc: '',      // 视频路径
    adimgstate: false,    // 是否上传图片
    videostate: false,    // 是否上传视频
    adv_text:'',    // 广告语
    playID:-1,        // 语音播放器控制id
    state: true,         // 领取按钮控制  true为可领取
    receiveState: false,     // 领取状态  true为已领取
    mide: false,          // 录音话筒控制 true为显示
    receiveJE:'500.00',
    relay: ['向你发出了一个口令红包', '向你发出了一个祝福红包', '向你发出了一个问答红包'],    // 转发后显示的提示语

    advpt: {
      slide_pic:'',
      slide_url:''
    }, //   平台广告
    micrImage:"/images/microphone.png", //按钮前面麦克风ico
    ownerVoiceSrc: 'wxfile://store_1647083238o6zAJs-60GFZf1wXK_q-UYQ7hNZY9a9a06b9e5302da1cd7bac99d96cba9e.silk',        // 领取人语音路径
  },
  //拨打电话
  tel: function () {
    wx.makePhoneCall({
      phoneNumber: '020-22096568'
    })
  },
  //绑定事件
  touchstart:function(e){
    if(!this.data.state){return false}
  },
  //点击获取formId
  formSubmit: function (e) {
    console.log(e)
  },
  //长按录音
  longtap: function(e) {
    if (!this.data.state) { return false }
    var that = this,
        hints = this.data.hints,
        mode = this.data.mode;
    //获取用户录音授权
    wx.getSetting({
      success: res => {
        if (!res.authSetting['scope.record']) {
          //未授权获取录音授权
          wx.authorize({
            scope: 'scope.record',
            success() {
              // 用户已经同意小程序使用录音功能，后续调用 wx.startRecord 接口不会弹窗询问
            }
          })
        }else{
          //已同意授权录音
          wx.stopRecord();
          that.setData({
            hint: hints[6],
            mide: true,
            micrImage:"",
          })
          var sTime = (new Date()).getTime();
          //开始录音
          wx.startRecord({
            success: function (res) {
              var eTime = (new Date()).getTime();
              var duration = (eTime - sTime);
              duration > 60000 ? duration = 60000 : false; 
              that.setData({
                hint: hints[mode],
                mide: false,
                micrImage: "/images/microphone.png",
              })
              if (duration < 1000) {
                wx.showToast({
                  title: '录音时间太短',
                  icon: 'loading',
                  mask: true,
                  duration: 800
                })
                return false
              }
              wx.showLoading({
                title: '让口令飞一会儿',
                mask: true
              })
              var tempFilePath = res.tempFilePath,
                  voice = {},
                  voices = that.data.ls; 
              
              //保存文件到本地
              wx.saveFile({
                tempFilePath: tempFilePath,
                success: function (res) {
                  //持久路径 
                  //本地文件存储的大小限制为 100M 
                  var savedFilePath = res.savedFilePath;
                  //console.log(savedFilePath);
                  var name = that.data.userInfo.nickName,
                    imgurl = that.data.userInfo.avatarUrl,
                    src = savedFilePath,
                    width = '',
                    lsje = '';
                  //格式化时间 
                  const formatNumber = n => {
                    n = n.toString()
                    return n[1] ? n : '0' + n
                  }
                  var date = new Date(),
                    month = [date.getMonth() + 1].map(formatNumber),
                    day = [date.getDate()].map(formatNumber),
                    hour = [date.getHours()].map(formatNumber),
                    minute = [date.getMinutes()].map(formatNumber);
                  date = month + '月' + day + '日 ' + hour + ':' + minute;
                  width = (45 + 55 * duration / 1000 / 30) + '%';
                  //将音频大小B转为KB 
                  //var size = (res.fileList.size / 1024).toFixed(2);

                  voice = {
                    imgurl: imgurl,
                    name: name,
                    src: src,
                    width: width,
                    duration: Math.round(duration / 1000),
                    millisecond: duration,
                    time: date,
                    lsje: lsje,
                    local: true
                  };

                  //录音文件上传服务器
                  const uploadTask = wx.uploadFile({
                    url: app.setConfig.url + '/index.php/Asset/Upload/plupload',
                    filePath: savedFilePath,
                    name: 'file',
                    formData: {
                      'token': that.data.token,
                    },
                    success: function (res) {
                      var zlq = parseFloat(that.data.zlq) + 1;
                      var postUrl = app.setConfig.url + '/index.php?g=Api&m=Enve&a=saveEnveReceive';
                      var postData = {
                        pid: that.data.pid,
                        voice_url: JSON.parse(res.data).file_url,
                        durat: voice.millisecond,
                        token: that.data.token
                      };
                      app.postLogin(postUrl, postData, function (res) {
                        var cUrl = app.setConfig.url + '/index.php?g=Api&m=Enve&a=enveDetail',
                          cData = {
                            id: that.data.pid,
                            token: that.data.token
                          };
                        app.postLogin(cUrl, cData, that.initial); 
                        return false;
                      });
                      //do something
                    }
                  })
                  uploadTask.onProgressUpdate((res) => {
                    //console.log('上传进度', res.progress)
                    //console.log('已经上传的数据长度', res.totalBytesSent)
                    //console.log('预期需要上传的数据总长度', res.totalBytesExpectedToSend)
                  })
                  
                }
              })



            },
            fail: function (res) {
              //录音失败
              wx.showToast({
                title: '录音失败',
                icon: 'loading',
                mask: true,
                duration: 1500
              })
              that.setData({
                hint: hints[mode],
                mide: false,

              })
            }
          })
          // setTimeout(function () {
          //   //结束录音  
          //   wx.stopRecord()
          // }, 30000)
        }
      }
    })

  },
  //录音被中断
  touchcancel:function(e){
    var mode = this.data.mode,
        hints = this.data.hints;
    wx.stopRecord();
    this.setData({
      hint: hints[mode],
      mide: false
    })
  },
  //录音结束
  touchend: function (e) {
    if (!this.data.state) { return false }
    var that = this,
        mode = this.data.mode,
        hints = this.data.hints;
    setTimeout(function(){
      that.setData({
        hint: hints[mode],
        mide: false,
        micrImage: "/images/microphone.png",
      })
      wx.stopRecord();
    },300)
  },

  //语音播放
  audioPlay: function (e) {
    var that = this,
        i = e.currentTarget.dataset.key,
        mode = that.data.mode,
        owner_id = that.data.owner_id,
        state = that.data.state,
        receiveState = that.data.receiveState;
    if (i<99999 && mode==2 && owner_id==0 && !receiveState && state) {
      wx.showToast({
        title: '作弊可耻',
        image: '/images/unhappy.png',
        duration: 1200
      })
      return false;
    }
    if (app.globalData.timer) { clearTimeout(app.globalData.timer);}
    //初始化播放器
    wx.pauseVoice();
    wx.stopVoice();
    if (i === that.data.playID){
      that.setData({
        playID: -1
      })
    }else{
      
      var url = i >= 99999 ? app.setConfig.url + that.data.voice_url : app.setConfig.url + '/' + that.data.ls[i].src;
      var millisecond = i >= 99999 ? that.data.voice_dura :  that.data.ls[i].millisecond;  
      //下载并播放语音
      wx.downloadFile({
        url: url,
        success: function (res) {
          that.setData({
            playID: i
          });
          wx.playVoice({
            filePath: res.tempFilePath
          })
          app.globalData.timer = setTimeout(function(){
            if(that.data.playID>-1){
              that.setData({
                playID: -1
              })
            }
            if (i == 99999 && !receiveState && state){
              wx.showLoading({
                title: '领取中',
                mask: true
              })
              var postUrl = app.setConfig.url + '/index.php?g=Api&m=Enve&a=saveEnveReceive';
              var postData = {
                pid: that.data.pid,
                voice_url: '',
                durat: '',
                token: that.data.token
              };
              app.postLogin(postUrl, postData, function (res) {
                var cUrl = app.setConfig.url + '/index.php?g=Api&m=Enve&a=enveDetail',
                  cData = {
                    id: that.data.pid,
                    token: that.data.token
                  };
                app.postLogin(cUrl, cData, that.initial);
                return false;
              })
            }
          }, millisecond);
        },
        fail: function (res) {
          console.log(res);
        }
      })
      
    }
  },
  // 查看大图
  picture: function () {
    var maxurl = this.data.adimgsrc;
    wx.previewImage({
      current: '',
      urls: [maxurl]
    })
  },
  toBalance:function(){
    wx.navigateTo({
      url: '../balance/balance'
    })
  },
  toIndex: function () {
    wx.switchTab({
      url: '../index/index'
    })
  },
  toShare:function(){
    var pid = this.data.pid,
        mode = this.data.mode;
    wx.navigateTo({
      url: '../share/share?pid=' + pid + '&cid=1&mode=' + mode
    })
  },
  toreport:function(){
    wx.navigateTo({
      url: '../report/report'
    })
  },
  // 转发
  onShareAppMessage: function (res) {
    var id = this.data.pid,
        text = this.data.relay[this.data.mode],
        title = this.data.ownerName + ' ' + text;
    if (res.from === 'button') {
      // 来自页面内转发按钮
      console.log(res.target)
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
  //下拉刷新数据
  onPullDownRefresh: function (e) {
    wx.showLoading({
      title: '正在刷新',
      mask: true
    })
    var postUrl = app.setConfig.url + '/index.php?g=Api&m=Enve&a=enveDetail',
        postData = {
          id: this.data.pid,
          token: this.data.token
        };
    app.postLogin(postUrl, postData, this.initial);
  },
  onLoad: function (options) {
    wx.showLoading({
      title: '加载中•••',
      mask: true
    })
    var scene = decodeURIComponent(options.scene);
    if(scene > 0){
      var pid = scene;
    }else{
      var pid = options.pid;
    }
    this.loop(pid);
  },
  loop:function(pid){
    if (!app.globalData.token){
      var that = this
      setTimeout(function () { that.loop(pid);},100)
    }else{
      var info = app.globalData.userInfo,
          tok = app.globalData.token;
      if (!info) {
        app.userInfoReadyCallback = res => {
          this.setData({
            userInfo: res.userInfo,
            token: tok,
            pid: pid
          })
        }
      } else {
        this.setData({
          userInfo: info,
          token: tok,
          pid: pid
        })
      }

      var postUrl = app.setConfig.url + '/index.php?g=Api&m=Enve&a=enveDetail',
          postData = {
            id: pid,
            token: tok
          };
      app.postLogin(postUrl, postData, this.initial);  
    }

  },
  //数据初始化
  initial:function(res){
    if(res.data.code == 20000){
      var data = res.data.data,
          hints = this.data.hints;
      var vos = data.receive,
          mode = parseFloat(data.enve_type),
          owner_id = data.owner,
          status = data.status,
          recive_status = data.recive_status,
          term_status = data.be_overdue,
          voices = [];
      if (recive_status){
        var hint = hints[3];
      } else if (!status){
        var hint = hints[4];
      }else{
        var hint = hints[mode];
      }
      if (term_status==1){
        status = false;
        hint = hints[5];
      }

      var advert = data.is_adv == 1 ? true : false ;
      if(!data.adv_url){
        var adimgsrc = '',
            adimgstate = false;
          
      }else{
        var adimgsrc = app.setConfig.url + data.adv_url,
            adimgstate = true;
      }
      if (!data.video_url) {
        var videosrc = '',
            videostate = false;
      } else {
        var videosrc = app.setConfig.url + data.video_url,
            videostate = true;
      }

      for(var i = 0;i<vos.length;i++){
        var width = (45 + 55 * vos[i].durat / 1000 / 30) + '%',
            duration = Math.round(vos[i].durat / 1000);
        
        var voice = {
          imgurl: vos[i].head_img,
          name: vos[i].nick_name,
          best: vos[i].best,
          src: vos[i].voice_url,
          width: width,
          duration: duration,
          millisecond: vos[i].durat,
          time: vos[i].add_time,
          lsje: vos[i].receive_amount
        };
        voices = voices.concat(voice);
      }
      wx.hideLoading();
      this.setData({
        mode: mode,
        owner_id: owner_id,
        ownerImg: data.head_img,
        ownerName: data.nick_name, 
        textCN: data.quest, 
        zje: data.show_amount,
        zlq: data.receive_num,    
        zgs: data.num, 
        voice_url: data.voice_url, 
        voice_dura: data.voice_dura,   
        ls: voices,
        state: status,
        receiveState: recive_status,
        hint: hint,
        receiveJE: data.receive_amount,
        advert: advert,
        adimgsrc: adimgsrc,
        adimgstate: adimgstate, 
        videostate: videostate, 
        videosrc: videosrc,
        adv_text: data.adv_text,
        advpt:data.adv,
        hasUserInfo: true
      })
      wx.stopPullDownRefresh();
    }
  }
})
