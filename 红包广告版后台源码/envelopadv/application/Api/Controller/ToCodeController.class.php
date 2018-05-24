<?php
/**
 * 获取二维码
 * author universe.h
 */
namespace Api\Controller;
use Common\Controller\InterceptController;
use Common\Controller\WeixinController;
use Common\Controller\AdvController;

class ToCodeController extends InterceptController {
	
	/**
	 * 小程序获取二维码
	 * time 2017.9.30
	 */
	public function get_code() {
		$data['page'] = I('post.page/s');
		$data['width'] = I('post.width/d',430);
		$data['auto_color'] = I('post.auto_color/s');
		$data['line_color'] = I('post.line_color/s');
		$pid = I('post.pid/d');
		$data['scene'] = $pid;
		
		if(!$data['page']){
			$this->ajaxReturn(['code'=>40000, 'msg'=>'跳转链接不能为空']);
		}
		
		$share_pic = M('share_pic')->where(array('pid'=>$pid))->find();
		if (!empty($share_pic)) {
			//添加广告
			$adv = AdvController::instance()->getAdv('share');
			$this->ajaxReturn(['code'=>20000, 'msg'=>'success', 'data'=>$share_pic['purl'], 'adv'=>$adv],false,JSON_UNESCAPED_SLASHES);
		}
		
		$info = WeixinController::instance()->get_wxa_code($data);
		$path = C('UPLOADPATH').'code/';
		if(!is_dir($path)){
			mkdir(iconv("UTF-8", "GBK", $path),0777,true);
		}
		$file = rand(10000000,99999999).'.png';
		$paths = $path . $file;
		$res = file_put_contents( $paths,$info );
		
		$path_head = $path.'head'.$file;
		
		if($res){
			$res = file_put_contents( $path_head, file_get_contents($this->head_img));
			
			$imgs = array(
					'dst' => 'data/upload/back.png',
					'pic' => 'data/upload/redtips.png',
					'src' => $paths,
					'head' => $path_head,
			);
			
			if($res){
				$this->tosize($imgs['head'],96,true);
				$roundImg = $this->toround($imgs);
				$this->mergerImg($imgs,$roundImg);
				$con=[
						'tit'=> I('post.tit/s','发起了一个红包游戏'),
						'con'=> I('post.con/s','一个比真心话大冒险还好玩的游戏'),
				];
				$this->totxt($imgs,$con);
				
				M('share_pic')->add(array('pid'=>$pid, 'purl'=>$paths, 'createtime'=>time()));
				//添加广告
				$adv = AdvController::instance()->getAdv('share');
				$this->ajaxReturn(['code'=>20000, 'msg'=>'success', 'data'=>$paths, 'adv'=>$adv],false,JSON_UNESCAPED_SLASHES);
			}
			
		}
		$this->ajaxReturn(['code'=>40000, 'msg'=>'生成失败']);
		
		
	}
	
	//改变图片大小
	public function tosize($url,$max = 200,$is_pic = false){
		//因为PHP只能对资源进行操作，所以要对需要进行缩放的图片进行拷贝，创建为新的资源
		$src=imagecreatefromjpeg($url);
		
		//取得源图片的宽度和高度
		$size_src=getimagesize($url);
		$w=$size_src['0'];
		$h=$size_src['1'];
		if($max >= $w){
			return false;
		}
		
		//根据最大值为300，算出另一个边的长度，得到缩放后的图片宽度和高度
		if($w > $h){
			$w=$max;
			$h=$h*($max/$size_src['0']);
		}else{
			$h=$max;
			$w=$w*($max/$size_src['1']);
		}
		//声明一个$w宽，$h高的真彩图片资源
		$image=imagecreatetruecolor($w, $h);
		
		//关键函数，参数（目标资源，源，目标资源的开始坐标x,y, 源资源的开始坐标x,y,目标资源的宽高w,h,源资源的宽高w,h）
		imagecopyresampled($image, $src, 0, 0, 0, 0, $w, $h, $size_src['0'], $size_src['1']);
		
		if(!$is_pic){
			return $image;
		}
		
		//告诉浏览器以图片形式解析
		header('content-type:image/png');
		
		imagepng($image,$url);
		
		//销毁资源
		imagedestroy($image);
	}
	
