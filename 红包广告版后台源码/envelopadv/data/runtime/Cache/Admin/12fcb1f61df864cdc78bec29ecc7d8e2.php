<?php if (!defined('THINK_PATH')) exit();?><!doctype html>
<html>
<head>
	<meta charset="utf-8">
	<!-- Set render engine for 360 browser -->
	<meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <!-- HTML5 shim for IE8 support of HTML5 elements -->
    <!--[if lt IE 9]>
      <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
    <![endif]-->

	<link href="/zhwmkl_envelop/public/simpleboot/themes/<?php echo C('SP_ADMIN_STYLE');?>/theme.min.css" rel="stylesheet">
    <link href="/zhwmkl_envelop/public/simpleboot/css/simplebootadmin.css" rel="stylesheet">
    <link href="/zhwmkl_envelop/public/js/artDialog/skins/default.css" rel="stylesheet" />
    <link href="/zhwmkl_envelop/public/simpleboot/font-awesome/4.4.0/css/font-awesome.min.css"  rel="stylesheet" type="text/css">
    <style>
		form .input-order{margin-bottom: 0px;padding:3px;width:40px;}
		.table-actions{margin-top: 5px; margin-bottom: 5px;padding:0px;}
		.table-list{margin-bottom: 0px;}
	</style>
	<!--[if IE 7]>
	<link rel="stylesheet" href="/zhwmkl_envelop/public/simpleboot/font-awesome/4.4.0/css/font-awesome-ie7.min.css">
	<![endif]-->
	<script type="text/javascript">
	//全局变量
	var GV = {
	    ROOT: "/zhwmkl_envelop/",
	    WEB_ROOT: "/zhwmkl_envelop/",
	    JS_ROOT: "public/js/",
	    APP:'<?php echo (MODULE_NAME); ?>'/*当前应用名*/
	};
	</script>
    <script src="/zhwmkl_envelop/public/js/jquery.js"></script>
    <script src="/zhwmkl_envelop/public/js/layer/layer.js"></script>
    <script src="/zhwmkl_envelop/public/js/wind.js"></script>
    <script src="/zhwmkl_envelop/public/simpleboot/bootstrap/js/bootstrap.min.js"></script>
    <script>
    	$(function(){
    		$("[data-toggle='tooltip']").tooltip();
    	});
    </script>
<?php if(APP_DEBUG): ?><style>
		#think_page_trace_open{
			z-index:9999;
		}
	</style><?php endif; ?>
</head>
<body>
	<div class="wrap js-check-wrap">
		<ul class="nav nav-tabs">
			<li class="active"><a href="<?php echo U('Customer/index');?>">用户列表</a></li>
		</ul>
        <form class="well form-search" method="post" action="<?php echo U('Customer/index');?>">
            请输入OpenId:
            <input type="text" name="openid" style="width: 100px;" value="<?php echo I('request.openid/s','');?>" placeholder="请输入OpenId">
			关键字:
            <input type="text" name="keywork" style="width: 200px;" value="<?php echo I('request.keywork/s','');?>" placeholder="用户名/昵称/手机号">
            <input type="submit" class="btn btn-primary" value="搜索" />
            <a class="btn btn-danger" href="<?php echo U('Customer/index');?>">清空</a>
        </form>
		<table class="table table-hover table-bordered">
			<thead>
				<tr>
					<th>ID</th>
					<th>用户名称</th>
					<th>昵称</th>
					<th>头像</th>
					<th>余额</th>
					<th>冻结金额</th>
					<th>openid</th>
					<th>电话</th>
					<th>性别</th>
					<th>注册IP</th>
					<th>注册时间</th>
					<th>最后登录时间</th>
					<th>操作</th>
				</tr>
			</thead>
			<tbody>
				<?php if(is_array($users)): foreach($users as $key=>$vo): ?><tr>
					<td><?php echo ($vo["id"]); ?></td>
					<td><?php echo ($vo["user_name"]); ?></td>
					<td><?php echo ($vo["nick_name"]); ?></td>
					<td><a class="img-show" href="javascript:" attr-img="<?php echo ($vo["head_img"]); ?>"><img width="30" height="30" src="<?php echo ($vo["head_img"]); ?>"/></a></td>
					<td><?php echo ($vo["amount"]); ?></td>
					<td><?php echo ($vo["frozen_amount"]); ?></td>
					<td class="openid"><?php echo ($vo["openid"]); ?></td>
					<td><?php echo ($vo["phone"]); ?></td>
					<td><?php echo ($vo["sex"]); ?></td>
					<td><?php echo ($vo["ip_addr"]); ?></td>
					<td><?php echo ($vo["add_time"]); ?></td>
					<td><?php echo ($vo["update_time"]); ?></td>
					<td>
						<button class="add-to-vip btn btn-sm btn-default btn-danger">加入vip</button>
						<button class="remove-from-vip btn btn-sm btn-default btn-default">移除vip</button>
					</td>
				</tr><?php endforeach; endif; ?>
			</tbody>
		</table>
		<div class="pagination"><?php echo ($page); ?></div>
	</div>
	<script src="/zhwmkl_envelop/public/js/common.js"></script>
	<script>
		$('.img-show').on('click',function(){
		   var img_src = $(this).attr('attr-img');
		   console.log(img_src);
            //页面层-自定义
            layer.open({
                type: 1,
                title: false,
                closeBtn: 0,
                shadeClose: true,
                skin: 'yourclass',
                content: '<img src="'+img_src+'"/>'
            });
		})
		$('.add-to-vip').on('click', function () {
		    var openid = $(this).parents('tr').find('.openid').text();
		    $.post("<?php echo U('User/addToWealthyGroup');?>", {'openid':openid}, function ($data) {
				alert($data.msg);
			});
		});
		$('.remove-from-vip').on('click', function() {
		    var openid = $(this).parents('tr').find('.openid').text();
			$.post("<?php echo U('User/removeFromWealthyGroup');?>", {'openid':openid}, function ($data) {
				alert($data.msg);
			});
		})
	</script>
</body>
</html>