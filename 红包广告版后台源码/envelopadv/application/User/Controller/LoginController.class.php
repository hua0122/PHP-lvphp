<?php
namespace User\Controller;

use Common\Controller\WeixinController;

class LoginController extends WeixinController {

    // 登录验证提交
    public function dologin(){
        $wx_user = D("WxUser");
        $post_data = I('post.');
        $code =  I('post.code/s');
        if(!$code){
            $this->ajaxReturn(['code' => 40000, 'msg'=>'code不能为空']);
        }
        $res_wx = $this->send_url(['code'=>$code]);
        $res_wx = json_decode($res_wx,true);
        if($res_wx['errcode']){
            $this->ajaxReturn(['code' => 50000, 'msg'=>'code失效']);
        }
        $post_data['openid'] = $res_wx['openid']??'';
        $post_data['unionid'] = $res_wx['unionid'] ?? '';

    	//检查用户是否存在
        $user_info = $wx_user->field('id')->where("openid='%s' ",array($post_data['openid']))->find();
        $type = $user_info['id'] ? 2 : 1 ;
        $post_data = $wx_user->create($post_data,$type);
        if(!$post_data){
            $this->ajaxReturn(['code' => 40000, 'msg'=>$wx_user->getError()]);
        }

        if($user_info['id']){
            $last_id = $user_info['id'];
            $wx_user->where(array('id'=>$last_id))->save($post_data);
        }else{
            $last_id = $wx_user->add($post_data);
        }
        $session_user_info = md5($post_data['openid'].$last_id);
        $token = md5($post_data['openid'].$last_id.time().microtime());
        //设置登录信息
        $post_data['user_id'] = $last_id;
        S($token,$session_user_info,['expire'=>86400*30]);
        S($session_user_info,$post_data,['expire'=>86400*30]);
        $this->ajaxReturn(['code'=>20000, 'msg'=>'success', 'token'=>$token ]);
    }

 }