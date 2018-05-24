<?php
/**
 * 余额提现
 * author universe.h
 */
namespace Api\Controller;
use Common\Controller\InterceptController;
use Common\Lib\Wxpay\Wxpay;
use Common\Controller\AdvController;

class WithdrawalsController extends InterceptController {

    /**
     * 提现
     * time 2017.10.30
     */
    public function cash() {

        $amount = I('post.amount/f');
        $user_model = M("WxUser");
        $info = $user_model->where("openid='%s'",array($this->openid))->find();

        $minWithdrawals = C('MIN_WITHDRAWALS');
        $max_withdrawal_time= C('MAX_WITHDRAWAL_TIME');
        
        $withdrawaltime = getWithdrawalTime($this->openid);
        if ($withdrawaltime >= $max_withdrawal_time) {
        	$this->ajaxReturn(['code'=>50000, 'msg'=>'每天提现次数不能大于'.$max_withdrawal_time.'次']);
        }
        
        $cash_amount = sprintf("%.2f", $info['amount'] - $info['frozen_amount']);

        if($amount < $minWithdrawals ){
            $this->ajaxReturn(['code'=>50000, 'msg'=>'提现金额不能小于'.$minWithdrawals.'元']);
        }

        if($amount > $cash_amount){
            $this->ajaxReturn(['code'=>50000, 'msg'=>'提现金额不能大于余额']);
        }

        $updateMoney = sprintf("%.2f", $cash_amount - $amount);
        M()->startTrans();
        $res_user = $user_model->where("openid='$this->openid'")->setField(array('amount'=>$updateMoney));
        if(!$res_user){
            $user_model->rollback();
            $this->ajaxReturn(['code'=>20400, 'msg'=>'提现失败，请联系管理员01']);
        }

        $data =[
            'openid'=>$this->openid,
            'partner_trade_no'=>create_order(M('Withdrawals'),'partner_trade_no',C('CASH_FIX')),
            're_user_name'=>'',
            'amount'=> bcmul($amount ,100),
            'desc'=>'用户余额提现',
        ];

        $wx =  new Wxpay();
        $res =  $wx->transfers($data);
        if($res['result_code']!='SUCCESS'){
            $user_model->rollback();
            $this->ajaxReturn(['code'=>20400, 'msg'=>'提现失败，请联系管理员02']);
        }

        $log_data = [
            'user_id'=> $this->user_id,
            'amount'=>$res['amount'] / 100,
            'appid'=> $res['mch_appid'],
            'openid'=>$res['openid'],
            'check_name'=>$res['check_name'],
            're_user_name'=>$res['re_user_name'],
            'id_card'=>$res['id_card']??'',
            'pay_desc'=>'余额提现',
            'err_code_des'=>$res['err_code_des']??'',
            'nonce_str'=>$res['nonce_str'],
            'partner_trade_no'=>$res['partner_trade_no'],
            'spbill_create_ip'=>$res['spbill_create_ip'],
            'status'=>$res['result_code'],
            'add_time'=>time(),
        ];
        set_money_log($log_data,'Withdrawals');
        if(!$res_user){
            M('Withdrawals')->rollback();
            $this->ajaxReturn(['code'=>20400, 'msg'=>'提现失败，请联系管理员03']);
        }
        //提交事务
        M()->commit();

        $this->ajaxReturn(['code'=>20000, 'msg'=>'success', 'data'=>$info]);
    }
    
    /*
     * 余额和广告接口
     */
    public function amountAndAdv() {
    	$info = M("WxUser")->field($field)->where('id=%d',array($this->user_id))->find();
    	$cash = bcsub($info['amount'],$info['frozen_amount'],2);
    	$cash = $cash < 0 ? '0.00' : $cash;
    	$adv = AdvController::instance()->getAdv('cquestion');
    	$withdrawaltime = getWithdrawalTime($this->openid);
    	$this->ajaxReturn(['code'=>20000, 'msg'=>'success','amount'=>$cash, 'adv'=>$adv, 'min_withdrawals'=>C('MIN_WITHDRAWALS'),'max_withdrawal_time'=>C('MAX_WITHDRAWAL_TIME'), 'withdrawal_time'=>C('MAX_WITHDRAWAL_TIME')-$withdrawaltime]);
    }

}

