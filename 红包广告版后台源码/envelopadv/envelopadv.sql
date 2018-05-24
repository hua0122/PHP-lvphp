/*
SQLyog Ultimate v12.09 (64 bit)
MySQL - 5.5.53 : Database - envelopadv
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
/*Table structure for table `hb_ad` */

DROP TABLE IF EXISTS `hb_ad`;

CREATE TABLE `hb_ad` (
  `ad_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '广告id',
  `ad_name` varchar(255) NOT NULL COMMENT '广告名称',
  `ad_content` text COMMENT '广告内容',
  `status` int(2) NOT NULL DEFAULT '1' COMMENT '状态，1显示，0不显示',
  PRIMARY KEY (`ad_id`),
  KEY `ad_name` (`ad_name`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

/*Data for the table `hb_ad` */

/*Table structure for table `hb_asset` */

DROP TABLE IF EXISTS `hb_asset`;

CREATE TABLE `hb_asset` (
  `aid` bigint(20) NOT NULL AUTO_INCREMENT,
  `uid` int(11) NOT NULL DEFAULT '0' COMMENT '用户 id',
  `key` varchar(50) NOT NULL COMMENT '资源 key',
  `filename` varchar(50) DEFAULT NULL COMMENT '文件名',
  `filesize` int(11) DEFAULT NULL COMMENT '文件大小,单位Byte',
  `filepath` varchar(200) NOT NULL COMMENT '文件路径，相对于 upload 目录，可以为 url',
  `uploadtime` int(11) NOT NULL COMMENT '上传时间',
  `status` int(2) NOT NULL DEFAULT '1' COMMENT '状态，1：可用，0：删除，不可用',
  `meta` text COMMENT '其它详细信息，JSON格式',
  `suffix` varchar(50) DEFAULT NULL COMMENT '文件后缀名，不包括点',
  `download_times` int(11) NOT NULL DEFAULT '0' COMMENT '下载次数',
  PRIMARY KEY (`aid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='资源表';

/*Data for the table `hb_asset` */

/*Table structure for table `hb_auth_access` */

DROP TABLE IF EXISTS `hb_auth_access`;

CREATE TABLE `hb_auth_access` (
  `role_id` mediumint(8) unsigned NOT NULL COMMENT '角色',
  `rule_name` varchar(255) NOT NULL COMMENT '规则唯一英文标识,全小写',
  `type` varchar(30) DEFAULT NULL COMMENT '权限规则分类，请加应用前缀,如admin_',
  KEY `role_id` (`role_id`) USING BTREE,
  KEY `rule_name` (`rule_name`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='权限授权表';

/*Data for the table `hb_auth_access` */

insert  into `hb_auth_access`(`role_id`,`rule_name`,`type`) values (6,'statis/user/envelop_user','admin_url'),(6,'statis/user/get_usersummary','admin_url'),(6,'statis/user/index','admin_url'),(6,'statis/counts/index','admin_url'),(6,'admin/user/cancelban','admin_url'),(6,'admin/user/ban','admin_url'),(6,'admin/user/add_post','admin_url'),(6,'admin/user/add','admin_url'),(6,'admin/user/edit_post','admin_url'),(6,'admin/user/edit','admin_url'),(6,'admin/user/delete','admin_url'),(6,'admin/user/index','admin_url'),(6,'admin/rbac/roleadd_post','admin_url'),(6,'admin/rbac/roleadd','admin_url'),(6,'admin/rbac/roledelete','admin_url'),(6,'admin/rbac/roleedit_post','admin_url'),(6,'admin/rbac/roleedit','admin_url'),(6,'admin/rbac/authorize_post','admin_url'),(6,'admin/rbac/authorize','admin_url'),(6,'admin/rbac/member','admin_url'),(6,'admin/rbac/index','admin_url'),(6,'user/indexadmin/default3','admin_url'),(6,'user/oauthadmin/delete','admin_url'),(6,'user/oauthadmin/index','admin_url'),(6,'user/indexadmin/cancelban','admin_url'),(6,'user/indexadmin/ban','admin_url'),(6,'user/indexadmin/index','admin_url'),(6,'user/indexadmin/default1','admin_url'),(6,'user/indexadmin/default','admin_url'),(6,'statis/money/index','admin_url'),(6,'statis/money/get_sum','admin_url'),(6,'admin/customer/index','admin_url'),(6,'capital/capital/index','admin_url'),(6,'capital/capital/pay','admin_url'),(6,'capital/capital/withdrawals','admin_url'),(6,'capital/capital/receive','admin_url');

/*Table structure for table `hb_auth_rule` */

DROP TABLE IF EXISTS `hb_auth_rule`;

CREATE TABLE `hb_auth_rule` (
  `id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT COMMENT '规则id,自增主键',
  `module` varchar(20) NOT NULL COMMENT '规则所属module',
  `type` varchar(30) NOT NULL DEFAULT '1' COMMENT '权限规则分类，请加应用前缀,如admin_',
  `name` varchar(255) NOT NULL DEFAULT '' COMMENT '规则唯一英文标识,全小写',
  `param` varchar(255) DEFAULT NULL COMMENT '额外url参数',
  `title` varchar(20) NOT NULL DEFAULT '' COMMENT '规则中文描述',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否有效(0:无效,1:有效)',
  `condition` varchar(300) NOT NULL DEFAULT '' COMMENT '规则附加条件',
  PRIMARY KEY (`id`),
  KEY `module` (`module`,`status`,`type`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=194 DEFAULT CHARSET=utf8 COMMENT='权限规则表';

/*Data for the table `hb_auth_rule` */

insert  into `hb_auth_rule`(`id`,`module`,`type`,`name`,`param`,`title`,`status`,`condition`) values (175,'Statis','admin_url','statis/counts/index',NULL,'统计',1,''),(176,'Statis','admin_url','statis/user/index',NULL,'用户统计',1,''),(177,'Admin','admin_url','admin/basicconfig/index',NULL,'基本配置',1,''),(178,'Statis','admin_url','statis/user/get_usersummary',NULL,'公众号用户',1,''),(179,'Statis','admin_url','statis/user/envelop_user',NULL,'本地红包用户统计',1,''),(180,'Statis','admin_url','statis/money/index',NULL,'资金流动',1,''),(181,'Admin','admin_url','admin/customer/index',NULL,'用户信息',1,''),(182,'Statis','admin_url','statis/money/get_sum',NULL,'资金流动异步方法',1,''),(183,'Capital','admin_url','capital/capital/index',NULL,'资金明细',1,''),(184,'Capital','admin_url','capital/capital/pay',NULL,'支付明细',1,''),(185,'Capital','admin_url','capital/capital/withdrawals',NULL,'提现明细',1,''),(186,'Capital','admin_url','capital/capital/receive',NULL,'领取明细',1,''),(187,'Admin','admin_url','admin/enve/index',NULL,'红包管理',1,''),(188,'Admin','admin_url','admin/content/default',NULL,'内容管理',1,''),(189,'Api','admin_url','api/oauthadmin/setting',NULL,'第三方登陆',1,''),(190,'User','admin_url','user/oauthadmin/index',NULL,'第三方用户',1,''),(191,'Admin','admin_url','admin/slide/default',NULL,'广告',1,''),(192,'Admin','admin_url','admin/plugin/index',NULL,'插件管理',1,''),(193,'Admin','admin_url','admin/ad/index',NULL,'提示语',1,'');

/*Table structure for table `hb_comments` */

DROP TABLE IF EXISTS `hb_comments`;

CREATE TABLE `hb_comments` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `post_table` varchar(100) NOT NULL COMMENT '评论内容所在表，不带表前缀',
  `post_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '评论内容 id',
  `url` varchar(255) DEFAULT NULL COMMENT '原文地址',
  `uid` int(11) NOT NULL DEFAULT '0' COMMENT '发表评论的用户id',
  `to_uid` int(11) NOT NULL DEFAULT '0' COMMENT '被评论的用户id',
  `full_name` varchar(50) DEFAULT NULL COMMENT '评论者昵称',
  `email` varchar(255) DEFAULT NULL COMMENT '评论者邮箱',
  `createtime` datetime NOT NULL DEFAULT '2000-01-01 00:00:00' COMMENT '评论时间',
  `content` text NOT NULL COMMENT '评论内容',
  `type` smallint(1) NOT NULL DEFAULT '1' COMMENT '评论类型；1实名评论',
  `parentid` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '被回复的评论id',
  `path` varchar(500) DEFAULT NULL,
  `status` smallint(1) NOT NULL DEFAULT '1' COMMENT '状态，1已审核，0未审核',
  PRIMARY KEY (`id`),
  KEY `comment_post_ID` (`post_id`) USING BTREE,
  KEY `comment_approved_date_gmt` (`status`) USING BTREE,
  KEY `comment_parent` (`parentid`) USING BTREE,
  KEY `table_id_status` (`post_table`,`post_id`,`status`) USING BTREE,
  KEY `createtime` (`createtime`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='评论表';

/*Data for the table `hb_comments` */

/*Table structure for table `hb_common_action_log` */

DROP TABLE IF EXISTS `hb_common_action_log`;

CREATE TABLE `hb_common_action_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user` bigint(20) DEFAULT '0' COMMENT '用户id',
  `object` varchar(100) DEFAULT NULL COMMENT '访问对象的id,格式：不带前缀的表名+id;如posts1表示xx_posts表里id为1的记录',
  `action` varchar(50) DEFAULT NULL COMMENT '操作名称；格式规定为：应用名+控制器+操作名；也可自己定义格式只要不发生冲突且惟一；',
  `count` int(11) DEFAULT '0' COMMENT '访问次数',
  `last_time` int(11) DEFAULT '0' COMMENT '最后访问的时间戳',
  `ip` varchar(15) DEFAULT NULL COMMENT '访问者最后访问ip',
  PRIMARY KEY (`id`),
  KEY `user_object_action` (`user`,`object`,`action`) USING BTREE,
  KEY `user_object_action_ip` (`user`,`object`,`action`,`ip`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='访问记录表';

/*Data for the table `hb_common_action_log` */

/*Table structure for table `hb_enve` */

DROP TABLE IF EXISTS `hb_enve`;

CREATE TABLE `hb_enve` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `quest` varchar(150) NOT NULL DEFAULT '' COMMENT '口令或者问题',
  `quest_py` varchar(255) DEFAULT '' COMMENT '口令拼音',
  `answer` varchar(255) NOT NULL DEFAULT '' COMMENT '答案',
  `answer_py` varchar(255) DEFAULT '' COMMENT '答案拼音',
  `user_id` int(11) NOT NULL DEFAULT '0' COMMENT '用户id',
  `openid` varchar(36) DEFAULT '' COMMENT '微信openid',
  `user_name` varchar(255) NOT NULL DEFAULT '' COMMENT '用户名/昵称',
  `pay_type` char(1) NOT NULL DEFAULT '0' COMMENT '支付类型 1微信支付 2 余额支付 3 部分微信部分余额支付',
  `show_amount` decimal(18,2) DEFAULT '0.00' COMMENT '显示金额',
  `amount` decimal(18,2) NOT NULL DEFAULT '0.00' COMMENT '金额',
  `commission` decimal(18,2) NOT NULL DEFAULT '0.00' COMMENT '佣金',
  `pay_status` char(50) NOT NULL DEFAULT '' COMMENT '支付状态 ok支付成功  cancel取消支付 fail支付失败',
  `nonce_str` varchar(50) DEFAULT '' COMMENT '本地随机生成的订单号',
  `out_trade_no` varchar(50) DEFAULT '' COMMENT '商户订单号',
  `transaction_id` varchar(32) DEFAULT '' COMMENT '微信支付订单号',
  `num` int(8) NOT NULL DEFAULT '0' COMMENT '个数',
  `form_id` varchar(64) NOT NULL DEFAULT '' COMMENT '小程序表单提交的formId',
  `prepay_id` varchar(64) NOT NULL DEFAULT '' COMMENT '支付产生的prepay_id',
  `receive_num` int(8) NOT NULL DEFAULT '0' COMMENT '已领取个数',
  `be_overdue` tinyint(1) NOT NULL DEFAULT '0' COMMENT '红包是否过期：0未过期，1过期',
  `add_time` int(11) NOT NULL DEFAULT '0' COMMENT '添加时间',
  `update_time` int(11) NOT NULL DEFAULT '0',
  `enve_type` tinyint(4) DEFAULT '0' COMMENT '红包类型0普通口令 1真心寄语 2你说我猜',
  `is_adv` tinyint(4) DEFAULT '0' COMMENT '0不是广告红包 1是广告红包',
  `adv_url` varchar(255) DEFAULT NULL COMMENT '广告文件',
  `voice_url` varchar(255) DEFAULT NULL COMMENT '你说我猜语音文件',
  `share2square` tinyint(4) DEFAULT '0' COMMENT '是否分享到广场',
  `voice_dura` int(11) DEFAULT NULL COMMENT '语音时长 毫秒数',
  `video_url` varchar(255) DEFAULT NULL COMMENT '视频广告地址',
  `adv_text` varchar(255) DEFAULT NULL COMMENT '广告语',
  `del` tinyint(1) unsigned DEFAULT '0' COMMENT '是否删除',
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`) USING BTREE COMMENT '用户id'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

/*Data for the table `hb_enve` */

/*Table structure for table `hb_enve_receive` */

DROP TABLE IF EXISTS `hb_enve_receive`;

CREATE TABLE `hb_enve_receive` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `pid` int(11) NOT NULL DEFAULT '0' COMMENT 'enve表id',
  `receive_answer` varchar(200) NOT NULL DEFAULT '' COMMENT '答案',
  `user_id` int(11) NOT NULL DEFAULT '0' COMMENT '用户id',
  `nick_name` varchar(150) NOT NULL DEFAULT '' COMMENT '昵称',
  `head_img` varchar(150) NOT NULL DEFAULT '' COMMENT '头像',
  `receive_amount` decimal(18,2) NOT NULL DEFAULT '0.00' COMMENT '金额',
  `receive_num` int(8) NOT NULL DEFAULT '0' COMMENT '领取个数',
  `voice_url` varchar(100) NOT NULL DEFAULT '' COMMENT '微信语音路径',
  `durat` varchar(11) NOT NULL DEFAULT '0' COMMENT '语音时长',
  `add_time` int(11) NOT NULL DEFAULT '0' COMMENT '添加时间',
  `best` tinyint(4) DEFAULT '0' COMMENT '是否最佳0 1',
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`,`pid`) USING BTREE COMMENT '用户id'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

/*Data for the table `hb_enve_receive` */

/*Table structure for table `hb_guestbook` */

DROP TABLE IF EXISTS `hb_guestbook`;

CREATE TABLE `hb_guestbook` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `full_name` varchar(50) NOT NULL COMMENT '留言者姓名',
  `email` varchar(100) NOT NULL COMMENT '留言者邮箱',
  `title` varchar(255) DEFAULT NULL COMMENT '留言标题',
  `msg` text NOT NULL COMMENT '留言内容',
  `createtime` datetime NOT NULL COMMENT '留言时间',
  `status` smallint(2) NOT NULL DEFAULT '1' COMMENT '留言状态，1：正常，0：删除',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='留言表';

/*Data for the table `hb_guestbook` */

/*Table structure for table `hb_links` */

DROP TABLE IF EXISTS `hb_links`;

CREATE TABLE `hb_links` (
  `link_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `link_url` varchar(255) NOT NULL COMMENT '友情链接地址',
  `link_name` varchar(255) NOT NULL COMMENT '友情链接名称',
  `link_image` varchar(255) DEFAULT NULL COMMENT '友情链接图标',
  `link_target` varchar(25) NOT NULL DEFAULT '_blank' COMMENT '友情链接打开方式',
  `link_description` text NOT NULL COMMENT '友情链接描述',
  `link_status` int(2) NOT NULL DEFAULT '1' COMMENT '状态，1显示，0不显示',
  `link_rating` int(11) NOT NULL DEFAULT '0' COMMENT '友情链接评级',
  `link_rel` varchar(255) DEFAULT NULL COMMENT '链接与网站的关系',
  `listorder` int(10) NOT NULL DEFAULT '0' COMMENT '排序',
  PRIMARY KEY (`link_id`),
  KEY `link_visible` (`link_status`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COMMENT='友情链接表';

/*Data for the table `hb_links` */

insert  into `hb_links`(`link_id`,`link_url`,`link_name`,`link_image`,`link_target`,`link_description`,`link_status`,`link_rating`,`link_rel`,`listorder`) values (2,'21','1','2','_blank','21',1,0,NULL,0);

/*Table structure for table `hb_menu` */

DROP TABLE IF EXISTS `hb_menu`;

CREATE TABLE `hb_menu` (
  `id` smallint(6) unsigned NOT NULL AUTO_INCREMENT,
  `parentid` smallint(6) unsigned NOT NULL DEFAULT '0',
  `app` varchar(30) NOT NULL DEFAULT '' COMMENT '应用名称app',
  `model` varchar(30) NOT NULL DEFAULT '' COMMENT '控制器',
  `action` varchar(50) NOT NULL DEFAULT '' COMMENT '操作名称',
  `data` varchar(50) NOT NULL DEFAULT '' COMMENT '额外参数',
  `type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '菜单类型  1：权限认证+菜单；0：只作为菜单',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '状态，1显示，0不显示',
  `name` varchar(50) NOT NULL COMMENT '菜单名称',
  `icon` varchar(50) DEFAULT NULL COMMENT '菜单图标',
  `remark` varchar(255) NOT NULL DEFAULT '' COMMENT '备注',
  `listorder` smallint(6) unsigned NOT NULL DEFAULT '0' COMMENT '排序ID',
  PRIMARY KEY (`id`),
  KEY `status` (`status`) USING BTREE,
  KEY `parentid` (`parentid`) USING BTREE,
  KEY `model` (`model`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=200 DEFAULT CHARSET=utf8 COMMENT='后台菜单表';

/*Data for the table `hb_menu` */

insert  into `hb_menu`(`id`,`parentid`,`app`,`model`,`action`,`data`,`type`,`status`,`name`,`icon`,`remark`,`listorder`) values (1,0,'Admin','Content','default','',0,0,'内容管理','th','',30),(2,1,'Api','Guestbookadmin','index','',1,1,'所有留言','','',0),(3,2,'Api','Guestbookadmin','delete','',1,0,'删除网站留言','','',0),(4,1,'Comment','Commentadmin','index','',1,1,'评论管理','','',0),(5,4,'Comment','Commentadmin','delete','',1,0,'删除评论','','',0),(6,4,'Comment','Commentadmin','check','',1,0,'评论审核','','',0),(7,1,'Portal','AdminPost','index','',1,1,'文章管理','','',1),(8,7,'Portal','AdminPost','listorders','',1,0,'文章排序','','',0),(9,7,'Portal','AdminPost','top','',1,0,'文章置顶','','',0),(10,7,'Portal','AdminPost','recommend','',1,0,'文章推荐','','',0),(11,7,'Portal','AdminPost','move','',1,0,'批量移动','','',1000),(12,7,'Portal','AdminPost','check','',1,0,'文章审核','','',1000),(13,7,'Portal','AdminPost','delete','',1,0,'删除文章','','',1000),(14,7,'Portal','AdminPost','edit','',1,0,'编辑文章','','',1000),(15,14,'Portal','AdminPost','edit_post','',1,0,'提交编辑','','',0),(16,7,'Portal','AdminPost','add','',1,0,'添加文章','','',1000),(17,16,'Portal','AdminPost','add_post','',1,0,'提交添加','','',0),(18,1,'Portal','AdminTerm','index','',0,1,'分类管理','','',2),(19,18,'Portal','AdminTerm','listorders','',1,0,'文章分类排序','','',0),(20,18,'Portal','AdminTerm','delete','',1,0,'删除分类','','',1000),(21,18,'Portal','AdminTerm','edit','',1,0,'编辑分类','','',1000),(22,21,'Portal','AdminTerm','edit_post','',1,0,'提交编辑','','',0),(23,18,'Portal','AdminTerm','add','',1,0,'添加分类','','',1000),(24,23,'Portal','AdminTerm','add_post','',1,0,'提交添加','','',0),(25,1,'Portal','AdminPage','index','',1,1,'页面管理','','',3),(26,25,'Portal','AdminPage','listorders','',1,0,'页面排序','','',0),(27,25,'Portal','AdminPage','delete','',1,0,'删除页面','','',1000),(28,25,'Portal','AdminPage','edit','',1,0,'编辑页面','','',1000),(29,28,'Portal','AdminPage','edit_post','',1,0,'提交编辑','','',0),(30,25,'Portal','AdminPage','add','',1,0,'添加页面','','',1000),(31,30,'Portal','AdminPage','add_post','',1,0,'提交添加','','',0),(32,1,'Admin','Recycle','default','',1,1,'回收站','','',4),(33,32,'Portal','AdminPost','recyclebin','',1,1,'文章回收','','',0),(34,33,'Portal','AdminPost','restore','',1,0,'文章还原','','',1000),(35,33,'Portal','AdminPost','clean','',1,0,'彻底删除','','',1000),(36,32,'Portal','AdminPage','recyclebin','',1,1,'页面回收','','',1),(37,36,'Portal','AdminPage','clean','',1,0,'彻底删除','','',1000),(38,36,'Portal','AdminPage','restore','',1,0,'页面还原','','',1000),(39,0,'Admin','Extension','default','',0,1,'扩展工具','cloud','',40),(40,39,'Admin','Backup','default','',1,0,'备份管理','','',0),(41,40,'Admin','Backup','restore','',1,1,'数据还原','','',0),(42,40,'Admin','Backup','index','',1,1,'数据备份','','',0),(43,42,'Admin','Backup','index_post','',1,0,'提交数据备份','','',0),(44,40,'Admin','Backup','download','',1,0,'下载备份','','',1000),(45,40,'Admin','Backup','del_backup','',1,0,'删除备份','','',1000),(46,40,'Admin','Backup','import','',1,0,'数据备份导入','','',1000),(47,39,'Admin','Plugin','index','',1,0,'插件管理','','',0),(48,47,'Admin','Plugin','toggle','',1,0,'插件启用切换','','',0),(49,47,'Admin','Plugin','setting','',1,0,'插件设置','','',0),(50,49,'Admin','Plugin','setting_post','',1,0,'插件设置提交','','',0),(51,47,'Admin','Plugin','install','',1,0,'插件安装','','',0),(52,47,'Admin','Plugin','uninstall','',1,0,'插件卸载','','',0),(53,39,'Admin','Slide','default','',1,1,'广告','','',1),(54,53,'Admin','Slide','index','',1,1,'幻灯片管理','','',0),(55,54,'Admin','Slide','listorders','',1,0,'幻灯片排序','','',0),(56,54,'Admin','Slide','toggle','',1,0,'幻灯片显示切换','','',0),(57,54,'Admin','Slide','delete','',1,0,'删除幻灯片','','',1000),(58,54,'Admin','Slide','edit','',1,0,'编辑幻灯片','','',1000),(59,58,'Admin','Slide','edit_post','',1,0,'提交编辑','','',0),(60,54,'Admin','Slide','add','',1,0,'添加幻灯片','','',1000),(61,60,'Admin','Slide','add_post','',1,0,'提交添加','','',0),(62,53,'Admin','Slidecat','index','',1,1,'幻灯片分类','','',0),(63,62,'Admin','Slidecat','delete','',1,0,'删除分类','','',1000),(64,62,'Admin','Slidecat','edit','',1,0,'编辑分类','','',1000),(65,64,'Admin','Slidecat','edit_post','',1,0,'提交编辑','','',0),(66,62,'Admin','Slidecat','add','',1,0,'添加分类','','',1000),(67,66,'Admin','Slidecat','add_post','',1,0,'提交添加','','',0),(68,39,'Admin','Ad','index','',1,1,'提示语','','',2),(69,68,'Admin','Ad','toggle','',1,0,'广告显示切换','','',0),(70,68,'Admin','Ad','delete','',1,0,'删除广告','','',1000),(71,68,'Admin','Ad','edit','',1,0,'编辑广告','','',1000),(72,71,'Admin','Ad','edit_post','',1,0,'提交编辑','','',0),(73,68,'Admin','Ad','add','',1,0,'添加广告','','',1000),(74,73,'Admin','Ad','add_post','',1,0,'提交添加','','',0),(75,39,'Admin','Link','index','',0,1,'友情链接','','',3),(76,75,'Admin','Link','listorders','',1,0,'友情链接排序','','',0),(77,75,'Admin','Link','toggle','',1,0,'友链显示切换','','',0),(78,75,'Admin','Link','delete','',1,0,'删除友情链接','','',1000),(79,75,'Admin','Link','edit','',1,0,'编辑友情链接','','',1000),(80,79,'Admin','Link','edit_post','',1,0,'提交编辑','','',0),(81,75,'Admin','Link','add','',1,0,'添加友情链接','','',1000),(82,81,'Admin','Link','add_post','',1,0,'提交添加','','',0),(83,39,'Api','Oauthadmin','setting','',1,0,'第三方登陆','leaf','',4),(84,83,'Api','Oauthadmin','setting_post','',1,0,'提交设置','','',0),(85,0,'Admin','Menu','default','',1,1,'菜单管理','list','',20),(86,85,'Admin','Navcat','default1','',1,1,'前台菜单','','',0),(87,86,'Admin','Nav','index','',1,1,'菜单管理','','',0),(88,87,'Admin','Nav','listorders','',1,0,'前台导航排序','','',0),(89,87,'Admin','Nav','delete','',1,0,'删除菜单','','',1000),(90,87,'Admin','Nav','edit','',1,0,'编辑菜单','','',1000),(91,90,'Admin','Nav','edit_post','',1,0,'提交编辑','','',0),(92,87,'Admin','Nav','add','',1,0,'添加菜单','','',1000),(93,92,'Admin','Nav','add_post','',1,0,'提交添加','','',0),(94,86,'Admin','Navcat','index','',1,1,'菜单分类','','',0),(95,94,'Admin','Navcat','delete','',1,0,'删除分类','','',1000),(96,94,'Admin','Navcat','edit','',1,0,'编辑分类','','',1000),(97,96,'Admin','Navcat','edit_post','',1,0,'提交编辑','','',0),(98,94,'Admin','Navcat','add','',1,0,'添加分类','','',1000),(99,98,'Admin','Navcat','add_post','',1,0,'提交添加','','',0),(100,85,'Admin','Menu','index','',1,1,'后台菜单','','',0),(101,100,'Admin','Menu','add','',1,0,'添加菜单','','',0),(102,101,'Admin','Menu','add_post','',1,0,'提交添加','','',0),(103,100,'Admin','Menu','listorders','',1,0,'后台菜单排序','','',0),(104,100,'Admin','Menu','export_menu','',1,0,'菜单备份','','',1000),(105,100,'Admin','Menu','edit','',1,0,'编辑菜单','','',1000),(106,105,'Admin','Menu','edit_post','',1,0,'提交编辑','','',0),(107,100,'Admin','Menu','delete','',1,0,'删除菜单','','',1000),(108,100,'Admin','Menu','lists','',1,0,'所有菜单','','',1000),(109,0,'Admin','Setting','default','',0,1,'设置','cogs','',0),(110,109,'Admin','Setting','userdefault','',0,1,'个人信息','','',0),(111,110,'Admin','User','userinfo','',1,1,'修改信息','','',0),(112,111,'Admin','User','userinfo_post','',1,0,'修改信息提交','','',0),(113,110,'Admin','Setting','password','',1,1,'修改密码','','',0),(114,113,'Admin','Setting','password_post','',1,0,'提交修改','','',0),(115,109,'Admin','Setting','site','',1,1,'网站信息','','',0),(116,115,'Admin','Setting','site_post','',1,0,'提交修改','','',0),(117,115,'Admin','Route','index','',1,0,'路由列表','','',0),(118,115,'Admin','Route','add','',1,0,'路由添加','','',0),(119,118,'Admin','Route','add_post','',1,0,'路由添加提交','','',0),(120,115,'Admin','Route','edit','',1,0,'路由编辑','','',0),(121,120,'Admin','Route','edit_post','',1,0,'路由编辑提交','','',0),(122,115,'Admin','Route','delete','',1,0,'路由删除','','',0),(123,115,'Admin','Route','ban','',1,0,'路由禁止','','',0),(124,115,'Admin','Route','open','',1,0,'路由启用','','',0),(125,115,'Admin','Route','listorders','',1,0,'路由排序','','',0),(126,109,'Admin','Mailer','default','',1,1,'邮箱配置','','',0),(127,126,'Admin','Mailer','index','',1,1,'SMTP配置','','',0),(128,127,'Admin','Mailer','index_post','',1,0,'提交配置','','',0),(129,126,'Admin','Mailer','active','',1,1,'注册邮件模板','','',0),(130,129,'Admin','Mailer','active_post','',1,0,'提交模板','','',0),(131,109,'Admin','Setting','clearcache','',1,1,'清除缓存','','',1),(132,0,'User','Indexadmin','default','',1,1,'用户管理','group','',10),(133,132,'User','Indexadmin','default1','',1,1,'用户组','','',0),(134,133,'User','Indexadmin','index','',1,1,'本站用户','leaf','',0),(135,134,'User','Indexadmin','ban','',1,0,'拉黑会员','','',0),(136,134,'User','Indexadmin','cancelban','',1,0,'启用会员','','',0),(137,133,'User','Oauthadmin','index','',1,0,'第三方用户','leaf','',0),(138,137,'User','Oauthadmin','delete','',1,0,'第三方用户解绑','','',0),(139,132,'User','Indexadmin','default3','',1,1,'管理组','','',0),(140,139,'Admin','Rbac','index','',1,1,'角色管理','','',0),(141,140,'Admin','Rbac','member','',1,0,'成员管理','','',1000),(142,140,'Admin','Rbac','authorize','',1,0,'权限设置','','',1000),(143,142,'Admin','Rbac','authorize_post','',1,0,'提交设置','','',0),(144,140,'Admin','Rbac','roleedit','',1,0,'编辑角色','','',1000),(145,144,'Admin','Rbac','roleedit_post','',1,0,'提交编辑','','',0),(146,140,'Admin','Rbac','roledelete','',1,1,'删除角色','','',1000),(147,140,'Admin','Rbac','roleadd','',1,1,'添加角色','','',1000),(148,147,'Admin','Rbac','roleadd_post','',1,0,'提交添加','','',0),(149,139,'Admin','User','index','',1,1,'管理员','','',0),(150,149,'Admin','User','delete','',1,0,'删除管理员','','',1000),(151,149,'Admin','User','edit','',1,0,'管理员编辑','','',1000),(152,151,'Admin','User','edit_post','',1,0,'编辑提交','','',0),(153,149,'Admin','User','add','',1,0,'管理员添加','','',1000),(154,153,'Admin','User','add_post','',1,0,'添加提交','','',0),(155,47,'Admin','Plugin','update','',1,0,'插件更新','','',0),(156,109,'Admin','Storage','index','',1,1,'文件存储','','',0),(157,156,'Admin','Storage','setting_post','',1,0,'文件存储设置提交','','',0),(158,54,'Admin','Slide','ban','',1,0,'禁用幻灯片','','',0),(159,54,'Admin','Slide','cancelban','',1,0,'启用幻灯片','','',0),(160,149,'Admin','User','ban','',1,0,'禁用管理员','','',0),(161,149,'Admin','User','cancelban','',1,0,'启用管理员','','',0),(166,127,'Admin','Mailer','test','',1,0,'测试邮件','','',0),(167,109,'Admin','Setting','upload','',1,1,'上传设置','','',0),(168,167,'Admin','Setting','upload_post','',1,0,'上传设置提交','','',0),(169,7,'Portal','AdminPost','copy','',1,0,'文章批量复制','','',0),(174,100,'Admin','Menu','backup_menu','',1,0,'备份菜单','','',0),(175,100,'Admin','Menu','export_menu_lang','',1,0,'导出后台菜单多语言包','','',0),(176,100,'Admin','Menu','restore_menu','',1,0,'还原菜单','','',0),(177,100,'Admin','Menu','getactions','',1,0,'导入新菜单','','',0),(187,0,'Statis','Counts','index','',1,1,'统计','','',1),(188,187,'Statis','User','index','',1,1,'用户统计','','',0),(189,0,'Admin','BasicConfig','index','',1,1,'基本配置','cogs','',0),(190,188,'Statis','User','get_usersummary','',1,0,'公众号用户','','',0),(191,188,'Statis','User','envelop_user','',1,0,'本地红包用户统计','','',0),(192,187,'Statis','Money','index','',1,1,'资金流动','','',0),(193,0,'Admin','Customer','index','',1,1,'用户信息','group','',0),(194,192,'Statis','Money','get_sum','',1,0,'资金流动异步方法','','',0),(195,0,'Capital','Capital','index','',1,1,'资金明细','','',0),(196,195,'Capital','Capital','pay','',1,1,'支付明细','','',0),(197,195,'Capital','Capital','withdrawals','',1,1,'提现明细','','',0),(198,195,'Capital','Capital','receive','',1,1,'领取明细','','',0),(199,0,'Admin','Enve','index','',1,1,'红包管理','','',0);

/*Table structure for table `hb_money_log` */

DROP TABLE IF EXISTS `hb_money_log`;

CREATE TABLE `hb_money_log` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `pay_type` char(1) NOT NULL DEFAULT '1' COMMENT '支付类型 1微信支付',
  `user_id` int(11) NOT NULL DEFAULT '0' COMMENT '用户id',
  `nonce_str` varchar(255) CHARACTER SET utf8mb4 NOT NULL DEFAULT '' COMMENT '支付订单号',
  `out_trade_no` varchar(255) NOT NULL DEFAULT '' COMMENT '微信商户订单号',
  `amount` decimal(18,2) NOT NULL DEFAULT '0.00',
  `source` varchar(255) NOT NULL DEFAULT '' COMMENT '来源',
  `desc` varchar(255) NOT NULL DEFAULT '' COMMENT '资金流动说明',
  `pay_status` varchar(255) NOT NULL DEFAULT '' COMMENT '支付状态',
  `add_time` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `hb_money_log` */

/*Table structure for table `hb_nav` */

DROP TABLE IF EXISTS `hb_nav`;

CREATE TABLE `hb_nav` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `cid` int(11) NOT NULL COMMENT '导航分类 id',
  `parentid` int(11) NOT NULL COMMENT '导航父 id',
  `label` varchar(255) NOT NULL COMMENT '导航标题',
  `target` varchar(50) DEFAULT NULL COMMENT '打开方式',
  `href` varchar(255) NOT NULL COMMENT '导航链接',
  `icon` varchar(255) NOT NULL COMMENT '导航图标',
  `status` int(2) NOT NULL DEFAULT '1' COMMENT '状态，1显示，0不显示',
  `listorder` int(6) DEFAULT '0' COMMENT '排序',
  `path` varchar(255) NOT NULL DEFAULT '0' COMMENT '层级关系',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COMMENT='前台导航表';

/*Data for the table `hb_nav` */

/*Table structure for table `hb_nav_cat` */

DROP TABLE IF EXISTS `hb_nav_cat`;

CREATE TABLE `hb_nav_cat` (
  `navcid` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL COMMENT '导航分类名',
  `active` int(1) NOT NULL DEFAULT '1' COMMENT '是否为主菜单，1是，0不是',
  `remark` text COMMENT '备注',
  PRIMARY KEY (`navcid`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COMMENT='前台导航分类表';

/*Data for the table `hb_nav_cat` */

/*Table structure for table `hb_oauth_user` */

DROP TABLE IF EXISTS `hb_oauth_user`;

CREATE TABLE `hb_oauth_user` (
  `id` int(20) NOT NULL AUTO_INCREMENT,
  `from` varchar(20) NOT NULL COMMENT '用户来源key',
  `name` varchar(30) NOT NULL COMMENT '第三方昵称',
  `head_img` varchar(200) NOT NULL COMMENT '头像',
  `uid` int(20) NOT NULL COMMENT '关联的本站用户id',
  `create_time` datetime NOT NULL COMMENT '绑定时间',
  `last_login_time` datetime NOT NULL COMMENT '最后登录时间',
  `last_login_ip` varchar(16) NOT NULL COMMENT '最后登录ip',
  `login_times` int(6) NOT NULL COMMENT '登录次数',
  `status` tinyint(2) NOT NULL,
  `access_token` varchar(512) NOT NULL,
  `expires_date` int(11) NOT NULL COMMENT 'access_token过期时间',
  `openid` varchar(40) NOT NULL COMMENT '第三方用户id',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='第三方用户表';

/*Data for the table `hb_oauth_user` */

/*Table structure for table `hb_options` */

DROP TABLE IF EXISTS `hb_options`;

CREATE TABLE `hb_options` (
  `option_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `option_name` varchar(64) NOT NULL COMMENT '配置名',
  `option_value` longtext NOT NULL COMMENT '配置值',
  `autoload` int(2) NOT NULL DEFAULT '1' COMMENT '是否自动加载',
  PRIMARY KEY (`option_id`),
  UNIQUE KEY `option_name` (`option_name`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=14 DEFAULT CHARSET=utf8 COMMENT='全站配置表';

/*Data for the table `hb_options` */

insert  into `hb_options`(`option_id`,`option_name`,`option_value`,`autoload`) values (9,'site_options','{\"site_name\":\"\\u7206\\u4f60\\u59b9\",\"site_admin_url_password\":\"\",\"site_tpl\":\"simplebootx\",\"site_adminstyle\":\"flat\",\"site_icp\":\"\\u8303\\u5fb7\\u8428\",\"site_admin_email\":\"\",\"site_tongji\":\"\\u8303\\u5fb7\\u8428\",\"site_copyright\":\"\\u53d1\\u751f\\u7684\",\"site_seo_title\":\"\",\"site_seo_keywords\":\"\",\"site_seo_description\":\"\",\"urlmode\":\"1\",\"html_suffix\":\"\",\"comment_time_interval\":\"60\"}',1),(10,'cmf_settings','{\"banned_usernames\":\"\"}',1),(11,'cdn_settings','{\"cdn_static_root\":\"\"}',1),(12,'customer_options','{\"site_name\":\"\\u7206\\u4f60\\u59b9\",\"site_icp\":\"123\",\"site_tongji\":\"312\",\"site_copyright\":\"132\",\"G_APPID\":\"wx3e3bbdf9fcc01316\",\"G_APPSECRET\":\"a7ecfa38a88df3acc8bf7fd7d658e4b7\",\"G_MCHID\":\"1492633832\",\"G_KEY\":\"zhi8huis52df244sd65sdfwe4r43fsfp\",\"C_APPID\":\"wx752b20c05257dbe1\",\"C_APPSECRET\":\"95f57e55839e1482804c1929c21ec00c\",\"C_JUMP\":\"pages\\/index\\/index?id=123\",\"new_tpl\":\"news_tpl_send : maCtOP96wLIi9ynCnHJ17DgcnQcvmHw9-v1WlkM9yHg,\\nnews_tpl_finish : 044zEgNwSPRBG_sL2Hy44QPH91kFH3R8lKoQIAUA1Gg,\\nnews_tpl_refund: XitxWZCwM29DZm87K1Ivw2r4-AIa8H2A-NbiF0qWwvQ\",\"commision\":\"1\",\"advcommision\":\"3\",\"amount_min\":\"0.01\",\"receive_amount_min\":\"0.01\",\"min_withdrawals\":\"1\",\"max_withdrawal_time\":\"1000000\",\"title\":\"\\u798f\\u5229\\u5929\\u5929\\u9886\",\"description\":\"\\u70b9\\u51fb\\u9886\\u53d6\",\"url\":\"http:\\/\\/mp.weixin.qq.com\\/s\\/BmN4BK8f5ZgNqJehsWXS4w\",\"imgurl\":\"\\/zhwmkl_envelop\\/data\\/upload\\/\\/zhwmkl_envelop\\/data\\/upload\\/\\/zhwmkl_envelop\\/data\\/upload\\/\\/zhwmkl_envelop\\/data\\/upload\\/\\/zhwmkl_envelop\\/data\\/upload\\/\\/zhwmkl_envelop\\/data\\/upload\\/\\/zhwmkl_envelop\\/data\\/upload\\/\\/zhwmkl_envelop\\/data\\/upload\\/\\/zhwmkl_envelop\\/data\\/upload\\/\\/zhwmkl_envelop\\/data\\/upload\\/\\/zhwmkl_envelop\\/data\\/upload\\/\\/zhwmkl_envelop\\/data\\/upload\\/\\/adv_envelop\\/data\\/upload\\/\\/adv_envelop\\/data\\/upload\\/\\/adv_envelop\\/data\\/upload\\/\\/adv_envelop\\/data\\/upload\\/\\/adv_envelop\\/data\\/upload\\/\\/adv_envelop\\/data\\/upload\\/\\/adv_envelop\\/data\\/upload\\/\\/adv_envelop\\/data\\/upload\\/\\/adv_envelop\\/data\\/upload\\/\\/adv_envelop\\/data\\/upload\\/admin\\/20171219\\/5a387717493fe.jpg\"}',1),(13,'upload_setting','{\"image\":{\"upload_max_filesize\":\"10240\",\"extensions\":\"jpg,jpeg,png,gif,bmp4\"},\"video\":{\"upload_max_filesize\":\"10240\",\"extensions\":\"mp4,avi,wmv,rm,rmvb,mkv\"},\"audio\":{\"upload_max_filesize\":\"10240\",\"extensions\":\"mp3,wma,wav,silk\"},\"file\":{\"upload_max_filesize\":\"10240\",\"extensions\":\"txt,pdf,doc,docx,xls,xlsx,ppt,pptx,zip,rar\"}}',1);

/*Table structure for table `hb_pay_log` */

DROP TABLE IF EXISTS `hb_pay_log`;

CREATE TABLE `hb_pay_log` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `pay_type` char(1) NOT NULL DEFAULT '1' COMMENT '支付类型 1微信支付 2余额支付  ',
  `transaction_id` varchar(32) NOT NULL DEFAULT '' COMMENT '微信商户订单',
  `status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '0：正常 1: 支付失败 2：支付异常',
  `desc` varchar(255) NOT NULL DEFAULT '' COMMENT '简述',
  `action` varchar(150) DEFAULT '' COMMENT '来源',
  `content` varchar(1000) NOT NULL DEFAULT '' COMMENT 'log具体内容',
  `add_time` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

/*Data for the table `hb_pay_log` */

/*Table structure for table `hb_plugins` */

DROP TABLE IF EXISTS `hb_plugins`;

CREATE TABLE `hb_plugins` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `name` varchar(50) NOT NULL COMMENT '插件名，英文',
  `title` varchar(50) NOT NULL DEFAULT '' COMMENT '插件名称',
  `description` text COMMENT '插件描述',
  `type` tinyint(2) DEFAULT '0' COMMENT '插件类型, 1:网站；8;微信',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '状态；1开启；',
  `config` text COMMENT '插件配置',
  `hooks` varchar(255) DEFAULT NULL COMMENT '实现的钩子;以“，”分隔',
  `has_admin` tinyint(2) DEFAULT '0' COMMENT '插件是否有后台管理界面',
  `author` varchar(50) DEFAULT '' COMMENT '插件作者',
  `version` varchar(20) DEFAULT '' COMMENT '插件版本号',
  `createtime` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '插件安装时间',
  `listorder` smallint(6) NOT NULL DEFAULT '0' COMMENT '排序',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='插件表';

/*Data for the table `hb_plugins` */

/*Table structure for table `hb_posts` */

DROP TABLE IF EXISTS `hb_posts`;

CREATE TABLE `hb_posts` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `post_author` bigint(20) unsigned DEFAULT '0' COMMENT '发表者id',
  `post_keywords` varchar(150) NOT NULL COMMENT 'seo keywords',
  `post_source` varchar(150) DEFAULT NULL COMMENT '转载文章的来源',
  `post_date` datetime DEFAULT '2000-01-01 00:00:00' COMMENT 'post发布日期',
  `post_content` longtext COMMENT 'post内容',
  `post_title` text COMMENT 'post标题',
  `post_excerpt` text COMMENT 'post摘要',
  `post_status` int(2) DEFAULT '1' COMMENT 'post状态，1已审核，0未审核,3删除',
  `comment_status` int(2) DEFAULT '1' COMMENT '评论状态，1允许，0不允许',
  `post_modified` datetime DEFAULT '2000-01-01 00:00:00' COMMENT 'post更新时间，可在前台修改，显示给用户',
  `post_content_filtered` longtext,
  `post_parent` bigint(20) unsigned DEFAULT '0' COMMENT 'post的父级post id,表示post层级关系',
  `post_type` int(2) DEFAULT '1' COMMENT 'post类型，1文章,2页面',
  `post_mime_type` varchar(100) DEFAULT '',
  `comment_count` bigint(20) DEFAULT '0',
  `smeta` text COMMENT 'post的扩展字段，保存相关扩展属性，如缩略图；格式为json',
  `post_hits` int(11) DEFAULT '0' COMMENT 'post点击数，查看数',
  `post_like` int(11) DEFAULT '0' COMMENT 'post赞数',
  `istop` tinyint(1) NOT NULL DEFAULT '0' COMMENT '置顶 1置顶； 0不置顶',
  `recommended` tinyint(1) NOT NULL DEFAULT '0' COMMENT '推荐 1推荐 0不推荐',
  PRIMARY KEY (`id`),
  KEY `type_status_date` (`post_type`,`post_status`,`post_date`,`id`) USING BTREE,
  KEY `post_parent` (`post_parent`) USING BTREE,
  KEY `post_author` (`post_author`) USING BTREE,
  KEY `post_date` (`post_date`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COMMENT='Portal文章表';

/*Data for the table `hb_posts` */

insert  into `hb_posts`(`id`,`post_author`,`post_keywords`,`post_source`,`post_date`,`post_content`,`post_title`,`post_excerpt`,`post_status`,`comment_status`,`post_modified`,`post_content_filtered`,`post_parent`,`post_type`,`post_mime_type`,`comment_count`,`smeta`,`post_hits`,`post_like`,`istop`,`recommended`) values (1,1,'发生的','范德萨','2017-10-14 16:14:46','<p>分萨法沙发沙发沙发</p>','范德萨范德萨',' 粉丝',1,1,'2017-10-27 18:25:12',NULL,0,1,'',0,'{\"thumb\":\"portal\\/20171014\\/59e1c7ddd716a.jpg\",\"template\":\"\",\"photo\":[{\"url\":\"http:\\/\\/192.168.1.200:8001\\/envelop\\/data\\/upload\\/portal\\/20171014\\/59e1c7cc430a0.jpg\",\"alt\":\"zlgc (1).jpg\"}]}',0,0,0,0);

/*Table structure for table `hb_reuncash_log` */

DROP TABLE IF EXISTS `hb_reuncash_log`;

CREATE TABLE `hb_reuncash_log` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `pay_type` char(1) NOT NULL DEFAULT '1' COMMENT '支付类型 1微信支付',
  `transaction_id` varchar(32) CHARACTER SET utf8mb4 NOT NULL DEFAULT '' COMMENT '微信商户订单',
  `status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '0：正常 1:退款成功 2：退款失败',
  `desc` varchar(255) NOT NULL DEFAULT '' COMMENT '简述',
  `action` varchar(150) DEFAULT '' COMMENT '来源',
  `content` varchar(1000) NOT NULL DEFAULT '' COMMENT 'log具体内容',
  `add_time` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=14 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

/*Data for the table `hb_reuncash_log` */

insert  into `hb_reuncash_log`(`id`,`pay_type`,`transaction_id`,`status`,`desc`,`action`,`content`,`add_time`) values (1,'1','4200000011201712186544321509',0,'红包未领完退款','/adv_envelop/index.php/Api/Refund/index','{\"id\":\"1\",\"quest\":\"\\u4e13\\u4e1a\\u5b9a\\u5236\\u5c0f\\u7a0b\\u5e8f\",\"quest_py\":\"zhuanyedingzhixiaocheng\",\"answer\":\"\",\"answer_py\":\"\",\"user_id\":\"1\",\"openid\":\"oDLoC0ftXVS9oOtyNDJnW2ZbxAJg\",\"user_name\":\"\\u9648\\u5efa\\u519b@\\u667a\\u6c47\\u4e91\\u8054\\u5408\\u521b\\u59cb\\u4eba\",\"pay_type\":\"1\",\"show_amount\":\"3.00\",\"amount\":\"1.00\",\"commission\":\"0.00\",\"pay_status\":\"ok\",\"nonce_str\":\"\",\"out_trade_no\":\"H2017121823534936514218\",\"transaction_id\":\"4200000011201712186544321509\",\"num\":\"3\",\"form_id\":\"62c7c61b916abd8eb781b24906e0941c\",\"prepay_id\":\"wx20171218235350ad478d95570130555060\",\"receive_num\":\"2\",\"be_overdue\":\"0\",\"add_time\":\"1513612429\",\"update_time\":\"1513652780\",\"enve_type\":\"0\",\"is_adv\":\"1\",\"adv_url\":\"\\/data\\/upload\\/adv\\/20171218\\/5a37e48c341ab.jpg\",\"voice_url\":null,\"share2square\":\"0\",\"voice_dura\":null,\"video_url\":\"\",\"adv_text\":\"\"}',1513863001),(2,'1','4200000010201712186816451870',0,'红包未领完退款','/adv_envelop/index.php/Api/Refund/index','{\"id\":\"2\",\"quest\":\"\",\"quest_py\":\"\",\"answer\":\"\\u670d\\u52a1\\u5b97\\u65e8\",\"answer_py\":\"fuwuzongzhi\",\"user_id\":\"2\",\"openid\":\"oDLoC0b_oNYIRsRH5gyTGM9c0-5Q\",\"user_name\":\"\\u7eff\\u95f4\",\"pay_type\":\"1\",\"show_amount\":\"1.00\",\"amount\":\"1.00\",\"commission\":\"0.00\",\"pay_status\":\"ok\",\"nonce_str\":\"\",\"out_trade_no\":\"H2017121823580298030373\",\"transaction_id\":\"4200000010201712186816451870\",\"num\":\"1\",\"form_id\":\"3107a700ff689e571502d1e6da97c2e5\",\"prepay_id\":\"wx20171218235803bb8075cf5e0875495148\",\"receive_num\":\"0\",\"be_overdue\":\"0\",\"add_time\":\"1513612682\",\"update_time\":\"1513612693\",\"enve_type\":\"2\",\"is_adv\":\"1\",\"adv_url\":\"\\/data\\/upload\\/adv\\/20171218\\/5a37e5548d2f9.jpg\",\"voice_url\":\"\\/data\\/upload\\/default\\/20171218\\/5a37e58a9e31f.silk\",\"share2square\":\"1\",\"voice_dura\":\"4699\",\"video_url\":\"\\/data\\/upload\\/adv\\/20171218\\/5a37e55bd5b9d.mp4\",\"adv_text\":\"\\u795d\\u798f\"}',1513863003),(3,'2','',0,'红包未领完退款','/adv_envelop/index.php/Api/Refund/index','{\"id\":\"16\",\"quest\":\"\",\"quest_py\":\"\",\"answer\":\"\\u4f60\\u597d\",\"answer_py\":\"nihao\",\"user_id\":\"12\",\"openid\":\"oDLoC0SSBIV6t8npZfj2g9G3GQu0\",\"user_name\":\"\\u307a\\u950b\\u5b50o\\u041e\",\"pay_type\":\"2\",\"show_amount\":\"1.00\",\"amount\":\"1.00\",\"commission\":\"0.00\",\"pay_status\":\"ok\",\"nonce_str\":\"\",\"out_trade_no\":\"H2017121920083295609295\",\"transaction_id\":\"\",\"num\":\"1\",\"form_id\":\"9335f4099e29ee6b34d688b891c53501\",\"prepay_id\":\"\",\"receive_num\":\"0\",\"be_overdue\":\"0\",\"add_time\":\"1513685312\",\"update_time\":\"0\",\"enve_type\":\"2\",\"is_adv\":\"0\",\"adv_url\":null,\"voice_url\":\"\\/data\\/upload\\/default\\/20171219\\/5a3901407d4e4.silk\",\"share2square\":\"1\",\"voice_dura\":\"5236\",\"video_url\":null,\"adv_text\":null}',1513863004),(4,'1','4200000022201712197461536425',0,'红包未领完退款','/adv_envelop/index.php/Api/Refund/index','{\"id\":\"24\",\"quest\":\"\",\"quest_py\":\"\",\"answer\":\"\\u554a\\u554a\",\"answer_py\":\"aa\",\"user_id\":\"2\",\"openid\":\"oDLoC0b_oNYIRsRH5gyTGM9c0-5Q\",\"user_name\":\"\\u7eff\\u95f4\",\"pay_type\":\"1\",\"show_amount\":\"2.00\",\"amount\":\"2.00\",\"commission\":\"0.00\",\"pay_status\":\"ok\",\"nonce_str\":\"\",\"out_trade_no\":\"H2017121923264274117784\",\"transaction_id\":\"4200000022201712197461536425\",\"num\":\"2\",\"form_id\":\"9051493447c23d2e50b858e432aebd55\",\"prepay_id\":\"wx201712192326437e2bd860770583826067\",\"receive_num\":\"0\",\"be_overdue\":\"0\",\"add_time\":\"1513697202\",\"update_time\":\"1513697208\",\"enve_type\":\"2\",\"is_adv\":\"1\",\"adv_url\":\"\",\"voice_url\":\"\\/data\\/upload\\/default\\/20171219\\/5a392fb297a43.silk\",\"share2square\":\"1\",\"voice_dura\":\"7293\",\"video_url\":\"\\/data\\/upload\\/adv\\/20171219\\/5a392f97181c5.mp4\",\"adv_text\":\"????\\u7b54\\u6848\\u5728\\u89c6\\u9891\\u91cc\"}',1513863005),(5,'1','4200000020201712197425861984',0,'红包未领完退款','/adv_envelop/index.php/Api/Refund/index','{\"id\":\"27\",\"quest\":\"\",\"quest_py\":\"\",\"answer\":\"\\u6ca1\\u6709\",\"answer_py\":\"meiyou\",\"user_id\":\"13\",\"openid\":\"oDLoC0cKVFSV14Eye-kz1WiHFRAk\",\"user_name\":\"\\u77e5\\u4e86\\uff0c\\u201c\\u77e5\\u4e86\\u201d\",\"pay_type\":\"1\",\"show_amount\":\"1.00\",\"amount\":\"1.00\",\"commission\":\"0.00\",\"pay_status\":\"ok\",\"nonce_str\":\"\",\"out_trade_no\":\"H2017121923293952873111\",\"transaction_id\":\"4200000020201712197425861984\",\"num\":\"1\",\"form_id\":\"8fe2218476a43b2361a9309d434ff6a5\",\"prepay_id\":\"wx201712192329408741ecc0e10678177899\",\"receive_num\":\"0\",\"be_overdue\":\"0\",\"add_time\":\"1513697379\",\"update_time\":\"1513697385\",\"enve_type\":\"2\",\"is_adv\":\"0\",\"adv_url\":null,\"voice_url\":\"\\/data\\/upload\\/default\\/20171219\\/5a393063bd2c1.silk\",\"share2square\":\"0\",\"voice_dura\":\"7277\",\"video_url\":null,\"adv_text\":null}',1513863005),(6,'1','4200000029201712207930969780',0,'红包未领完退款','/adv_envelop/index.php/Api/Refund/index','{\"id\":\"56\",\"quest\":\"\\u667a\\u6c47\\u4e91\",\"quest_py\":\"zhihuiyun\",\"answer\":\"\",\"answer_py\":\"\",\"user_id\":\"4\",\"openid\":\"oDLoC0eqTuhTbuoM3O3CqkAJgek0\",\"user_name\":\"Mr.\\u6d9b\\u6d9b\\u6d9b\",\"pay_type\":\"1\",\"show_amount\":\"3.00\",\"amount\":\"1.00\",\"commission\":\"0.00\",\"pay_status\":\"ok\",\"nonce_str\":\"\",\"out_trade_no\":\"H2017122017344327748958\",\"transaction_id\":\"4200000029201712207930969780\",\"num\":\"6\",\"form_id\":\"1513762484053\",\"prepay_id\":\"wx201712201734432f3e9646aa0175701758\",\"receive_num\":\"4\",\"be_overdue\":\"0\",\"add_time\":\"1513762483\",\"update_time\":\"1513763413\",\"enve_type\":\"0\",\"is_adv\":\"1\",\"adv_url\":\"\\/data\\/upload\\/adv\\/20171220\\/5a3a2ea2d0572.jpg\",\"voice_url\":null,\"share2square\":\"1\",\"voice_dura\":null,\"video_url\":\"\",\"adv_text\":\"\"}',1513863006),(7,'2','',0,'红包未领完退款','/adv_envelop/index.php/Api/Refund/index','{\"id\":\"62\",\"quest\":\"\",\"quest_py\":\"\",\"answer\":\"\",\"answer_py\":\"\",\"user_id\":\"3\",\"openid\":\"oDLoC0R38XmhPWGhKMACtESUDf8U\",\"user_name\":\"\\u4e1c\\u534e\",\"pay_type\":\"2\",\"show_amount\":\"1.00\",\"amount\":\"0.50\",\"commission\":\"0.00\",\"pay_status\":\"ok\",\"nonce_str\":\"\",\"out_trade_no\":\"H2017122111342835720129\",\"transaction_id\":\"\",\"num\":\"2\",\"form_id\":\"1513827266590\",\"prepay_id\":\"\",\"receive_num\":\"1\",\"be_overdue\":\"0\",\"add_time\":\"1513827268\",\"update_time\":\"1513827286\",\"enve_type\":\"1\",\"is_adv\":\"0\",\"adv_url\":null,\"voice_url\":\"\\/data\\/upload\\/default\\/20171221\\/5a3b2bc4229dd.silk\",\"share2square\":\"0\",\"voice_dura\":\"4475\",\"video_url\":null,\"adv_text\":null}',1513913761),(8,'1','4200000019201712228836268478',0,'红包未领完退款','/adv_envelop/index.php/Api/Refund/index','{\"id\":\"64\",\"quest\":\"\\u4ebf\\u7fc1\\u4f20\\u5a92\",\"quest_py\":\"yiwengchuanmei\",\"answer\":\"\",\"answer_py\":\"\",\"user_id\":\"28\",\"openid\":\"oDLoC0eWzPbeY4y9dmB471B1Ct5A\",\"user_name\":\"\\u51ac\\u5b50\",\"pay_type\":\"1\",\"show_amount\":\"1.00\",\"amount\":\"1.00\",\"commission\":\"0.00\",\"pay_status\":\"ok\",\"nonce_str\":\"\",\"out_trade_no\":\"H2017122211251343255204\",\"transaction_id\":\"4200000019201712228836268478\",\"num\":\"2\",\"form_id\":\"1513913112909\",\"prepay_id\":\"wx201712221125144338b9cb7d0899341472\",\"receive_num\":\"0\",\"be_overdue\":\"0\",\"add_time\":\"1513913113\",\"update_time\":\"1513913121\",\"enve_type\":\"0\",\"is_adv\":\"0\",\"adv_url\":null,\"voice_url\":null,\"share2square\":\"0\",\"voice_dura\":null,\"video_url\":null,\"adv_text\":null}',1513999561),(9,'1','4200000023201712239818239813',0,'红包未领完退款','/adv_envelop/index.php/Api/Refund/index','{\"id\":\"66\",\"quest\":\"\\u5341\\u5206\\u4f18\\u79c0\",\"quest_py\":\"shifenyouxiu\",\"answer\":\"\",\"answer_py\":\"\",\"user_id\":\"5\",\"openid\":\"oDLoC0U0LtP1xlHJfaPkpJ3gqajA\",\"user_name\":\"\\u5c11\\u5e74\\u7248\",\"pay_type\":\"1\",\"show_amount\":\"1.00\",\"amount\":\"1.00\",\"commission\":\"0.00\",\"pay_status\":\"ok\",\"nonce_str\":\"\",\"out_trade_no\":\"H2017122316215883904630\",\"transaction_id\":\"4200000023201712239818239813\",\"num\":\"1\",\"form_id\":\"a5b170acde214099ebc3006e046c5d0c\",\"prepay_id\":\"wx201712231621595cab6181e40649581040\",\"receive_num\":\"0\",\"be_overdue\":\"0\",\"add_time\":\"1514017318\",\"update_time\":\"1514017325\",\"enve_type\":\"0\",\"is_adv\":\"0\",\"adv_url\":null,\"voice_url\":null,\"share2square\":\"0\",\"voice_dura\":null,\"video_url\":null,\"adv_text\":null}',1514103722),(10,'1','4200000007201712250839611347',0,'红包未领完退款','/adv_envelop/index.php/Api/Refund/index','{\"id\":\"68\",\"quest\":\"\\u6b22\\u8fce\\u5927\\u5bb6\\u9886\\u53d6\\u5956\\u54c1\",\"quest_py\":\"huanyingdajialingqujiang\",\"answer\":\"\",\"answer_py\":\"\",\"user_id\":\"5\",\"openid\":\"oDLoC0U0LtP1xlHJfaPkpJ3gqajA\",\"user_name\":\"\\u5c11\\u5e74\\u7248\",\"pay_type\":\"1\",\"show_amount\":\"1.00\",\"amount\":\"1.00\",\"commission\":\"0.00\",\"pay_status\":\"ok\",\"nonce_str\":\"\",\"out_trade_no\":\"H2017122500455074555059\",\"transaction_id\":\"4200000007201712250839611347\",\"num\":\"1\",\"form_id\":\"249a19fa43a6e0f5f0fe25906d5ea9ae\",\"prepay_id\":\"wx2017122500455188e92529ff0639577020\",\"receive_num\":\"0\",\"be_overdue\":\"0\",\"add_time\":\"1514133950\",\"update_time\":\"1514133957\",\"enve_type\":\"0\",\"is_adv\":\"0\",\"adv_url\":null,\"voice_url\":null,\"share2square\":\"0\",\"voice_dura\":null,\"video_url\":null,\"adv_text\":null}',1514220361),(11,'2','',0,'红包未领完退款','/adv_envelop/index.php/Api/Refund/index','{\"id\":\"69\",\"quest\":\"\\u6cd5\\u5b9d\",\"quest_py\":\"fabao\",\"answer\":\"\",\"answer_py\":\"\",\"user_id\":\"3\",\"openid\":\"oDLoC0R38XmhPWGhKMACtESUDf8U\",\"user_name\":\"\\u4e1c\\u534e\",\"pay_type\":\"2\",\"show_amount\":\"1.00\",\"amount\":\"0.50\",\"commission\":\"0.00\",\"pay_status\":\"ok\",\"nonce_str\":\"\",\"out_trade_no\":\"H2017122518503294431797\",\"transaction_id\":\"\",\"num\":\"2\",\"form_id\":\"1514199030290\",\"prepay_id\":\"\",\"receive_num\":\"1\",\"be_overdue\":\"0\",\"add_time\":\"1514199032\",\"update_time\":\"1514199133\",\"enve_type\":\"0\",\"is_adv\":\"0\",\"adv_url\":null,\"voice_url\":null,\"share2square\":\"0\",\"voice_dura\":null,\"video_url\":null,\"adv_text\":null,\"del\":\"0\"}',1514285521),(12,'2','',0,'红包未领完退款','/adv_envelop/index.php/Api/Refund/index','{\"id\":\"75\",\"quest\":\"\\u4e09\\u5927\",\"quest_py\":\"sanda\",\"answer\":\"\",\"answer_py\":\"\",\"user_id\":\"3\",\"openid\":\"oDLoC0R38XmhPWGhKMACtESUDf8U\",\"user_name\":\"\\u4e1c\\u534e\",\"pay_type\":\"2\",\"show_amount\":\"1.00\",\"amount\":\"1.00\",\"commission\":\"0.00\",\"pay_status\":\"ok\",\"nonce_str\":\"\",\"out_trade_no\":\"H2017122615420364674606\",\"transaction_id\":\"\",\"num\":\"1\",\"form_id\":\"the formId is a mock one\",\"prepay_id\":\"\",\"receive_num\":\"0\",\"be_overdue\":\"0\",\"add_time\":\"1514274123\",\"update_time\":\"0\",\"enve_type\":\"0\",\"is_adv\":\"0\",\"adv_url\":null,\"voice_url\":null,\"share2square\":\"0\",\"voice_dura\":null,\"video_url\":null,\"adv_text\":null,\"del\":\"0\"}',1514360642),(13,'2','',0,'红包未领完退款','/adv_envelop/index.php/Api/Refund/index','{\"id\":\"77\",\"quest\":\"\\u533f\\u540d\",\"quest_py\":\"niming\",\"answer\":\"\",\"answer_py\":\"\",\"user_id\":\"7\",\"openid\":\"oDLoC0RTQTZ22GcKQpk8-5Vy_svA\",\"user_name\":\"YUAN\",\"pay_type\":\"2\",\"show_amount\":\"1.00\",\"amount\":\"1.00\",\"commission\":\"0.00\",\"pay_status\":\"ok\",\"nonce_str\":\"\",\"out_trade_no\":\"H2017122615445310238662\",\"transaction_id\":\"\",\"num\":\"1\",\"form_id\":\"1514274292980\",\"prepay_id\":\"\",\"receive_num\":\"0\",\"be_overdue\":\"0\",\"add_time\":\"1514274293\",\"update_time\":\"0\",\"enve_type\":\"0\",\"is_adv\":\"0\",\"adv_url\":null,\"voice_url\":null,\"share2square\":\"1\",\"voice_dura\":null,\"video_url\":null,\"adv_text\":null,\"del\":\"0\"}',1514360762);

/*Table structure for table `hb_role` */

DROP TABLE IF EXISTS `hb_role`;

CREATE TABLE `hb_role` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(20) NOT NULL COMMENT '角色名称',
  `pid` smallint(6) DEFAULT NULL COMMENT '父角色ID',
  `status` tinyint(1) unsigned DEFAULT NULL COMMENT '状态',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `create_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  `listorder` int(3) NOT NULL DEFAULT '0' COMMENT '排序字段',
  PRIMARY KEY (`id`),
  KEY `parentId` (`pid`) USING BTREE,
  KEY `status` (`status`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=8 DEFAULT CHARSET=utf8 COMMENT='角色表';

/*Data for the table `hb_role` */

insert  into `hb_role`(`id`,`name`,`pid`,`status`,`remark`,`create_time`,`update_time`,`listorder`) values (6,'index',NULL,1,'index',1507794296,0,0);

/*Table structure for table `hb_role_user` */

DROP TABLE IF EXISTS `hb_role_user`;

CREATE TABLE `hb_role_user` (
  `role_id` int(11) unsigned DEFAULT '0' COMMENT '角色 id',
  `user_id` int(11) DEFAULT '0' COMMENT '用户id',
  KEY `group_id` (`role_id`) USING BTREE,
  KEY `user_id` (`user_id`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='用户角色对应表';

/*Data for the table `hb_role_user` */

/*Table structure for table `hb_route` */

DROP TABLE IF EXISTS `hb_route`;

CREATE TABLE `hb_route` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '路由id',
  `full_url` varchar(255) DEFAULT NULL COMMENT '完整url， 如：portal/list/index?id=1',
  `url` varchar(255) DEFAULT NULL COMMENT '实际显示的url',
  `listorder` int(5) DEFAULT '0' COMMENT '排序，优先级，越小优先级越高',
  `status` tinyint(1) DEFAULT '1' COMMENT '状态，1：启用 ;0：不启用',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='url路由表';

/*Data for the table `hb_route` */

/*Table structure for table `hb_settings` */

DROP TABLE IF EXISTS `hb_settings`;

CREATE TABLE `hb_settings` (
  `key` varchar(20) NOT NULL,
  `value` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`key`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `hb_settings` */

/*Table structure for table `hb_share_pic` */

DROP TABLE IF EXISTS `hb_share_pic`;

CREATE TABLE `hb_share_pic` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pid` int(11) DEFAULT NULL COMMENT '红包id',
  `purl` varchar(255) DEFAULT NULL COMMENT '红包图片路径',
  `createtime` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `hb_share_pic` */

/*Table structure for table `hb_slide` */

DROP TABLE IF EXISTS `hb_slide`;

CREATE TABLE `hb_slide` (
  `slide_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `slide_cid` int(11) NOT NULL COMMENT '幻灯片分类 id',
  `slide_name` varchar(255) NOT NULL COMMENT '幻灯片名称',
  `slide_pic` varchar(255) DEFAULT NULL COMMENT '幻灯片图片',
  `slide_url` varchar(255) DEFAULT NULL COMMENT '幻灯片链接',
  `slide_des` varchar(255) DEFAULT NULL COMMENT '幻灯片描述',
  `slide_content` text COMMENT '幻灯片内容',
  `slide_status` int(2) NOT NULL DEFAULT '1' COMMENT '状态，1显示，0不显示',
  `listorder` int(10) DEFAULT '0' COMMENT '排序',
  PRIMARY KEY (`slide_id`),
  KEY `slide_cid` (`slide_cid`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=12 DEFAULT CHARSET=utf8 COMMENT='幻灯片表';

/*Data for the table `hb_slide` */

insert  into `hb_slide`(`slide_id`,`slide_cid`,`slide_name`,`slide_pic`,`slide_url`,`slide_des`,`slide_content`,`slide_status`,`listorder`) values (1,1,'first','admin/20171215/5a3372420a1ad.jpg','','','',1,0),(2,1,'second','admin/20171213/5a30e8f8a1b8b.png','www.sina.com','','',1,0),(3,1,'third','admin/20171213/5a30e939a63cc.jpg','www.sina.com','','',1,0),(4,2,'我收到的','admin/20171218/5a379687ecfa8.png','www.baidu.com','','',1,0),(5,3,'我发出的','admin/20171218/5a37969d4ef41.png','','','',1,0),(6,4,'领取页面','admin/20171218/5a3796af655f7.png','','','',1,0),(7,5,'分享页面','admin/20171218/5a3796c0b48d3.png','','','',1,0),(8,6,'广场','admin/20171218/5a3796d021bd6.png','','','',1,0),(9,7,'提现','admin/20171218/5a3796df2fd21.png','','','',1,0),(10,8,'常见问题','admin/20171218/5a3796efc5825.png','','','',1,0),(11,9,'个人中心','admin/20171220/5a39ddde6db62.png','www.baidu.com','','',1,0);

/*Table structure for table `hb_slide_cat` */

DROP TABLE IF EXISTS `hb_slide_cat`;

CREATE TABLE `hb_slide_cat` (
  `cid` int(11) NOT NULL AUTO_INCREMENT,
  `cat_name` varchar(255) NOT NULL COMMENT '幻灯片分类',
  `cat_idname` varchar(255) NOT NULL COMMENT '幻灯片分类标识',
  `cat_remark` text COMMENT '分类备注',
  `cat_status` int(2) NOT NULL DEFAULT '1' COMMENT '状态，1显示，0不显示',
  PRIMARY KEY (`cid`),
  KEY `cat_idname` (`cat_idname`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=10 DEFAULT CHARSET=utf8 COMMENT='幻灯片分类表';

/*Data for the table `hb_slide_cat` */

insert  into `hb_slide_cat`(`cid`,`cat_name`,`cat_idname`,`cat_remark`,`cat_status`) values (1,'首页三张','index3','',1),(2,'我收到的','myrecive','',1),(3,'我发出的','mysend','',1),(4,'红包领取页','hbdetail','',1),(5,'分享页面','share','',1),(6,'红包广场','hbsquare','',1),(7,'提现页面','withdrawal','',1),(8,'余额提现','cquestion','',1),(9,'个人中心','user_center','',1);

/*Table structure for table `hb_term_relationships` */

DROP TABLE IF EXISTS `hb_term_relationships`;

CREATE TABLE `hb_term_relationships` (
  `tid` bigint(20) NOT NULL AUTO_INCREMENT,
  `object_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT 'posts表里文章id',
  `term_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '分类id',
  `listorder` int(10) NOT NULL DEFAULT '0' COMMENT '排序',
  `status` int(2) NOT NULL DEFAULT '1' COMMENT '状态，1发布，0不发布',
  PRIMARY KEY (`tid`),
  KEY `term_taxonomy_id` (`term_id`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COMMENT='Portal 文章分类对应表';

/*Data for the table `hb_term_relationships` */

insert  into `hb_term_relationships`(`tid`,`object_id`,`term_id`,`listorder`,`status`) values (1,1,3,0,1);

/*Table structure for table `hb_terms` */

DROP TABLE IF EXISTS `hb_terms`;

CREATE TABLE `hb_terms` (
  `term_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '分类id',
  `name` varchar(200) DEFAULT NULL COMMENT '分类名称',
  `slug` varchar(200) DEFAULT '',
  `taxonomy` varchar(32) DEFAULT NULL COMMENT '分类类型',
  `description` longtext COMMENT '分类描述',
  `parent` bigint(20) unsigned DEFAULT '0' COMMENT '分类父id',
  `count` bigint(20) DEFAULT '0' COMMENT '分类文章数',
  `path` varchar(500) DEFAULT NULL COMMENT '分类层级关系路径',
  `seo_title` varchar(500) DEFAULT NULL,
  `seo_keywords` varchar(500) DEFAULT NULL,
  `seo_description` varchar(500) DEFAULT NULL,
  `list_tpl` varchar(50) DEFAULT NULL COMMENT '分类列表模板',
  `one_tpl` varchar(50) DEFAULT NULL COMMENT '分类文章页模板',
  `listorder` int(5) NOT NULL DEFAULT '0' COMMENT '排序',
  `status` int(2) NOT NULL DEFAULT '1' COMMENT '状态，1发布，0不发布',
  PRIMARY KEY (`term_id`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COMMENT='Portal 文章分类表';

/*Data for the table `hb_terms` */

insert  into `hb_terms`(`term_id`,`name`,`slug`,`taxonomy`,`description`,`parent`,`count`,`path`,`seo_title`,`seo_keywords`,`seo_description`,`list_tpl`,`one_tpl`,`listorder`,`status`) values (3,'测试文章','','article','范德萨',0,0,'0-3','','','','list','article',0,1);

/*Table structure for table `hb_theme` */

DROP TABLE IF EXISTS `hb_theme`;

CREATE TABLE `hb_theme` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `type` tinyint(1) NOT NULL DEFAULT '1' COMMENT '1王者  2搞怪 3中秋国庆',
  `quest` varchar(255) NOT NULL DEFAULT '' COMMENT '问题',
  `answer` varchar(255) NOT NULL DEFAULT '' COMMENT '答案',
  `difficult` char(10) NOT NULL DEFAULT '1' COMMENT '难度 0-100%',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;

/*Data for the table `hb_theme` */

insert  into `hb_theme`(`id`,`type`,`quest`,`answer`,`difficult`) values (1,1,'叫爸爸','儿子','1');

/*Table structure for table `hb_upload` */

DROP TABLE IF EXISTS `hb_upload`;

CREATE TABLE `hb_upload` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `src` varchar(255) DEFAULT '' COMMENT '语音路径',
  `user_id` int(11) DEFAULT '0',
  `openid` varchar(35) DEFAULT '' COMMENT '微信小程序或者公共号openid',
  `add_time` int(10) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=92 DEFAULT CHARSET=utf8mb4;

/*Data for the table `hb_upload` */

insert  into `hb_upload`(`id`,`src`,`user_id`,`openid`,`add_time`) values (1,'/data/upload/adv/20171228/5a447d08b6629.jpg',0,'',1514437896),(2,'/data/upload/adv/20171228/5a447d1fc9a6f.jpg',0,'',1514437919),(3,'/data/upload/default/20171228/5a447d71ce68b.silk',0,'',1514438001),(4,'/data/upload/default/20171228/5a447db0456ee.silk',0,'',1514438064),(5,'/data/upload/default/20171228/5a447dc6a11ac.silk',0,'',1514438086),(6,'/data/upload/default/20171228/5a447dcc24903.silk',0,'',1514438092),(7,'/data/upload/default/20171228/5a447dcf68733.silk',0,'',1514438095),(8,'/data/upload/default/20171228/5a447df03fd2c.silk',0,'',1514438128),(9,'/data/upload/default/20171228/5a447e0468bc5.silk',0,'',1514438148),(10,'/data/upload/default/20171228/5a447e5c63663.silk',0,'',1514438236),(11,'/data/upload/adv/20171228/5a447f86a6172.jpg',0,'',1514438534),(12,'/data/upload/adv/20171228/5a447f942364a.mp4',0,'',1514438548),(13,'/data/upload/default/20171228/5a447fbf080ac.silk',0,'',1514438591),(14,'/data/upload/default/20171228/5a44895867248.silk',0,'',1514441048),(15,'/data/upload/default/20171228/5a448a664e8f7.silk',0,'',1514441318),(16,'/data/upload/default/20171228/5a448c0f29d54.silk',0,'',1514441743),(17,'/data/upload/default/20171228/5a448c20314b2.silk',0,'',1514441760),(18,'/data/upload/default/20171228/5a448c6976db0.silk',0,'',1514441833),(19,'/data/upload/adv/20171228/5a448ef36aadd.jpg',0,'',1514442483),(20,'/data/upload/adv/20171228/5a448f0b0ebc2.jpg',0,'',1514442507),(21,'/data/upload/adv/20171228/5a448f14d22ee.mp4',0,'',1514442516),(22,'/data/upload/default/20171228/5a448f7c07aac.silk',0,'',1514442620),(23,'/data/upload/default/20171228/5a4490073b08e.silk',0,'',1514442759),(24,'/data/upload/default/20171228/5a449216b9d25.silk',0,'',1514443286),(25,'/data/upload/adv/20171228/5a4493119c17f.jpg',0,'',1514443537),(26,'/data/upload/adv/20171228/5a44931b2c636.mp4',0,'',1514443547),(27,'/data/upload/default/20171228/5a44932940bfa.silk',0,'',1514443561),(28,'/data/upload/adv/20171228/5a44942e3a743.jpg',0,'',1514443822),(29,'/data/upload/adv/20171228/5a449445f3bac.jpg',0,'',1514443845),(30,'/data/upload/adv/20171228/5a44944d0ae73.mp4',0,'',1514443853),(31,'/data/upload/default/20171228/5a4494555f375.silk',0,'',1514443861),(32,'/data/upload/default/20171228/5a44951cced46.silk',0,'',1514444060),(33,'/data/upload/default/20171228/5a44954e2af31.silk',0,'',1514444110),(34,'/data/upload/adv/20171228/5a4496012363c.jpg',0,'',1514444289),(35,'/data/upload/default/20171228/5a44964e769f1.silk',0,'',1514444366),(36,'/data/upload/default/20171228/5a44964f83f8a.silk',0,'',1514444367),(37,'/data/upload/default/20171228/5a449650be469.silk',0,'',1514444368),(38,'/data/upload/default/20171228/5a44965513422.silk',0,'',1514444373),(39,'/data/upload/default/20171228/5a4496584e6a9.silk',0,'',1514444376),(40,'/data/upload/default/20171228/5a449660bd32d.silk',0,'',1514444384),(41,'/data/upload/default/20171228/5a449661b7441.silk',0,'',1514444385),(42,'/data/upload/default/20171228/5a449661f1016.silk',0,'',1514444385),(43,'/data/upload/default/20171228/5a4496622724b.silk',0,'',1514444386),(44,'/data/upload/default/20171228/5a44966233fb2.silk',0,'',1514444386),(45,'/data/upload/default/20171228/5a4496624bbba.silk',0,'',1514444386),(46,'/data/upload/default/20171228/5a449663ba1a2.silk',0,'',1514444387),(47,'/data/upload/default/20171228/5a44967190192.silk',0,'',1514444401),(48,'/data/upload/default/20171228/5a4496795b082.silk',0,'',1514444409),(49,'/data/upload/default/20171228/5a44969548001.silk',0,'',1514444437),(50,'/data/upload/default/20171228/5a44969c26c71.silk',0,'',1514444444),(51,'/data/upload/default/20171228/5a4496a52dcb1.silk',0,'',1514444453),(52,'/data/upload/adv/20171228/5a44be28a9794.jpg',0,'',1514454568),(53,'/data/upload/default/20171228/5a44db4e7b2d4.silk',0,'',1514462030),(54,'/data/upload/default/20171228/5a44db7abd711.silk',0,'',1514462074),(55,'/data/upload/default/20171228/5a44dbab5380c.silk',0,'',1514462123),(56,'/data/upload/adv/20171228/5a44eb779b451.jpg',0,'',1514466167),(57,'/data/upload/adv/20171228/5a44eba13b301.jpg',0,'',1514466209),(58,'/data/upload/default/20171228/5a44ebf41f91e.silk',0,'',1514466292),(59,'/data/upload/default/20171228/5a44ec1cdea3e.silk',0,'',1514466332),(60,'/data/upload/default/20171228/5a44edd0631dd.silk',0,'',1514466768),(61,'/data/upload/default/20171228/5a44eef866a00.silk',0,'',1514467064),(62,'/data/upload/default/20171228/5a44f176bf940.silk',0,'',1514467702),(63,'/data/upload/default/20171228/5a44f26487242.silk',0,'',1514467940),(64,'/data/upload/default/20171228/5a44f358d09e0.silk',0,'',1514468184),(65,'/data/upload/default/20171228/5a44f882a70f4.silk',0,'',1514469506),(66,'/data/upload/default/20171228/5a44fb2396734.silk',0,'',1514470179),(67,'/data/upload/default/20171228/5a44fd476fd60.silk',0,'',1514470727),(68,'/data/upload/default/20171228/5a44fd6259c7c.silk',0,'',1514470754),(69,'/data/upload/default/20171228/5a44fdca82a95.silk',0,'',1514470858),(70,'/data/upload/default/20171228/5a44fe01ca664.silk',0,'',1514470913),(71,'/data/upload/adv/20171228/5a450dd23c126.jpg',0,'',1514474962),(72,'/data/upload/adv/20171228/5a450ddb32bb1.mp4',0,'',1514474971),(73,'/data/upload/default/20171228/5a450ddf1d8f4.silk',0,'',1514474975),(74,'/data/upload/default/20171229/5a451caea0d09.silk',0,'',1514478766),(75,'/data/upload/default/20171229/5a454d24c257b.silk',0,'',1514491172),(76,'/data/upload/default/20171229/5a454d32cb177.silk',0,'',1514491186),(77,'/data/upload/default/20171229/5a454dacdda8d.silk',0,'',1514491308),(78,'/data/upload/default/20171229/5a454e0ad8e53.silk',0,'',1514491402),(79,'/data/upload/default/20171229/5a454e44a70bd.silk',0,'',1514491460),(80,'/data/upload/default/20171229/5a454e5eb59bc.silk',0,'',1514491486),(81,'/data/upload/default/20171229/5a454e7220109.silk',0,'',1514491506),(82,'/data/upload/default/20171229/5a454e78e22b4.silk',0,'',1514491512),(83,'/data/upload/default/20171229/5a4578fbcf338.silk',0,'',1514502395),(84,'/data/upload/default/20171229/5a4579035c588.silk',0,'',1514502403),(85,'/data/upload/adv/20171229/5a458e99bf915.jpg',0,'',1514507929),(86,'/data/upload/adv/20171229/5a458f8cabb5b.jpg',0,'',1514508172),(87,'/data/upload/default/20171229/5a458fac0d0b9.silk',0,'',1514508204),(88,'/data/upload/default/20171229/5a458feb3d029.silk',0,'',1514508267),(89,'/data/upload/default/20171229/5a4590055d901.silk',0,'',1514508293),(90,'/data/upload/default/20171229/5a45900d2e0f7.silk',0,'',1514508301),(91,'/data/upload/default/20171229/5a45901e9439c.silk',0,'',1514508318);

/*Table structure for table `hb_user_favorites` */

DROP TABLE IF EXISTS `hb_user_favorites`;

CREATE TABLE `hb_user_favorites` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uid` bigint(20) DEFAULT NULL COMMENT '用户 id',
  `title` varchar(255) DEFAULT NULL COMMENT '收藏内容的标题',
  `url` varchar(255) DEFAULT NULL COMMENT '收藏内容的原文地址，不带域名',
  `description` varchar(500) DEFAULT NULL COMMENT '收藏内容的描述',
  `table` varchar(50) DEFAULT NULL COMMENT '收藏实体以前所在表，不带前缀',
  `object_id` int(11) DEFAULT NULL COMMENT '收藏内容原来的主键id',
  `createtime` int(11) DEFAULT NULL COMMENT '收藏时间',
  PRIMARY KEY (`id`),
  KEY `uid` (`uid`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='用户收藏表';

/*Data for the table `hb_user_favorites` */

/*Table structure for table `hb_users` */

DROP TABLE IF EXISTS `hb_users`;

CREATE TABLE `hb_users` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_login` varchar(60) NOT NULL DEFAULT '' COMMENT '用户名',
  `user_pass` varchar(64) NOT NULL DEFAULT '' COMMENT '登录密码；sp_password加密',
  `user_nicename` varchar(50) NOT NULL DEFAULT '' COMMENT '用户美名',
  `user_email` varchar(100) NOT NULL DEFAULT '' COMMENT '登录邮箱',
  `user_url` varchar(100) NOT NULL DEFAULT '' COMMENT '用户个人网站',
  `avatar` varchar(255) DEFAULT NULL COMMENT '用户头像，相对于upload/avatar目录',
  `sex` smallint(1) DEFAULT '0' COMMENT '性别；0：保密，1：男；2：女',
  `birthday` date DEFAULT '2000-01-01' COMMENT '生日',
  `signature` varchar(255) DEFAULT NULL COMMENT '个性签名',
  `last_login_ip` varchar(16) DEFAULT NULL COMMENT '最后登录ip',
  `last_login_time` datetime NOT NULL DEFAULT '2000-01-01 00:00:00' COMMENT '最后登录时间',
  `create_time` datetime NOT NULL DEFAULT '2000-01-01 00:00:00' COMMENT '注册时间',
  `user_activation_key` varchar(60) NOT NULL DEFAULT '' COMMENT '激活码',
  `user_status` int(11) NOT NULL DEFAULT '1' COMMENT '用户状态 0：禁用； 1：正常 ；2：未验证',
  `score` int(11) NOT NULL DEFAULT '0' COMMENT '用户积分',
  `user_type` smallint(1) DEFAULT '1' COMMENT '用户类型，1:admin ;2:会员',
  `coin` int(11) NOT NULL DEFAULT '0' COMMENT '金币',
  `mobile` varchar(20) NOT NULL DEFAULT '' COMMENT '手机号',
  PRIMARY KEY (`id`),
  KEY `user_login_key` (`user_login`) USING BTREE,
  KEY `user_nicename` (`user_nicename`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COMMENT='用户表';

/*Data for the table `hb_users` */

insert  into `hb_users`(`id`,`user_login`,`user_pass`,`user_nicename`,`user_email`,`user_url`,`avatar`,`sex`,`birthday`,`signature`,`last_login_ip`,`last_login_time`,`create_time`,`user_activation_key`,`user_status`,`score`,`user_type`,`coin`,`mobile`) values (1,'admin','###58a8dc4ab845cc58941effd38f24079c','测试','','',NULL,0,'2000-01-01','','113.65.28.141','2017-12-29 04:18:23','2000-01-01 00:00:00','',1,0,1,0,'');

/*Table structure for table `hb_withdrawals` */

DROP TABLE IF EXISTS `hb_withdrawals`;

CREATE TABLE `hb_withdrawals` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0' COMMENT '用户id',
  `amount` decimal(10,2) NOT NULL,
  `appid` varchar(100) DEFAULT '' COMMENT '公众号的APPID',
  `openid` varchar(100) DEFAULT '' COMMENT '提现用户openid',
  `repeat_openid` varchar(100) DEFAULT '' COMMENT '重复收款用户OpenID',
  `check_name` varchar(80) DEFAULT '' COMMENT '校验用户姓名选项',
  `re_user_name` varchar(150) DEFAULT '' COMMENT '真是姓名',
  `id_card` varchar(100) DEFAULT '' COMMENT '身份证号',
  `pay_desc` varchar(255) DEFAULT '' COMMENT '付款说明',
  `err_code_des` varchar(255) DEFAULT '' COMMENT '错误信息',
  `nonce_str` varchar(32) DEFAULT '' COMMENT '随机字符',
  `partner_trade_no` varchar(100) NOT NULL DEFAULT '' COMMENT '单号',
  `spbill_create_ip` varchar(255) DEFAULT NULL,
  `status` varchar(100) DEFAULT '' COMMENT '提款状态',
  `add_time` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

/*Data for the table `hb_withdrawals` */

/*Table structure for table `hb_wx_user` */

DROP TABLE IF EXISTS `hb_wx_user`;

CREATE TABLE `hb_wx_user` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `user_name` varchar(100) NOT NULL DEFAULT '' COMMENT '用户名',
  `head_img` varchar(255) NOT NULL DEFAULT '' COMMENT '头像',
  `nick_name` varchar(100) NOT NULL DEFAULT '',
  `amount` decimal(18,2) NOT NULL DEFAULT '0.00' COMMENT '余额',
  `frozen_amount` decimal(18,2) NOT NULL DEFAULT '0.00' COMMENT '冻结余额',
  `session_key` varchar(80) DEFAULT NULL,
  `unionid` varchar(80) DEFAULT NULL,
  `openid` varchar(100) DEFAULT '' COMMENT '微信openId',
  `sex` char(1) NOT NULL DEFAULT '0',
  `coutry` varchar(255) NOT NULL DEFAULT '',
  `province` varchar(255) NOT NULL DEFAULT '',
  `city` varchar(255) NOT NULL DEFAULT '',
  `phone` char(15) NOT NULL DEFAULT '',
  `ip_addr` varchar(50) DEFAULT NULL,
  `update_time` int(11) DEFAULT '0' COMMENT '修改',
  `add_time` int(11) DEFAULT NULL,
  `status` char(1) NOT NULL DEFAULT '0',
  `show_adv` tinyint(1) DEFAULT '1' COMMENT '0关闭广告 1开启广告',
  PRIMARY KEY (`id`),
  KEY `openId` (`openid`) USING BTREE COMMENT 'openId'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='微信用户表';

/*Data for the table `hb_wx_user` */

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
