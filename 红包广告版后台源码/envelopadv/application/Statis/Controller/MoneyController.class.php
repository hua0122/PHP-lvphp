<?php
/**
 * 资金统计
 * author hhz 2017.10.10
 */
namespace Statis\Controller;
use Common\Controller\AdminbaseController;
use Common\Controller\WeixinController;
use Think\Controller;

class MoneyController extends AdminbaseController {

    //用户显示界面
    public function index()
    {
        $this->display();
    }

    /**
     * 统计佣金总额
     * @return bool
     * time 2017.10.17
     */
    public function get_sum(){
        $begin_date = strtotime(I('begin_date'));
        $end_date = strtotime(I('end_date'));
        if(!$end_date && !$begin_date){
            $this->ajaxReturn(['code'=>40000,'msg'=>'时间不正确']);
        }
        if($end_date - $begin_date < 0){
            $this->ajaxReturn(['code'=>40000,'msg'=>'开始时间不能大于结束时间']);
        }
        if((time() - $end_date)/86400 < 0.1){
            $this->ajaxReturn(['code'=>40000,'msg'=>'只能统计'.date('Y-m-d',time()-86400).'以内的数据']);
        }
        $enve = M('Enve');
        $where = 'add_time > ' .$begin_date. ' and add_time <= ' .$end_date;
        $whereOk = $where. ' and pay_status = "ok"';
        $sum_amount = $enve->where($whereOk)->Sum('show_amount');
        //相除
        $commision = bcdiv(C('HB_COMMISION'),100,2);
        //相乘得出佣金
        $sum_profit = bcmul($sum_amount,$commision,2);
        $where = $where. ' and pay_status != "ok"';
        $nopay_amount = $enve->where($where)->Sum('show_amount');
//        $data = ['sum_amount' => $sum_amount, 'sum_profit' => $sum_profit , 'nopay_amount' => $nopay_amount ];
        $data = ['sum_amount' => 100321, 'sum_profit' => 70231 , 'nopay_amount' => 40000 ];
        $data = ['status'=>20000, 'code'=>20000, 'data'=>$data];
        $this->ajaxReturn($data);
    }
}
