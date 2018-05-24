<?php
/**
 * 语音红包类
 * author universe.h
 */
namespace Api\Controller;
use Common\Controller\InterceptController;
use Common\Controller\WeixinController;
use Common\Controller\AdvController;
use Common\Lib\Baidu\Sample;
use Common\Lib\Pinyin;
use Common\Lib\Wxpay\Wxpay;
use Common\Lib\Queue;
use Admin\Controller\PublicController;

class EnveController extends InterceptController {

    /**
     * 发红包列表
     * time 2017.9.30
     */
    public function index() {
        $enve_model = M("Enve");
        $page = I('post.page/d')?:1;
        $page_size = 10;
        $field = 'id,quest,answer,show_amount,num,receive_num,enve_type,FROM_UNIXTIME(add_time,\'%m月%d日 %H:%i\') add_time';
        $info = $enve_model->field($field)->page($page,$page_size)->where("user_id='%d' and del=0 and pay_status='%s'",array($this->user_id, 'ok'))->order('id desc')->select();
        $sum_info = $enve_model->field('sum(show_amount) sum_money')->where("user_id='%d' and del=0 and pay_status='%s'",array($this->user_id, 'ok'))->find();
        $sum_info['sum_num'] = $enve_model->where("user_id='%d' and pay_status='%s'",array($this->user_id, 'ok'))->count();
        if(!$info){
            $this->ajaxReturn(['code'=>20400, 'msg'=>'没有更多了']);
        }
        /*添加广告图片*/
        $sum_info['adv'] = AdvController::instance()->getAdv('mysend');
        $this->ajaxReturn(['code'=>20000, 'msg'=>'success', 'data'=>$info,'sum_info'=>$sum_info]);
    }

    /**
     * 领取红包列表
     * time 2017.9.30
     */
    public function reciveList() {
        $enve_receive_model = M("EnveReceive");
        $page = I('post.page/d')?:1;
        $page_size = 10;
        $field = 'pid as id,receive_answer,nick_name,head_img,receive_amount,durat,FROM_UNIXTIME(a.add_time,\'%m月%d日 %H:%i\') add_time,best,enve_type';
        $info = $enve_receive_model->alias('a')->join('LEFT JOIN '.C('DB_PREFIX').'enve b ON a.pid=b.id')->field($field)->page($page,$page_size)->where("a.user_id='%d'",array($this->user_id))->order('id desc')->select();
        $sum_info = $enve_receive_model->field('sum(receive_amount) sum_money,sum(receive_num) sum_num')->where("user_id='%d'",array($this->user_id))->find();
        
        if(!$info){
            $this->ajaxReturn(['code'=>20400, 'msg'=>'没有更多了']);
        }
        //添加广告图片
        $sum_info['adv'] = AdvController::instance()->getAdv('myrecive');
        $this->ajaxReturn(['code'=>20000, 'msg'=>'success', 'data'=>$info,'sum_info'=>$sum_info]);
    }

