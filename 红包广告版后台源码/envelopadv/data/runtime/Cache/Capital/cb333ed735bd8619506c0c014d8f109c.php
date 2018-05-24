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
		<li class="active"><a href="<?php echo U('Capital/withdrawals');?>">提现明细</a></li>
		<!--<li><a href="<?php echo U('Capital/pay');?>">已支付</a></li>-->
		<!--<li><a href="<?php echo U('Capital/pay');?>">未支付</a></li>-->
	</ul>
	<form class="well form-search" method="post" action="<?php echo U('Capital/withdrawals');?>">
		时间：
		<input type="text" name="start_time" class="js-datetime" value="<?php echo I('request.start_time/s','');?>" style="width: 120px;" autocomplete="off">-
		<input type="text" class="js-datetime" name="end_time" value="<?php echo I('request.end_time/s','');?>" style="width: 120px;" autocomplete="off"> &nbsp; &nbsp;
		<input type="submit" class="btn btn-primary" value="搜索" />
		<a class="btn btn-danger" href="<?php echo U('Capital/withdrawals');?>">清空</a>
	</form>
	<table class="table table-hover table-bordered">
		<thead>
		<tr>
			<th width="50">ID</th>
			<th>公众号的APPID</th>
			<th>用户openid</th>
			<th>收款用户真实姓名</th>
			<th>收款用户身份证号</th>
			<th>付款说明</th>
			<th>交易单号
			<th>提现金额</th>
			<th>提现状态</th>
			<th>提现时间</th>
		</tr>
		</thead>
		</td>		<tbody>
		<?php if(is_array($info)): foreach($info as $key=>$vo): ?><tr>
				<td><?php echo ($vo["id"]); ?></td>
				<td><?php echo ($vo["appid"]); ?></td>
				<td><?php echo ($vo["openid"]); ?></td>
				<td><?php echo ($vo["usernames"]); ?></td>
				<td><?php echo ($vo["id_card"]); ?>
				<td><?php echo ($vo["pay_desc"]); ?></td>
				<td><?php echo ($vo["nonce_str"]); ?></td>
				<td><b><?php echo ($vo["amount"]); ?></b></td>
				<td><b><?php echo ($vo["status"]); ?></b></td>
				<td><?php echo ($vo["add_time"]); ?></td>
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

</script>
</body>
</html>