<?php
namespace Admin\Controller;

use Common\Controller\AdminbaseController;

class EnveController extends AdminbaseController
{

	protected $enves_model;

	public function _initialize() {
		parent::_initialize();
		$this->enves_model = D("Enve");
	}

	// 红包列表
	public function index()
    {

        /**搜索条件**/
        $openid = I('request.openid');
        $keywork = trim(I('request.keywork'));

		//根据openid 搜索
        if ($openid) {
            $where['openid'] = $openid;
        }
		//根据user_name 搜索
        if ($keywork) {
            $where['user_name'] = array('like', "%$keywork%");
			$where['quest'] = array('like', "%$keywork%");
            $where['_logic'] = 'OR';
        }

        $count = $this->enves_model->where($where)->count();
        $page = $this->page($count, 20);
        $enves = $this->enves_model
            ->where($where)
            ->order("add_time DESC")
            ->limit($page->firstRow, $page->listRows)
            ->select();

		$arr = [1=>'微信支付', 2=>'余额支付', 3=>'混合支付'];
        foreach ($enves as &$v){

			$v['pay_type'] = $arr[$v['pay_type']];
            $v['add_time'] = date('Y-m-d H:i:s',$v['add_time']);
			if (strlen($v['quest']) > 24) {
				$v['quest'] = substr($v['quest'], 0, 24).".....";
			}

        }

        $this->assign("page", $page->show('Admin'));
        $this->assign("enves", $enves);
        $this->display();
    }
	//根据id删除一条红包表(enve)的数据
	public function removeEnve()
	{
		//获取Id
        $id = I('post.id');

		$bool = C('WEALTHY');
		//检查id是否存在这个表
		if (!C('WEALTHY')){
            $this -> ajaxReturn(['msg' => '该用户不存在']);
        }

		$Enve = D("Enve");

		$bool = $Enve->delete($id);

		if ($bool) {
			$this -> ajaxReturn(['msg' => '删除成功']);
		}






	}

}