    /**
     * 添加红包信息
     * time 2017.10.2
     */
    public function  saveEnve(){
 /*   	$adv = AdvController::instance()->getAdv('hbsquare');exit(json_encode($adv));exit();
    	$a=array("red","green","blue","yellow","brown");
    	print_r(array_slice($a,1,100));
    	print_r($a);
    	exit();
    	$queue = new Queue();
    	$arr = array('aa'=>'11', 'bb'=>'22');
    	$arrStr = json_encode($arr);
    	echo $queue->len();
    	exit();*/
        $post_data = I('post.');
        if (isset($post_data['pay_status'])) {
        	unset($post_data['pay_status']);
        }
        $enve_model = D("Enve");
        $wx_user = M("WxUser");
        $post_data = $enve_model->create($post_data);
        if(!$post_data){
            $msg = $enve_model->getError()?:'系统繁忙';
            $this->ajaxReturn(['code' => 40000, 'msg' => $msg ]);
        }
        
        /*判断是否符合最低领取红包金额要求*/
        if ($post_data['amount'] < C('RECEIVE_AMOUNT_MIN')*$post_data['num']) {
        	$this->ajaxReturn(['code'=>50000, 'msg'=>'不符合领红包最低金额要求']);
        }
        /*判断是否符合最低红包金额要求*/
        if ($post_data['amount'] < C('AMOUNT_MIN')) {
        	$this->ajaxReturn(['code'=>50000, 'msg'=>'不符合红包最低金额要求']);
        }

        /*查询用户余额*/
        $userAmount = $wx_user->field('amount,frozen_amount')->where("openid='%s'",array($this->openid))->find();

        //加上佣金四舍五入
        //判断是否广告红包+百分之一
        $commission = C('HB_COMMISION');
        if ($post_data['is_adv']) {
        	$commission = C('HB_ADV_COMMISION');
        }
        $amount = sprintf("%.2f", $post_data['amount'] + calculate_commission($post_data['amount'], $commission));

        //减去被冻结的余额
        $userMoney =  sprintf("%.2f",$userAmount['amount'] - $post_data['frozen_amount']);

        //减去用户余额
        $amount = sprintf("%.2f",$userMoney - $amount);

        //开始事务
        $enve_model->startTrans();

        //解冻用户余额
        $wx_user->where("openid='%s'", array($this->openid))->setField(array('frozen_amount'=> 0));
        //余额不足的情况
        $res_user=true;
        if($amount < 0 || $userAmount['amount']<=0){
            $wxpay = new Wxpay();
            $out_trade_no = $post_data['out_trade_no'];
            
            $enveStr = '口令红包';
            switch ($post_data['enve_type']) {
            	case 1:
            		$enveStr = '口令祝福红包';
            	break;
            	
            	case 2:
            		$enveStr = '问答红包';
            	break;
            }
            //调起支付
            $pay = array(
            		'body' => '包好说'.$enveStr,
                'out_trade_no' => $out_trade_no,
                'total_fee' => abs($amount) ,
                'notify_url' => "https://".$_SERVER['HTTP_HOST'] . U('Api/Wxpay/OrderChange') ,
            );
            $respay = $wxpay->get_code($pay,$this->instance()->openid);
            $respay =  json_decode($respay,true);
            //支付类型
            $respay['pay_type'] = 1;
            if($userMoney > 0){
                $respay['pay_type'] = 3;
            }
            // 冻结用户所有余额
            if($userAmount['amount'] > 0){
                $res_user = $wx_user->where("openid='%s'", array($this->openid))->setField(array('frozen_amount'=> $userAmount['amount']));
            }
            $log_data = [
                'pay_type'=> '1',
                'amount'=>$amount,
                'pay_status'=> 'ok',
                'desc'=>'微信支付',
                'action'=>__ACTION__,
                'content'=>json_encode($post_data,JSON_UNESCAPED_UNICODE),
                'add_time'=>time(),
            ];
            //插入log
            $res_log = set_money_log($log_data,'PayLog');
            if(!$res_log){
                $enve_model->rollback();
                $this->ajaxReturn(['code'=>50000, 'msg'=>'口令生成失败(log)']);
            }
            $respay['pay_type'] = $post_data['pay_type'] = 1;
            $post_data['prepay_id'] = trim(substr($respay['package'],strpos($respay['package'], '=') + 1));
            //unset($respay['prepay_id']);
        }
        //余额支付
        if($amount >= 0) {
            $res_user = $wx_user->where("openid='%s'", array($this->openid))->setField(array('amount'=> $amount,)); // 修改用户余额
            //插log
            $log_data = [
                'pay_type'=> '2',
                'amount'=>$amount,
                'pay_status'=> 'ok',
                'desc'=>'余额支付',
                'action'=>__ACTION__,
                'content'=>json_encode($post_data,JSON_UNESCAPED_UNICODE),
                'add_time'=>time(),
            ];
            //插入log
            $res_log = set_money_log($log_data,'PayLog');
            if(!$res_log){
                $enve_model->rollback();
                $this->ajaxReturn(['code'=>50000, 'msg'=>'口令生成失败(log)']);
            }
            $respay['pay_type'] = $post_data['pay_type'] = 2;
            $post_data['pay_status']='ok';
            $post_data['prepay_id'] = $post_data['prepay_id'] ? $post_data['prepay_id'] : '';
        }
        if(!$res_user){
            $enve_model->rollback();
            $this->ajaxReturn(['code'=>50000, 'msg'=>'口令生成失败(user)']);
        }
        //红包入库
        $post_data['openid']=$this->openid;
        $last_id = $enve_model->add($post_data);
        if(!$last_id){
            $enve_model->rollback();
            $this->ajaxReturn(['code'=>50000, 'msg'=>'口令生成失败(in)']);
        }
        $respay['pid'] = $last_id;
        
        //新建一个队列将分出来的红包加入
        $queue = Queue::getInstance(C('QUEUE_PREFIX').'enve'.$last_id);
        $moneyList = $this->get_rand($post_data['amount'], $post_data['num'], C('RECEIVE_AMOUNT_MIN'));
        $enveInfo = array('moneyList'=>$moneyList, 'amount'=>$post_data['amount'], 'receiveNum'=>0, 'enveNum'=>$post_data['num'], 'users'=>array());
        $queue->push(serialize($enveInfo));
        //如果队列长度跟红包数量不对，则生成红包失败
        if ($queue->len() == 0) {
        	$enve_model->rollback();
        	$this->ajaxReturn(['code'=>50000, 'msg'=>'口令生成失败(队列)']);
        }
        
        //提交事务
        $enve_model->commit();
        $respay['quest'] = $post_data['quest'];
        $respay['prepay_id'] = $post_data['prepay_id'];
        $respay['pid'] = $last_id;
        $this->ajaxReturn(['code'=>20000, 'msg'=>'success', 'data'=>$respay]);
    }
    
