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
			<li class="active"><a href="#A" data-toggle="tab">网站基本设置</a></li>
			<li><a href="#B" data-toggle="tab">公众号平台配置</a></li>
			<li><a href="#C" data-toggle="tab">小程序配置</a></li>
			<li><a href="#D" data-toggle="tab">红包佣金比例</a></li>
			<li><a href="#E" data-toggle="tab">提现最低金额</a></li>
			<li><a href="#F" data-toggle="tab">客服自动回复</a></li>
		</ul>
		<form class="form-horizontal js-ajax-forms" action="<?php echo U('BasicConfig/site_post');?>" onsubmit="checkForm()" method="post">
			<fieldset>
				<div class="tabbable">
					<div class="tab-content">
						<div class="tab-pane active" id="A">
							<fieldset>
								<div class="control-group">
									<label class="control-label">网站名称</label>
									<div class="controls">
										<input type="text" name="options[site_name]" aria-required="true" value="<?php echo ($site_name); ?>"><span class="form-required">*</span>
										<?php if($option_id): ?>
										<input type="hidden" name="option_id" value="<?php echo ($option_id); ?>">
										<?php endif; ?>
									</div>
								</div>

								<div class="control-group">
									<label class="control-label">备案信息</label>
									<div class="controls">
										<input type="text" name="options[site_icp]" value="<?php echo ($site_icp); ?>">
									</div>
								</div>
								<div class="control-group">
									<label class="control-label">统计代码</label>
									<div class="controls">
										<textarea name="options[site_tongji]" rows="5" cols="57"><?php echo ($site_tongji); ?></textarea>
									</div>
								</div>
								<div class="control-group">
									<label class="control-label">版权信息</label>
									<div class="controls">
										<textarea name="options[site_copyright]" rows="5" cols="57"><?php echo ($site_copyright); ?></textarea>
									</div>
								</div>
							</fieldset>
						</div>
						<div class="tab-pane" id="B">
							<fieldset>
								<div class="control-group">
									<label class="control-label">公众号AppID</label>
									<div class="controls">
										<input type="text" name="options[G_APPID]" value="<?php echo ($G_APPID); ?>">
									</div>
								</div>
								<div class="control-group">
									<label class="control-label">公众号AppSecret</label>
									<div class="controls">
										<input type="text" name="options[G_APPSECRET]" value="<?php echo ($G_APPSECRET); ?>">
									</div>
								</div>
								<div class="control-group">
									<label class="control-label">普通商户号(mchid)</label>
									<div class="controls">
										<input type="text" name="options[G_MCHID]" value="<?php echo ($G_MCHID); ?>">
									</div>
								</div>
								<div class="control-group">
									<label class="control-label">普通商户密钥（key）</label>
									<div class="controls">
										<input type="text" name="options[G_KEY]" value="<?php echo ($G_KEY); ?>">
									</div>
								</div>
							</fieldset>
						</div>
						<div class="tab-pane" id="C">
							<fieldset>
								<div class="control-group">
									<label class="control-label">小程序AppID</label>
									<div class="controls">
										<input type="text" name="options[C_APPID]" value="<?php echo ($C_APPID); ?>">
									</div>
								</div>
								<div class="control-group">
									<label class="control-label">小程序AppSecret</label>
									<div class="controls">
										<input type="text" name="options[C_APPSECRET]" value="<?php echo ($C_APPSECRET); ?>">
									</div>
								</div>
								<div class="control-group">
									<label class="control-label">小程序跳转链接</label>
									<div class="controls">
										<input type="text" name="options[C_JUMP]" placeholder="pages/index/index?id=123" value="<?php echo ($C_JUMP); ?>">
									</div>
								</div>
								<div class="control-group">
									<label class="control-label">消息推送模板id</label>
									<div class="controls">
										<textarea rows="10" style="min-width: 500px; width:50%;" name="options[new_tpl]" placeholder="key : val"><?php echo ($new_tpl); ?></textarea>
									</div>
								</div>
							</fieldset>
						</div>
						<div class="tab-pane" id="D">
							<fieldset>
								<div class="control-group">
									<label class="control-label">红包佣金比例</label>
									<div class="controls">
										<input type="text" name="options[commision]" value="<?php echo ($commision); ?>"> % （建议2%-12%之间）
									</div>
								</div>
								<div class="control-group">
									<label class="control-label">广告红包佣金比例</label>
									<div class="controls">
										<input type="text" name="options[advcommision]" value="<?php echo ($advcommision); ?>"> % （建议2%-12%之间）
									</div>
								</div>
								<div class="control-group">
									<label class="control-label">红包最低金额</label>
									<div class="controls">
										<input type="text" name="options[amount_min]" value="<?php echo ($amount_min); ?>"> （建议1以上）
									</div>
								</div>
								<div class="control-group">
									<label class="control-label">领红包最低金额</label>
									<div class="controls">
										<input type="text" name="options[receive_amount_min]" value="<?php echo ($receive_amount_min); ?>"> （建议1以上）
									</div>
								</div>
							</fieldset>
						</div>
						<div class="tab-pane" id="E">
							<fieldset>
								<div class="control-group">
									<label class="control-label">最低提现金额</label>
									<div class="controls">
										<input type="text" name="options[min_withdrawals]" value="<?php echo ($min_withdrawals); ?>"> 单位（元）
									</div>
								</div>
								
								<div class="control-group">
									<label class="control-label">每天提现次数上限</label>
									<div class="controls">
										<input type="text" name="options[max_withdrawal_time]" value="<?php echo ($max_withdrawal_time); ?>"> 次
									</div>
								</div>
							</fieldset>
						</div>
						<div class="tab-pane" id="F">
							<fieldset>
								<div class="control-group">
									<label class="control-label">标题</label>
									<div class="controls">
										<input type="text" id="hf_title" name="options[title]" value="<?php echo ($title); ?>">
									</div>
								</div>
								
								<div class="control-group">
									<label class="control-label">描述</label>
									<div class="controls">
										<input type="text" id="hf_description" name="options[description]" value="<?php echo ($description); ?>">
									</div>
								</div>
								
								<div class="control-group">
									<label class="control-label">链接</label>
									<div class="controls">
										<input type="text" id="hf_url" name="options[url]" value="<?php echo ($url); ?>">
									</div>
								</div>
								
								<div style="text-align: center;">
									<input type="hidden" name="options[imgurl]" id="thumb" value="<?php echo ($imgurl); ?>">
									<a href="javascript:upload_one_image('图片上传','#thumb');">
									<?php if(empty($imgurl)): ?><img src="/admin/themes/simplebootx/Public/assets/images/default-thumbnail.png" id="thumb-preview" width="135" style="cursor: hand; height: 113px;">									</a>
									<?php else: ?>
									<img src="<?php echo ($imgurl); ?>" id="thumb-preview" width="135" style="cursor: hand; height: 113px;">									</a><?php endif; ?>
									<input type="button" class="btn btn-small" onclick="$('#thumb-preview').attr('src','/admin/themes/simplebootx/Public/assets/images/default-thumbnail.png');$('#thumb').val('');return false;" value="取消图片">
								</div>
							</fieldset>
						</div>
						<div class="tab-pane" id="G">
							<fieldset>
								<div class="control-group">
									<label class="control-label">静态资源cdn地址</label>
									<div class="controls">
										<input type="text" name="cdn_settings[cdn_static_root]" value="<?php echo ($cdn_settings["cdn_static_root"]); ?>">
										<span class="help-block">
											不能以/结尾；设置这个地址后，请将ThinkCMF下的静态资源文件放在其下面；<br>
											ThinkCMF下的静态资源文件大致包含以下(如果你自定义后，请自行增加)：<br>
											admin/themes/simplebootx/Public/assets<br>
											public<br>
											themes/simplebootx/Public/assets<br>
											例如未设置cdn前：jquery的访问地址是/public/js/jquery.js, 设置cdn是后它的访问地址就是：静态资源cdn地址+/public/js/jquery.js

										</span>
									</div>
								</div>
							</fieldset>
						</div>
					</div>
				</div>

				<div class="form-actions">
					<button type="submit" class="btn btn-primary  js-ajax-submit"><?php echo L("SAVE");?></button>
				</div>
			</fieldset>
		</form>

	</div>
	<script type="text/javascript" src="/zhwmkl_envelop/public/js/common.js"></script>
	<script>
		/////---------------------
		
		$(function(){
			$("#urlmode-select").change(function(){
				if($(this).val()==1){
					alert("更改后，若发现前台链接不能正常访问，可能是您的服务器不支持PATHINFO，请先修改data/conf/config.php文件的URL_MODEL为0保证网站正常运行,在配置服务器PATHINFO功能后再更新为PATHINFO模式！");
				}
				
				if($(this).val()==2){
					alert("更改后，若发现前台链接不能正常访问，可能是您的服务器不支持REWRITE，请先修改data/conf/config.php文件的URL_MODEL为0保证网站正常运行，在开启服务器REWRITE功能后再更新为REWRITE模式！");
				}
			});
			$("#js-site-admin-url-password").change(function(){
				$(this).data("changed",true);
			});
		});
		Wind.use('validate', 'ajaxForm', 'artDialog', function() {
			//javascript
			var form = $('form.js-ajax-forms');
			//ie处理placeholder提交问题
			if ($.browser && $.browser.msie) {
				form.find('[placeholder]').each(function() {
					var input = $(this);
					if (input.val() == input.attr('placeholder')) {
						input.val('');
					}
				});
			}
			
			
			
			//表单验证开始
			form.validate({
				//是否在获取焦点时验证
				onfocusout : false,
				//是否在敲击键盘时验证
				onkeyup : false,
				//当鼠标掉级时验证
				onclick : false,
				//验证错误
				showErrors : function(errorMap, errorArr) {
					//errorMap {'name':'错误信息'}
					//errorArr [{'message':'错误信息',element:({})}]
					try {
						$(errorArr[0].element).focus();
						art.dialog({
							id : 'error',
							icon : 'error',
							lock : true,
							fixed : true,
							background : "#CCCCCC",
							opacity : 0,
							content : errorArr[0].message,
							cancelVal : "<?php echo L('OK');?>",
							cancel : function() {
								$(errorArr[0].element).focus();
							}
						});
					} catch (err) {
					}
				},
				//验证规则
				rules : {
					'options[site_name]' : {
						required : 1
					},
					'options[site_host]' : {
						required : 1
					},
					'options[site_root]' : {
						required : 1
					}
				},
				//验证未通过提示消息
				messages : {
					'options[site_name]' : {
						required : "请填写网站名称"
					}
				},
				//给未通过验证的元素加效果,闪烁等
				highlight : false,
				//是否在获取焦点时验证
				onfocusout : false,
				//验证通过，提交表单
				submitHandler : function(forms) {
					$(forms).ajaxSubmit({
						url : form.attr('action'), //按钮上是否自定义提交地址(多按钮情况)
						dataType : 'json',
						beforeSubmit : function(arr, $form, options) {

						},
						success : function(data, statusText, xhr, $form) {
							if (data.status) {
								setCookie("refersh_time", 1);
								var admin_url_changed=$("#js-site-admin-url-password").data("changed");
								var message =admin_url_changed?data.info+'<br><span style="color:red;">后台地址已更新(请劳记！)</span>':data.info;
								
								//添加成功
								Wind.use("artDialog", function() {
									art.dialog({
										id : "succeed",
										icon : "succeed",
										fixed : true,
										lock : true,
										background : "#CCCCCC",
										opacity : 0,
										content : message,
										button : [ {
											name : "<?php echo L('OK');?>",
											callback : function() {
												reloadPage(window);
												return true;
											},
											focus : true
										}, {
											name : "<?php echo L('CLOSE');?>",
											callback : function() {
												reloadPage(window);
												return true;
											}
										} ]
									});
								});
							} else {
								alert(data.info);
							}
						}
					});
				}
			});
		});
		////-------------------------
	</script>
</body>
</html>