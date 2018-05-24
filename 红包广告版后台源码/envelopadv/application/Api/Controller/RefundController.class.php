<?php
namespace Api\Controller;
use Think\Controller;
use Common\Controller\WeixinController;
use Common\Lib\Queue;

class RefundController extends Controller{

    /**
     * 退款脚本
     */
    public function index(){
        $enve=M('Enve');
        $reuncash_log=M('ReuncashLog');
        $wx_user=M('WxUser');
        //查询满足到期未领完的红包
        $res = $enve->where('pay_status = "ok" and amount > 0 and be_overdue = 0')->select();
        if(!$res){
            echo '暂无满足退款条件红包';
            exit;
        }
        foreach($res as $v){

           if($v['amount'] > 0 &&  time() - $v['add_time'] > 86400){
               //开始事务
               M()->startTrans();
               $up_data = array('be_overdue'=>1);
               $res_enve = $enve->where(array('id'=>$v['id']))->setField($up_data); // 更新红包金额
               if(!$res_enve){
                   $enve->rollback();
                   break;
               }
               $res_user = $wx_user->where(array('id'=>$v['user_id']))->setInc('amount',$v['amount']); // 更新用户金额
               if(!$res_user){
                   $wx_user->rollback();
                   break;
               }

               //插log
               $log_data = [
                   'pay_type'=> $v['pay_type'],
                   'transaction_id'=>"$v[transaction_id]",
                   'pay_status'=> 'ok',
                   'desc'=>'红包未领完退款',
                   'action'=>__ACTION__,
                   'content'=>json_encode($v,JSON_FORCE_OBJECT),
                   'add_time'=>time()
               ];

               $res_user = $reuncash_log->add($log_data); // 更新用户金额
               if(!$res_user){
                   $wx_user->rollback();
                   break;
               }
               Queue::getInstance(C('QUEUE_PREFIX').'enve'.$v['id'])->flushQueue();//删除队列
               M()->commit();
               //$info = $enve -> where('transaction_id="'.$v['transaction_id'] . '"') -> find();
               //判断支付方式，根据支付方式选择传递form_id或prepay_id
               $formId = empty($v['prepay_id']) ? $v['form_id'] : $v['prepay_id'];
               $enveStr = '口令红包“'.$post_data['quest'].'”';
               switch ($v['enve_type']) {
               	case 1:
               		$enveStr = '祝福红包';
               		break;
               		
               	case 2:
               		$enveStr = '问答红包“'.$v['answer'].'”';
               		break;
               }
               $tplData = [
                   'keyword1'=>[
                       'value'=> $v['amount'] . '元',
                       'color'=>'#173177',
                   ],
                   'keyword2'=>[
                   		'value'=> $enveStr.'未抢完',
                       'color'=>'#173177',
                   ],
                   'keyword3'=>[
                   		'value'=> date('m月d日 H:i', time()),
                       'color'=>'#173177',
                   ],
                   'keyword4'=>[
                       'value'=> '包好说账户余额',
                       'color'=>'#173177',
                   ],
                   'keyword5'=>[
                       'value'=> '点击此处查看红包详情',
                       'color'=>'#173177',
                   ],
               ];
               $param = [
                   'touser' => $v['openid'],
                   'template_id' => C('news_tpl_refund'),
                   'page' => '/pages/recordDetails/recordDetails?pid='.$v['id'],
                   'form_id' => $formId,
                   'data' => $tplData,
               ];
               WeixinController::instance()->send_template($param);
               echo $v['out_trade_no'].'成功';

           }
        }
    }

}