    /*
     * 广场红包列表
     */
    function enve2SquareList() {
    	$post_data = I('post.');
    	$page = I('post.page/d')?:1;
    	$page_size = 10;
    	
    	if ($page > 1) {
    		//添加广告图片
    		$adv = AdvController::instance()->getAdv('hbsquare');
    		$enveList_s = S('enveList'.$this->openid);
    		if (empty($enveList_s)) {
    			$this->ajaxReturn(['code'=>20400, 'msg'=>'没有更多了']);
    		}
    		$enveList_s = unserialize($enveList_s);
    		$offset = $page -1;
    		$enveList = array_slice($enveList_s,$offset*$page_size ,$page_size);
    		
    		if (empty($enveList)) {
    			$this->ajaxReturn(['code'=>20400, 'msg'=>'没有更多了']);
    		}
    		
    		$this->ajaxReturn(['code'=>20000, 'msg'=>'success', 'data'=>$enveList, 'adv'=>$adv]);
    	}
    	
    	$conditions = array('pay_status'=>'ok', 'a.amount'=>array('gt',0), 'share2square'=>1, 'del'=>0, 'be_overdue'=>0);
    	//如果传了红包类型过滤条件 加入筛选数组
    	if (isset($post_data['enve_type']) ) {
    		$enveType = intval($post_data['enve_type']);
    		if ($enveType != -1) {
    			$conditions['enve_type']= intval($post_data['enve_type']);
    		}
    		
    	}
    	//默认最新发布排序
    	$orderStr = 'id desc';
    	if (isset($post_data['orderby']) && !empty($post_data['orderby'])) {
    		$orderbyArr = array(
    				'show_amount_asc' => 'show_amount asc',
    				'show_amount_desc' => 'show_amount desc',
    				'add_time_asc' => 'add_time asc',
    				'add_time_desc' => 'add_time desc',
    		);
    		$ordertmp = $orderbyArr[$post_data['orderby']];
    		if (!empty($ordertmp)) {
    			$orderStr = $ordertmp;
    		}
    	}
    	
    	$enveModel = M('enve');
    	$field = 'a.num,a.receive_num,a.id,a.enve_type,a.show_amount,a.is_adv,a.adv_url,a.adv_text,FROM_UNIXTIME(a.add_time,\'%m月%d日 %H:%i\') add_time,b.head_img,b.user_name';
    	$enveList = $enveModel->alias('a')->join('LEFT JOIN '.C('DB_PREFIX').'wx_user b ON a.user_id=b.id')->field($field)->where($conditions)->order($orderStr)->select();
    	
    	if (empty($enveList)) {
    		$this->ajaxReturn(['code'=>20400, 'msg'=>'没有更多了']);
    	}
    	
    	$enveLists = array_slice($enveList,0,$page_size);
    	
    	
    	
    	S('enveList'.$this->openid, serialize($enveList));
    	//添加广告图片
    	$adv = AdvController::instance()->getAdv('hbsquare');
    	
    	$this->ajaxReturn(['code'=>20000, 'msg'=>'success', 'data'=>$enveLists, 'adv'=>$adv]);
    }
    

