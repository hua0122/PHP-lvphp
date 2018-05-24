<?php
/**
 * 资金明细
 * author hhz 2017.10.17
 */
namespace Capital\Controller;
use Common\Controller\AdminbaseController;


class CapitalController extends AdminbaseController {

    protected $enve;

    public function _initialize() {
        parent::_initialize();
        $this->enve = D("enve");
    }

    /**
     * 支付明细
     * time 2017.10.15
     */
    public function pay()
    {
        /**搜索条件**/
        $begin_date = strtotime(I('start_time'));
        $end_date = strtotime(I('end_time'));
        if($end_date - $begin_date < 0){
            $this->error('开始时间不能大于结束时间');
        }
        if($begin_date && $end_date){
            $where = 'add_time > ' .$begin_date. ' and add_time <= ' .$end_date;
        }
        $count = $this->enve->where($where)->count();
        $page = $this->page($count, 20);
        $info = $this->enve
            ->where($where)
            ->order("add_time DESC")
            ->limit($page->firstRow, $page->listRows)
            ->select();
        foreach ($info as &$v){
            $v['add_time'] = date('Y-m-d H:i:s', $v['add_time']);
        }

        $this->assign("page", $page->show('Admin'));
        $this->assign("info", $info);
        $this->display();
    }

    /**
     * 提现明细
     * time 2017.10.17
     */
    public function withdrawals(){
        /**搜索条件**/
        $begin_date = strtotime(I('start_time'));
        $end_date = strtotime(I('end_time'));
        if($end_date - $begin_date < 0){
            $this->error('开始时间不能大于结束时间');
        }
        $withdrawals = M('Withdrawals');
        if($begin_date && $end_date){
            $where = ' (add_time > ' .$begin_date. ' and add_time <= ' .$end_date.')';
        }
        $count = $this->enve->where($where)->count();
        $page = $this->page($count, 20);
        $info = $withdrawals
            ->where($where)
            ->order("add_time DESC")
            ->limit($page->firstRow, $page->listRows)
            ->select();
        foreach ($info as &$v){
            $v['add_time'] = date('Y-m-d H:i:s', $v['add_time']);
        }
        $this->assign("info", $info);
        $this->display();
    }

    /**
     * 领取明细
     * time 2017.10.17
     */
    public function receive(){
        /**搜索条件**/
        $begin_date = strtotime(I('start_time'));
        $end_date = strtotime(I('end_time'));
        if($end_date - $begin_date < 0){
            $this->error('开始时间不能大于结束时间');
        }
        if($begin_date && $end_date){
            $where = ' and (add_time > ' .$begin_date. ' and add_time <= ' .$end_date.')';
        }
        $enve_receive = M('EnveReceive');
        $count = $enve_receive->where($where)->count();
        $page = $this->page($count, 20);
        //领取列表
        $info = $enve_receive
            ->where($where)
            ->order("add_time DESC")
            ->limit($page->firstRow, $page->listRows)
            ->select();
        if($info){

            foreach ($info as &$v){
                $enve_id[] = $v['pid'];
                $v['add_time'] = date('Y-m-d H:i:s', $v['add_time']);
            }
            //领取了那个红包
            $param['id']=array('in',$enve_id);
            $enve = $this->enve->where($param)->select();
            foreach($enve as $vs){
                $enve_arr[$vs['id']] = $vs;
            }
            foreach ($info as &$v){
                $v['quest'] = $enve_arr[$v['pid']]['quest'];
                $v['send_user_name'] = $enve_arr[$v['pid']]['user_name'];
            }

        }

        $this->assign("page", $page->show('Admin'));
        $this->assign("info", $info);
        $this->display();
    }

}