	//合并
	public function mergerImg($imgs,$oth) {
		//生成原型图
		imagepng($oth, $imgs['src']);
		list($max_width, $max_height) = getimagesize($imgs['dst']);
		$dests = imagecreatetruecolor($max_width, $max_height);
		
		$dst_im = imagecreatefrompng($imgs['dst']);
		imagecopy($dests,$dst_im,0,0,0,0,$max_width,$max_height);
		imagedestroy($dst_im);
		
		//合成二维码
		$src_im = imagecreatefrompng($imgs['src']);
		imagealphablending($src_im,true);
		$src_info = getimagesize($imgs['src']);
		imagecopy($dests, $src_im,$max_width/2-90,$max_height/2-90,0,0,$src_info[0],$src_info[1]);
		
		//合成头像
		$head_img = imagecreatefrompng($imgs['head']);
		//获取头像长宽等信息
		$head_info = getimagesize($imgs['head']);
		
		imagecopy($dests, $head_img,$max_width/2-$head_info[0]/2,30,0,0, 96,96);
		imagedestroy($src_im);
		
		header("Content-type: image/png");
		imagepng($dests,$imgs['src']);
		//        imagepng($dests);
		unlink($imgs['head']);
	}
	
	//添加文字
	public function totxt($src,$textArr){
		
		//获取图片信息
		$info = getimagesize($src['src']);
		//        var_dump($info);die;
		//获取图片扩展名
		$type = image_type_to_extension($info[2],false);
		//动态的把图片导入内存中
		$fun = "imagecreatefrom{$type}";
		$image = $fun($src['src']);
		//指定字体颜色
		$col = imagecolorallocatealpha($image,255,255,255,1);
		$font_file = 'simplewind/Core/Library/Think/Verify/zhttfs/1.ttf';
		
		$b = imagettfbbox(20,0, $font_file,$textArr['tit'] );
		
		$textX=ceil(($info[0] - $b[2]) / 2);
		$lengb = abs(b[0] - $b[2]);
		//指定字体内容
		imagefttext($image, 20, 0,  $textX-16, $info[1]/5, $col, $font_file,mb_convert_encoding($textArr['tit'],'html-entities','UTF-8'));
		
		$b = imagettfbbox(28,0, $font_file,$textArr['con'] );
		//指定字体内容
		imagefttext($image, 28, 0,  ceil(($info[0] - $b[2]) / 2), $info[1]/3.8, $col, $font_file,mb_convert_encoding($textArr['con'],'html-entities','UTF-8'));
		
		
		//合成头像
		$pic = imagecreatefrompng($src['pic']);
		
		//获取头像长宽等信息
		$head_info = getimagesize($src['pic']);
		imagecopy($image, $pic, $textX +$lengb-8,$info[1]/5.7,0,0, 30,30);
		
		//指定输入类型
		header('Content-type:'.$info['mime']);
		//动态的输出图片到浏览器中
		$func = "image{$type}";
		$func($image,$src['src']);
		//销毁图片
		imagedestroy($image);
		
	}
	
	
	//生成圆二维码
	public function toround($imgs,$path='./'){
		//       $w = 100;  $h=100; // original size
		$sizeImg = $this->tosize($imgs['src'], 180);
		header('content-type:image/png');
		imagepng($sizeImg,$imgs['src']);
		//       $dest_path = $path.uniqid().'.png';
		$src = imagecreatefromstring(file_get_contents($imgs['src']));
		//取得源图片的宽度和高度
		list($w,$h)=getimagesize($imgs['src']);
		
		$newpic = imagecreatetruecolor($w,$h);
		imagealphablending($newpic,false);
		$transparent = imagecolorallocatealpha($newpic, 0, 0, 0, 127);
		
		imageantialias ( $transparent ,true );
		$r=$w/2;
		for($x=0;$x<$w;$x++)
			for($y=0;$y<$h;$y++){
				$c = imagecolorat($src,$x,$y);
				$_x = $x - $w/2;
				$_y = $y - $h/2;
				if((($_x*$_x) + ($_y*$_y)) < ($r*$r)){
					imagesetpixel($newpic,$x,$y,$c);
				}else{
					imagesetpixel($newpic,$x,$y,$transparent);
				}
		}
		
		imagesavealpha($newpic, true);
		
		//       header('content-type:image/png');
		//        imagepng($newpic);
		//        imagepng($newpic, $dest_path);
		imagedestroy($src);
		// unlink($url);
		return $newpic;
	}
	
	
}