    /**
     * post 参数 前端获取到的respay中的package和pid
     * 前端确认是否支付成功，支付成功发送生成口令通知
     */
    public function sendCreateEnveNotify() {
        $post_data = I('post.');
        //发送消息
        $enveStr = '口令红包“'.$post_data['quest'].'”';
        switch ($post_data['enve_type']) {
        	case 1:
        		$enveStr = '口令祝福红包';
        		break;
        		
        	case 2:
        		$enveStr = '问答红包“'.$post_data['answer'].'”';
        		break;
        }
        $tplData = [
            'keyword1'=>[
            		'value'=> $enveStr,
                'color'=>'#173177',
            ],
            'keyword2'=>[
                'value'=> date('m月d日 H:i'),
                'color'=>'#173177',
            ],
            'keyword3'=>[
                'value'=> '点击此处查看红包详情',
                'color'=>'#173177',
            ]
        ];
        $param = [
            'touser' => $this->openid,
            'template_id' => C('news_tpl_send'),
            'page' => '/pages/recordDetails/recordDetails?pid='.$post_data['pid'],
            'form_id' => $post_data['prepay_id'],
            'data' => $tplData,
        ];
        //$weixinController = new WeixinController();
        //$weixinController -> send_template($param);
        WeixinController::instance()->send_template($param);
    }
    /**
     * 领取红包
     * time 2017.9.30
     */
    public function saveEnveReceive(){
    	
        $post_data = I('post.');
        $pid = I('post.pid/d');
        //红包信息
        $enve_model = M("Enve");
        //过期时间
        $expire = 86400;
        //获取临时红包信息
        $info = $enve_model->where("id='%d' and del=0 and pay_status='%s'",array($pid, 'ok'))->find();
        if(!$info){
            $this->ajaxReturn(['code'=>40500, 'msg'=>'不是有效红包!']);
        }
        if($info['be_overdue']==1){
            $this->ajaxReturn(['code'=>40500, 'msg'=>'红包已失效!']);
        }

         //检测是否领取过红包
        $enve_receive_model = D("EnveReceive");
        $count = $enve_receive_model->where("pid='%d' and user_id='%s'",array($pid, $this->user_id))->count();
        if($count >  0){
            $this->ajaxReturn(['code'=>40500, 'msg'=>'您已领此取过红包']);
        }

        //不是真心寄语的需要判断语音
        if ($info['enve_type'] != 1) {
            //调用百度语音识别接口转文字start
            $sample = new Sample();
//             $post_data['voice_url'] = trim($post_data['voice_url'],'&quot;');
             $post_data['voice_url'] = trim($post_data['voice_url'],'/');
            //获取识别结果
            $aa = $resText = $sample->identify($post_data);
            $resText = json_decode($resText,true);
            $sampleText = str_replace('，', '', $resText['result'][0]);
            //转拼音
            $py = new Pinyin();
            $samplepy = $py->getPY($sampleText);

            if(!$samplepy){
                $this->ajaxReturn(['code'=>40000, 'msg'=>'您没有说话哟',$resText=>$sampleText,$samplepy=>$aa]);
            };
            $compareStr = '';
            if ($info['enve_type'] == 0) {
            	$compareStr = $info['quest_py'];
            }else {
            	$compareStr = $info['answer_py'];
            }

            if( $samplepy != $compareStr){
                $is_pass = false;
                //字符相似度
                $str = similar_text($samplepy,$compareStr);
                $quest_len = strlen($compareStr);

                //小于两个字
                if(($quest_len < 4 && $samplepy == $compareStr)
                    || ($quest_len < 16 &&  $str / $quest_len >= 0.98)
                    || ($quest_len < 28 && $str / $quest_len >= 0.95)
                    || ($quest_len < 40 && $str / $quest_len >= 0.92)
                ){
                    $is_pass = true;
                }
                //语音长度
                if($quest_len != strlen($samplepy)){
                    $is_pass = false;
                }

                if($is_pass == false ){
                    $this->ajaxReturn(['code'=>40000, 'msg'=>'语音不正确',$aa=>$samplepy,$str=>$info['quest_py']]);
                }
            }
        }
        
        //通过判断后领取红包
        $queue = Queue::getInstance(C('QUEUE_PREFIX').'enve'.$pid);
//         if ($queue->len() == 0) {//如果队列为0 则红包失效
//         	$info = $enve_model->where("id='%d' and pay_status='%s'",array($pid, 'ok'))->find();
//         	if ($info['num'] == $info['receive_num']) {
//         		$this->ajaxReturn(['code'=>40500, 'msg'=>'哎呀你手慢了!']);
//         	}
//         	$moneyList = $this->get_rand($info['amount'], $info['num']-$info['receive_num'], C('RECEIVE_AMOUNT_MIN'));
        	
//         	$usersRecord = M('enve_receive')->field('openid')->where(array('pid'=>$pid))->select();
//         	$users = array();
//         	foreach ($usersRecord as $k => $v){
//         		$users[] = $v['user_id'];
//         	}
        	
//         	$enveInfo = array('moneyList'=>$moneyList, 'amount'=>$info['amount'], 'receiveNum'=>$info['receive_num'], 'enveNum'=>$info['num'], 'users'=>$users);
//         	$queue->push(json_encode($enveInfo));
//         	$this->ajaxReturn(['code'=>40500, 'msg'=>'红包已失效!']);
//         }
        $enveInfo = unserialize($queue->pop());//获取红包信息
        
        if ($enveInfo['receiveNum'] == $enveInfo['enveNum']) {
        	$this->ajaxReturn(['code'=>40500, 'msg'=>'哎呀你手慢了!']);
        }
        
        if (in_array($this->openid, $enveInfo['users'])) {
        	$this->ajaxReturn(['code'=>40500, 'msg'=>'不能重复领取!']);
        }
        
        $enveInfo['amount'] = number_format($enveInfo['amount'] - $enveInfo['moneyList'][0],2);
        $enveInfo['receiveNum'] = $enveInfo['receiveNum'] + 1;
        $receive_amount = $enveInfo['moneyList'][0];
        array_splice($enveInfo['moneyList'],0,1);
        $enveInfo['users'][] = $this->user_id;
        
        //插入领红包选项检测
        $post_data['receive_amount'] = $receive_amount;
        $post_data = $enve_receive_model->create($post_data);
        if(!$post_data){
        	$msg = $enve_receive_model->getError()?:'系统繁忙';
        	$this->ajaxReturn(['code' => 50000, 'msg' => $msg ]);
        };
        
        //开始事务
        M()->startTrans();
        //更新红包数量和金额
        $data = array('amount'=>$enveInfo['amount'],'receive_num'=>$enveInfo['receiveNum'],'update_time'=>time());
        $res = $enve_model->where('id='.$pid.' and del=0')->save($data);
        if(!$res){
        	$enveInfo = $this->queue_rollback($enveInfo, $receive_amount);
        	$queue->push(serialize($enveInfo));
        	$enve_model->rollback();
        	$this->ajaxReturn(['code'=>50000, 'msg'=>'红包领取失败!（en）']);
        }
        
        //领取表入库
        $last_id = $enve_receive_model->add($post_data);
        if(!$last_id){
        	$enveInfo = $this->queue_rollback($enveInfo, $receive_amount);
        	$queue->push(serialize($enveInfo));
        	$enve_receive_model->rollback();
        	$this->ajaxReturn(['code'=>50000, 'msg'=>'红包领取失败!(rece)']);
        }
        
        //更新用户余额
        $res_user = M('WxUser')->where('id ='.$this->user_id)->setInc('amount',$receive_amount); // 增加money到余额
        if(!$res_user){
        	$enveInfo = $this->queue_rollback($enveInfo, $receive_amount);
        	$queue->push(serialize($enveInfo));
        	M('WxUser')->rollback();
        	$this->ajaxReturn(['code'=>50000, 'msg'=>'红包领取失败!(user)']);
        }
        
        //插log
        $log_data = [
        		'pay_type'=> '1',
        		'amount'=>$data['amount'],
        		'pay_status'=> 'ok',
        		'desc'=>get_log_tpl('receive_enve'),
        		'source'=>__ACTION__,
        		'add_time'=>time(),
        ];
        $res_log = set_money_log($log_data);
        if(!$res_log){
        	$enveInfo = $this->queue_rollback($enveInfo, $receive_amount);
        	$queue->push(serialize($enveInfo));
        	M('MoneyLog')->rollback();
        	$this->ajaxReturn(['code'=>50000, 'msg'=>'红包领取失败!']);
        }
        
        $queue->push(serialize($enveInfo));//将更新的红包信息放回队列
        //提交事务
        M()->commit();
        
        //判断如果红包已经领完了  发送通知
        if( $enveInfo['enveNum'] == $enveInfo['receiveNum']){
        	Queue::getInstance(C('QUEUE_PREFIX').'enve'.$pid)->flushQueue();//删除队列
        	//计算领取最多的并更新best标记
        	$tempTable = M('enve_receive')->buildSql();
        	$subsql = M()->table($tempTable.' tempTable')->where(array('pid'=>$pid))->field('id')->order('receive_amount desc')->limit(0,1)->buildSql();
        	M('enve_receive')->where('id='.$subsql)->save(array('best'=>1));
        	
        	//判断支付方式
        	$formId = empty($info['prepay_id']) ? $info['form_id'] : $info['prepay_id'];
        	$costTimeStamp = time() - $info['add_time'];
        	if ($costTimeStamp > 60 && $costTimeStamp < 3600) {
        		$costTime = date('i分s秒', $costTimeStamp - 28800);
        	}
        	else if ($costTimeStamp <= 60) {
        		$costTime = date('s秒', $costTimeStamp - 28800);
        	}
        	else {
        		$costTime = date('H时i分s秒', $costTimeStamp - 28800);
        	}
        	
        	/*
        	 * 判断红包类型显示内容
        	 */
        	$content = '口令红包 “'.$info['quest'].'”';
        	switch ($info['enve_type']) {
        		case 1:
        			$content = '祝福红包';
        			break;
        			
        		case 2:
        			$content = '问答红包“'.$info['answer'].'”';
        			break;
        	}
        	
        	//发送消息
        	$tplData = [
        			'keyword1'=>[
        					'value'=> $content,
        					'color'=>'#173177',
        			],
        			'keyword2'=>[
        					'value'=> $costTime . '内被抢完',
        					'color'=>'#173177',
        			],
        			'keyword3'=>[
        					'value'=> '点击此处查看红包详情',
        					'color'=>'#173177',
        			]
        	];
        	$param = [
        			'touser' => $info['openid'],
        			'template_id' => C('news_tpl_finish'),
        			'page' => '/pages/recordDetails/recordDetails?pid='.$pid,
        			'form_id' => $formId,
        			'data' => $tplData,
        	];
        	WeixinController::instance()->send_template($param);
        	
        }
        $this->ajaxReturn(['code'=>20000, 'msg'=>'success', 'data'=>['id'=>$last_id,'amount'=>$receive_amount] ]);
    }
    
