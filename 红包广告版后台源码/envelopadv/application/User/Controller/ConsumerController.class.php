<?php
namespace User\Controller;

use Common\Controller\InterceptController;
use Think\Model;
use Common\Controller\AdvController;

class ConsumerController extends InterceptController {
    protected $wx_user;

    public function __construct()
    {
        parent::__construct();
        $this->wx_user = M("WxUser");
    }

    //提现用户信息
    public function userInfo(){
        $field = 'amount,frozen_amount,show_adv';
        $info = $this->wx_user->field($field)->where('id=%d',array($this->user_id))->find();
        $cash = bcsub($info['amount'],$info['frozen_amount'],2);
        $cash = $cash < 0 ? '0.00' : $cash;
        $data = [
            'cash_status'=>true,
            'amount'=>$cash,
        	'show_adv'=>$info['show_adv'],
            'commision'=>C('HB_COMMISION'),//佣金比例
        	'commision_adv'=>C('HB_ADV_COMMISION'),//广告红包佣金比例
        	'amount_min'=>C('AMOUNT_MIN'),//红包最低金额
        	'receive_amount_min'=>C('RECEIVE_AMOUNT_MIN'),//领单个红包最低金额
        	
        ];
        if( $cash <= 1 ){
            $data['cash_status'] = false;
        }
        
        $data['adv_list'] = AdvController::instance()->getAdv('index3');
        
        $this->ajaxReturn(['code'=>20000,'msg'=>'success', 'data'=>$data]);
    }
    
    /*
     * 个人中心api 返回广告和金额
     */
    public function moneyAndAdv(){
    	$field = 'amount,frozen_amount';
    	$info = $this->wx_user->field($field)->where('id=%d',array($this->user_id))->find();
    	$cash = bcsub($info['amount'],$info['frozen_amount'],2);
    	$cash = $cash < 0 ? '0.00' : $cash;
    	$adv = AdvController::instance()->getAdv('user_center');
    	$this->ajaxReturn(['code'=>20000,'msg'=>'success', 'amount'=>$cash, 'adv'=>$adv]);
    }

    /**
     * 释放冻结金额
     * time 2017.11.15
     */
    public function rurnFrozenAmount(){
        $res = $this->wx_user->where(array('id'=>$this->user_id, 'frozen_amount'=>0 ))->count();
        if(!$res){
            $model = new Model();
            $model->execute('update '.C('DB_PREFIX').'wx_user  set `amount` = `frozen_amount`, `frozen_amount` = 0 where id='.$this->user_id);
        }
        if(!$res){
            $this->ajaxReturn(['code'=>20000,'msg'=>'失败']);
        }
        $this->ajaxReturn(['code'=>20000,'msg'=>'success']);
    }

 }