  //index.js
//获取应用实例
const app = getApp()

Page({
  data: {
    userInfo: {},   // 用户信息
    hasUserInfo: false,  // 用户授权
    canIUse: wx.canIUse('button.open-type.getUserInfo'),   //  检测小程序版本兼容
    mode: 0,     //  模式控制参数
    hints: ['长按录入你想对TA说的话', '长按录入你的语音问题', '正在录入语音...'],
    hint1: '长按录入你想对TA说的话',
    hint2: '长按录入你的语音问题',
    textCN:'',     // 口令输入框内容
    question: '',    // 问题输入框内容
    answer: '',     // 答案输入框内容
    sum: '',      // 赏金输入框内容
    num: '',      // 数量输入框内容
    maxsum:'10000',  // 最大赏金
    maxnum: 100,      // 最大个数
    initials:{
      yjpt:'2',       // 佣金比例（*%）
      yjgg: '3',       // 广告佣金比例（*%）
      minfc:'1',           // 最小发出金额
      minlq: '0.01'        // 最小领取金额
    },
    imgsTP:[],            // 平台广告
    serviceCharge:'0.00',    // 需支付服务费
    balance:'0.00',      // 账户余额
    token: '',
    mide: false,          // 录音话筒控制 true为显示
    advert: false,        // 广告开关
    piazza: false,        // 是否分享到广场
    btn:'生成语音口令',      // 支付按钮提示语
    audiostate: false,         // 是否录入语音
    audio: {},       // 语音文件本地路径、时长ms
    time: 0,          // 语音时长
    audiostate2: false,         // 是否录入语音(问答)
    audio2: {},       // 语音文件本地路径、时长ms(问答)
    time2: 0,          // 语音时长(问答)
    playID: -1,        // 语音播放器控制id
    adimgstate: false ,    // 是否上传图片
    adimgsrc:'',       // 图片路径
    videostate: false,    // 是否上传视频
    videosrc: '',       // 视频路径
    textarea: '',        // 广告语
    control: true,    // 提交按钮控制器
    duration:500
  },
  //事件处理函数
  //模式切换
  bindchange:function(e){
    var ii = parseFloat(e.detail.current);
    this.setData({
      mode: ii
    })  
  },
  //模式切换
  swichNav:function(e){
    var that = this;
    var mode = parseFloat(e.currentTarget.dataset.current);
    if (this.data.mode == mode) {
      return false;
    } else {
      that.setData({
        mode: mode
      })
    }
  },
  //口令输入框规则
  bindKLInput:function(e){
    //筛选出汉字
    var val = e.detail.value.trim(),
        reg = /[\u4e00-\u9fa5]/g,
        result = val.match(reg);

    if (result === null){
      this.setData({
        textCN: ''
      })
    }else{
      result = result.join("");
      this.setData({
        textCN: result
      })
    }
  },
  //答案输入框
  bindDAInput: function (e) {
    //筛选出汉字
    var val = e.detail.value.trim(),
      reg = /[\u4e00-\u9fa5]/g,
      result = val.match(reg);

    if (result === null) {
      this.setData({
        answer: ''
      })
    } else {
      result = result.join("");
      this.setData({
        answer: result
      })
    }
  },
  

  //金额输入框函数
  bindJEInput: function (e) {
    var value = !e ? this.data.sum : e.detail.value;
    var inp = Math.round(value * 100) / 100;
    var max = parseFloat(this.data.maxsum),
        min = parseFloat(this.data.initials.minfc);
    var bi = this.data.advert ? parseFloat(this.data.initials.yjgg) / 100 : parseFloat(this.data.initials.yjpt) / 100;
    inp = inp > max ? max : inp;
    inp = inp > 0 ? inp < min ? min.toFixed(2) : inp.toFixed(2) : '';
    var val = inp*1;
    var balance = parseFloat(this.data.balance);
    var serc = Math.round(val * bi * 100) / 100;
    var actual = val + serc > balance ? (val + serc - balance).toFixed(2) : 0;
    if (parseFloat(actual) > 0) {
      var btntxt = '还需支付' + actual + '元'
      this.setData({
        sum: inp,
        serviceCharge: serc.toFixed(2),
        btn: btntxt
      })
    }else{
      this.setData({
        sum: inp,
        serviceCharge: serc.toFixed(2),
        btn: '生成语音口令'
      })
    }
  },
  //数量输入框控制函数
  bindSLInput: function(e){
    var value = !e ? this.data.num : e.detail.value;
    var num = Math.ceil(value),
        max = parseFloat(this.data.maxnum);
        num = num > 0 ? num > max ? max : num : '';
    this.setData({
      num: num
    })
  },

  //表单提交
  formSubmit: function (e) {
    var that = this;
    var val = e.detail.value,
        mode = this.data.mode;
    if(mode == 2){
      var audiostate2 = this.data.audiostate2,
          valda = val.da;
    }else if(mode == 0){
      var valkl = e.detail.value.kl;
    }else if(mode == 1){
      var audiostate = this.data.audiostate;
    }else{return false;}
    var valsj = parseFloat(val.sj),
        valsl = Math.ceil(val.sl),
        formid = e.detail.formId;
    var maxsum = parseFloat(this.data.maxsum),
        minsum = parseFloat(this.data.initials.minfc),
        maxnum = parseFloat(this.data.maxnum);
    valsj = valsj > maxsum ? maxsum : valsj;
    valsj = valsj > 0 ? valsj < minsum ? minsum : valsj : '';
    valsl = valsl > 0 ? valsl > maxnum ? maxnum : valsl : '';
    
    if (!audiostate2 && mode == 2) {
      wx.showModal({
        title: '提示',
        content: '请录入你的语音问题！',
        showCancel: false,
        success: function (res) {
        }
      })
      return false
    } else if (valda == '' && mode == 2){
      wx.showModal({
        title: '提示',
        content: '请设置中文答案！',
        showCancel: false,
        success: function (res) {
        }
      })
      return false
    }else if(valkl == '' && mode == 0){
      wx.showModal({
        title: '提示',
        content: '请设置口令！',
        showCancel:false,
        success: function (res) {
        }
      })
      return false
    } else if (!audiostate && mode == 1){
      wx.showModal({
        title: '提示',
        content: '请录入表白寄语！',
        showCancel: false,
        success: function (res) {
        }
      })
      return false
    }
    if(valsj == ''){
      wx.showModal({
        title: '提示',
        content: '请填写金额！',
        showCancel: false,
        success: function (res) {
        }
      })
      return false
    }
    if(valsl == ''){
      wx.showModal({
        title: '提示',
        content: '请填写数量！',
        showCancel: false,
        success: function (res) {
        }
      })
      return false
    }
    var minlq = parseFloat(this.data.initials.minlq);
    var ns = valsj - minlq*valsl;
    if(ns<0){
      wx.showModal({
        title: '提示',
        content: '单个红包金额不能少于' + minlq.toFixed(2) + '元',
        showCancel: false,
        success: function (res) {
        }
      })
      return false
    }
    var advert = this.data.advert,
        adimgstate = this.data.adimgstate,
        videostate = this.data.videostate,
        piazza = this.data.piazza;

    if (advert && !adimgstate && !videostate){
      wx.showModal({
        title: '提示',
        content: '请上传广告图片或视频！',
        showCancel: false,
        success: function (res) {
        }
      })
      return false
    }
    //登录信息验证
    var tok = app.globalData.token;
    if (!this.data.control || !tok) {
      return false;
    }
    this.setData({
      control: false
    })

    
    var datas = {};
    datas.amount = valsj;
    datas.num = valsl;
    datas.is_adv = advert ? 1 : 0;
    datas.enve_type = mode;
    datas.form_id = formid;
    datas.token = tok;
    if (advert) {
      datas.adv_url = adimgstate ? this.data.adimgsrc.src : '';
      datas.video_url = videostate ? this.data.videosrc.src : '';
      datas.adv_text = this.data.textarea.trim();   
    }
    datas.share2square = piazza ? 1 : 0;
    if (mode == 0){
      datas.quest = valkl;
      //口令提交信息
      var postUrl = app.setConfig.url + '/index.php/Api/Enve/saveEnve';
      app.postLogin(postUrl, datas, that.saveEnve);
    } else if (mode == 1){
      var audio = this.data.audio;
      //录音文件上传服务器
      const uploadTask = wx.uploadFile({
        url: app.setConfig.url + '/index.php/Asset/Upload/plupload',
        filePath: audio.src,
        name: 'file',
        formData: {
          'token': that.data.token,
        },
        success: function (res) {
          datas.voice_url = JSON.parse(res.data).file_url;
          datas.voice_dura = audio.duration;
          //口令提交信息
          var postUrl = app.setConfig.url + '/index.php/Api/Enve/saveEnve';
          app.postLogin(postUrl, datas, that.saveEnve);
        }
      })
      uploadTask.onProgressUpdate((res) => {
        //console.log('上传进度', res.progress)
        //console.log('已经上传的数据长度', res.totalBytesSent)
        //console.log('预期需要上传的数据总长度', res.totalBytesExpectedToSend)
      }) 
    } else if (mode == 2){
      var audio = this.data.audio2;
      //录音文件上传服务器
      const uploadTask = wx.uploadFile({
        url: app.setConfig.url + '/index.php/Asset/Upload/plupload',
        filePath: audio.src,
        name: 'file',
        formData: {
          'token': that.data.token,
        },
        success: function (res) {
          datas.voice_url = JSON.parse(res.data).file_url;
          datas.voice_dura = audio.duration;
          datas.answer = valda;
          //口令提交信息
          var postUrl = app.setConfig.url + '/index.php/Api/Enve/saveEnve';
          app.postLogin(postUrl, datas, that.saveEnve);
        }
      })
      uploadTask.onProgressUpdate((res) => {
       
      })
    }  
    
  },

  //长按录音
  longtap: function (e) {
    var that = this;
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
        } else {
          //已同意授权录音
          var mode = that.data.mode,
            hints = that.data.hints;
          wx.stopRecord();
          if (mode == 1) {
            that.setData({
              mide: true,
              hint1: hints[2]
            })
          } else if (mode == 2) {
            that.setData({
              mide: true,
              hint2: hints[2]
            })
          }
          var sTime = (new Date()).getTime();
          //开始录音
          wx.startRecord({
            success: function (res) {
              var eTime = (new Date()).getTime();
              var duration = (eTime - sTime);
              duration > 60000 ? duration = 60000 : false;
              if (mode == 1) {
                that.setData({
                  mide: false,
                  hint1: hints[0]
                })
              } else if (mode == 2) {
                that.setData({
                  mide: false,
                  hint2: hints[1]
                })
              }
              if (duration < 1000) {
                wx.showToast({
                  title: '录音时间太短',
                  icon: 'loading',
                  mask: true,
                  duration: 800
                })
                return false
              }
              
              var tempFilePath = res.tempFilePath;
               
              //保存文件到本地
              wx.saveFile({
                tempFilePath: tempFilePath,
                success: function (res) {
                  //持久路径 
                  //本地文件存储的大小限制为 100M 
                  var savedFilePath = res.savedFilePath;
                  var vas = { src: savedFilePath, duration: duration},
                      time = Math.round(duration / 1000);
                  if(that.data.mode == 1){
                    that.setData({
                      audio: vas,
                      time: time,
                      audiostate: true
                    })
                  } else if (that.data.mode == 2){
                    that.setData({
                      audio2: vas,
                      time2: time,
                      audiostate2: true
                    })
                  }
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
              if (mode == 1) {
                that.setData({
                  mide: false,
                  hint1: hints[0]
                })
              } else if (mode == 2) {
                that.setData({
                  mide: false,
                  hint2: hints[1]
                })
              }
            }
          })
        }
      }
    })

  },
  //录音被中断
  touchcancel: function (e) {
    wx.stopRecord();
    var mode = this.data.mode,
      hints = this.data.hints;
    if (mode == 1) {
      this.setData({
        mide: false,
        hint1: hints[0]
      })
    } else if (mode == 2) {
      this.setData({
        mide: false,
        hint2: hints[1]
      })
    }
  },
  //录音结束
  touchend: function (e) {
    var that = this,
      mode = this.data.mode,
      hints = this.data.hints;
    setTimeout(function () {
      if (mode == 1) {
        that.setData({
          mide: false,
          hint1: hints[0]
        })
      } else if (mode == 2) {
        that.setData({
          mide: false,
          hint2: hints[1]
        })
      }
      wx.stopRecord();
    }, 300)
  },

  //语音播放
  audioPlay: function (e) {
    var that = this,
      i = e.currentTarget.dataset.key;
      console.log(i)
    if (app.globalData.timer) { clearTimeout(app.globalData.timer); }
    //初始化播放器
    wx.pauseVoice();
    wx.stopVoice();
    if (i == that.data.playID) {
      that.setData({
        playID: -1
      })
    } else {
      //本地语音播放
      that.setData({
        playID: i
      });
      var millisecond = i == 1 ? that.data.audio.duration : that.data.audio2.duration,
          src = i == 1 ? that.data.audio.src : that.data.audio2.src;
      wx.playVoice({
        filePath: src
      })
      app.globalData.timer = setTimeout(function () {
        that.setData({
          playID: -1
        })
      }, millisecond);
    
    }
  },
  // 语音重置
  resetaudio:function(){
    if(this.data.mode == 1){
      this.setData({
        audiostate: false,    
        audio: {}, 
        playID: -1,  
        time: 0
      })
    } else if (this.data.mode == 2){
      this.setData({
        audiostate2: false,
        audio2: {},
        playID: -1,
        time2: 0
      })
    }
  },
  // 广告开关
  switchAdv:function(e){
    var advert = e.detail.value;
    this.setData({
      advert: advert
    })
    this.bindJEInput();
  },
  // 广场开关
  switchPz: function (e) {
    var piazza = e.detail.value;
    this.setData({
      piazza: piazza
    })
  },
  // 上传图片
  adimg:function(){
    var that =this;
    wx.chooseImage({
      count: 1, 
      sizeType: 'compressed',
      success: function (res) {
        // 返回选定照片的本地文件路径列表，tempFilePath可以作为img标签的src属性显示图片
        wx.showLoading({
          title: '上传中•••',
        })
        var tempFilePaths = res.tempFilePaths[0];
        wx.uploadFile({
          url: app.setConfig.url + '/index.php/Asset/Upload/advpPlupload',
          filePath: tempFilePaths,
          name: 'file',
          formData: {
            'token': that.data.token,
          },
          success: function (res) {
            wx.showToast({
              title: '上传成功',
              icon: 'success',
              duration: 800
            })
            var data = JSON.parse(res.data).file_url;
            var src = { srcbd: tempFilePaths, src: data}
            that.setData({
              adimgsrc: src,
              adimgstate: true
            })
          }
        })
      }
    })
  },
  // 删除图片
  closeadimg:function(){
    this.setData({
      adimgsrc: '',
      adimgstate: false
    })
  },
  // 添加视频
  addvideo:function(){
    var that = this
    wx.chooseVideo({
      maxDuration:15,
      success: function (res) {
        if (res.duration>15){
          wx.showToast({
            title: '视频超过15秒',
            icon: 'success',
            duration: 1200
          })
        }else{
          wx.showLoading({
            title: '上传中•••',
          })
          var tempFilePaths = res.tempFilePath;
          wx.uploadFile({
            url: app.setConfig.url + '/index.php/Asset/Upload/advpPlupload',
            filePath: tempFilePaths,
            name: 'file',
            formData: {
              'token': that.data.token,
            },
            success: function (res) {
              var data = JSON.parse(res.data).file_url;
              var src = { srcbd: tempFilePaths, src: data }
              that.setData({
                videosrc: src,
                videostate: true
              })
              wx.showToast({
                title: '上传成功',
                icon: 'success',
                duration: 800
              })
            }
          })
        }
      }
    })
  },
  // 删除视频
  closevideo: function () {
    this.setData({
      videosrc: '',
      videostate: false
    })
  },
  //广告语
  textareaip:function(e){
    var textarea = e.detail.value;
    this.setData({
      textarea: textarea
    })
  },

  //拨打电话
  tel:function(){
    wx.makePhoneCall({
      phoneNumber: '020-22096568' 
    })
  },
  
  // 转发
  onShareAppMessage: function (res) {
    return {
      title: '新奇的口令玩法，快来体验吧 >>',
      path: '/pages/index/index',
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
  //提交口令
  saveEnve:function(res){
    var that = this;
    if(res.data.code===20000){
      var payInfo = res.data.data;
      var pid = payInfo.pid,
          mode = that.data.mode;
      if (payInfo.pay_type == 2){
        var balance = parseFloat(that.data.balance) - parseFloat(that.data.sum) - parseFloat(that.data.serviceCharge);
        wx.showToast({
          title: '支付成功',
          mask: true,
          icon: 'success',
          duration: 1000
        })
        setTimeout(function () {
          that.setData({
            textCN: '',
            sum: '',
            num: '',
            balance: balance.toFixed(2),
            control: true
          })
          wx.navigateTo({
            url: '../share/share?pid=' + pid +'&cid=0&mode=' + mode
          })
        }, 1000)
      }else{
        wx.requestPayment({
          'timeStamp': payInfo.timeStamp,
          'nonceStr': payInfo.nonceStr,
          'package': payInfo.package,
          'signType': 'MD5',
          'paySign': payInfo.paySign,
          'success': function (res) {
            var balance = parseFloat(that.data.balance) - parseFloat(that.data.sum);
            wx.showToast({
              title: '支付成功',
              icon: 'success',
              duration: 1000
            })
            var postUrlTZ = app.setConfig.url + '/index.php?g=Api&m=Enve&a=sendCreateEnveNotify',
              postDataTZ = {
                token: app.globalData.token,
                prepay_id: payInfo.prepay_id,
                quest: payInfo.quest,
                pid: payInfo.pid
              };
            app.postLogin(postUrlTZ, postDataTZ);
            setTimeout(function(){
              that.setData({
                textCN: '',
                sum: '',
                num: '',
                balance: '0.00',
                control: true
              })
              wx.navigateTo({
                url: '../share/share?pid=' + pid + '&cid=0&mode=' + mode
              })
            },1000)
          },
          'fail': function (res) {
            // 支付失败
            wx.showToast({
              title: '支付失败',
              icon: 'loading',
              mask: true,
              duration: 1000
            })
            that.setData({
              control: true
            })
            //释放冻结金额
            var postUrl = app.setConfig.url + '/index.php?g=User&m=Consumer&a=rurnFrozenAmount',
            postData = {
              token: app.globalData.token
            };
            app.postLogin(postUrl, postData);
          }
          
        })
      }
    }else(
      that.setData({
        control: true
      })
    )
    return false;
  },
  //获取登录信息
  onShow:function(){
    wx.showLoading({
      title: '加载中•••',
      mask: true
    })
    this.loop();
    
  },
  loop: function () {
    var info = app.globalData.userInfo,
        tok = app.globalData.token;
    if (info && !this.data.hasUserInfo){
      wx.showLoading({
        title: '数据初始化',
        mask: true
      })
      
      this.setData({
        userInfo: info,
        hasUserInfo: true
      })
    }
    if (!tok) {
      var that = this
      setTimeout(function () { that.loop(); }, 100)
    } else {
      this.setData({
        token: tok
      })
      var postUrl = app.setConfig.url + '/index.php?g=User&m=Consumer&a=userInfo',
        postData = {
          token: tok
        };
      app.postLogin(postUrl, postData, this.initial);
    }
  },
  
  initial: function (res) {
    if (res.data.code == 20000) {
      var data = res.data.data;
      var initials = {
        yjpt: data.commision,      
        yjgg: data.commision_adv,      
        minfc: data.amount_min,        
        minlq: data.receive_amount_min    
      };
      wx.hideLoading()
      this.setData({
        balance: data.amount,
        initials: initials,
        imgsTP: data.adv_list
      })
      this.bindJEInput();
    }
  }
})