    /*
     * 红包更新数据库操作不成功 队列红包信息回滚
     */
    private function queue_rollback($enveInfo, $receive_amount){
    	$enveInfo['amount'] = $enveInfo['amount'] + $receive_amount;
    	
    	$enveInfo['receiveNum'] = $enveInfo['receiveNum'] - 1;
    	array_splice($enveInfo['moneyList'],0,0,$receive_amount);
    	$index = array_search($this->user_id, $enveInfo['users']);
    	unset($enveInfo['users'][$index]);
    	return $enveInfo;
    }
    

    /**
     * 详情
     * time 2017.10.1
     */
    public function enveDetail(){
        $id = I('post.id/d');
        $enve_model = M("Enve");
        $wx_model = M("WxUser");
        $field = 'video_url,adv_text,adv_url,is_adv,enve_type,voice_url,voice_dura,quest,user_id,show_amount,be_overdue,amount,num,receive_num,add_time,update_time';
        $info = $enve_model->field($field)->where("id='%d' and del=0 and pay_status='%s'",array($id, 'ok'))->find();
        $userInfo = $wx_model->field('nick_name,head_img')->where("id='%d'",array($info['user_id']))->find();
        if(!$info){
            $this->ajaxReturn(['code'=>20400, 'msg'=>'没有更多数据']);
        }
        if($userInfo) $info += $userInfo;
        //红包是否被领完 领完则显示时长
        $info['status'] = true;
        if($info['num'] == $info['receive_num']){
        	$info['status'] = false;
        	
        	$costTimeStamp = $info['update_time'] - $info['add_time'];
        	$costTime = null;
        	if ($costTimeStamp > 60 && $costTimeStamp < 3600) {
        		$info['costTime'] = date('i分s秒', $costTimeStamp - 28800);
        	}
        	else if ($costTimeStamp <= 60) {
        		$info['costTime']= date('s秒', $costTimeStamp - 28800);
        	}
        	else {
        		$info['costTime']= date('H时i分s秒', $costTimeStamp - 28800);
        	}
        }

        $receive_model = M("EnveReceive");
        $field = 'best,receive_answer,user_id,nick_name,head_img,receive_amount,receive_num,voice_url,durat,FROM_UNIXTIME(add_time,\'%m月%d日 %H:%i\') add_time';
       
        $info['receive'] = $receive_model->field($field)->order('add_time asc')->where(array('pid'=>$id))->select();
        foreach($info['receive'] as &$v ){
            if($v['user_id'] == $this->user_id){
                $info['recive_status']=true;
                $info['receive_amount']=$v['receive_amount'];
            };
        }
	/*判断是否红包主*/
        $info['owner'] = 0;
        if ($this->user_id == $info['user_id']) {
        	$info['owner'] = 1;
        }
        //添加广告图片
        $info['adv'] = AdvController::instance()->getAdv('hbdetail');
        $this->ajaxReturn(['code'=>20000, 'msg'=>'success', 'data'=>$info]);
    }

    /**
     * 主题列表
     * time 2017.10.9
     */
    public function getTheme(){
        $type = I('type/d',1);
        $res = M('Theme')->where('type=%d',array($type))->select();
        if(!$res){
            $this->ajaxReturn(['code'=>20400, 'msg'=>'没有更多数据']);
        }
        $this->ajaxReturn(['code'=>20000, 'msg'=>'success','data'=>$res]);
    }
    
    /*
     * 常见问题广告
     */
    public function getQuesAdv() {
    	$adv = AdvController::instance()->getAdv('cquestion');
    	$this->ajaxReturn(['code'=>20000, 'msg'=>'success', 'adv'=>$adv]);
    }
    
    /*
     * 获取提示信息
     */
    public function getTips() {
    	
    	$pos = I('post.pos/s');
    	if (empty($pos)) {
    		$this->ajaxReturn(['code'=>50000, 'msg'=>'参数错误']);
    	}
    	$tip = M('ad')->where(array('ad_name'=>$pos))->find();
    	if (empty($pos)) {
    		$this->ajaxReturn(['code'=>50000, 'msg'=>'获取失败']);
    	}
    	$this->ajaxReturn(['code'=>20000, 'msg'=>'success', 'tips'=>$tip['ad_content']]);
    }
    
    /*
     * 获取常见问题
     */
    public function getFAQ() {
    	
    	$faq = M('links')->order('listorder asc')->select();
    	if (empty($faq)) {
    		$this->ajaxReturn(['code'=>50000, 'msg'=>'获取失败']);
    	}
    	$this->ajaxReturn(['code'=>20000, 'msg'=>'success', 'faqList'=>$faq]);
    }
    
    /**
     * @param $total 金额
     * @param $num  个数
     * @param float $min  最小数量
     * @return float|int
     */
    private function get_rand($total,$num,$min = 0.01){
    	//相除
    	$bcdiv_res = sprintf("%.5f",$total/$num);
    	//总价除数量等于0.01直接返回
    	if($bcdiv_res== 0.01){
    		for ($i=0; $i<$num; $i++){
    			$retmoney[] = 0.01;
    		}
    		return $retmoney;
    	}
    	//个数等于1的时候直接返回
    	if($num==1){
    		return [$total];
    	}
    	//保证每个红包不低于0.01元
    	$bcmul_res = bcmul($min, $num,2);//相乘
    	$bcsub_res =  sprintf("%.5f",$total-$bcmul_res) ;//相减
    	
    	//概率设置
    	$probabilitymax = C('RECEIVE_RPOBALIBLITY');
    	
    	$probabilitymin  =  C('RECEIVE_RPOBALIBLITY');
    	
    	$probability = (60 - ($probabilitymax - $probabilitymin) * $num)/99;
    	
    	while ($num) {
    		//如果数量大于1
    		if($num > 1){
    			$money = mt_rand(0,$bcsub_res*$probability*100)/100;
    		}else{
    			$money = $bcsub_res;
    		}
    		//把所有分配的价格组成数组
    		$retmoney[] = $money;
    		$bcsub_res = $bcsub_res - $money;
    		$num--;
    	}
    	
    	
    	foreach($retmoney  as &$v){
    		$v = sprintf("%.2f",$v+$min) ;//相减$min+
    	}
    	shuffle($retmoney);
    	return $retmoney;
    }
    
}
