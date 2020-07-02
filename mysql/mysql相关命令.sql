
-- COMMENT '这样添加注释'
drop table if exists t_test1;
CREATE TABLE `t_test1` (
	`id` INT(11) NOT NULL AUTO_INCREMENT COMMENT '自增主键',
	`create_time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时自动填充时间',
	`name` VARCHAR(255) NULL DEFAULT NULL COMMENT '测试数据',
	PRIMARY KEY (`id`)
)ENGINE=InnoDB AUTO_INCREMENT=1000 DEFAULT CHARSET=utf8mb4 COMMENT='自动保存添加数据时间';


drop table if exists t_test2;
CREATE TABLE `t_test2` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增主键',
  `update_time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP  ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时自动更新时间',
  `name` varchar(255) DEFAULT NULL COMMENT '测试数据',
  PRIMARY KEY (`id`)
)ENGINE=InnoDB AUTO_INCREMENT=1000 DEFAULT CHARSET=utf8mb4 COMMENT='自动保存添加数据时间并自动更新相关字段时间';


ERROR 1293 (HY000): Incorrect table definition; there can be only one TIMESTAMP column with CURRENT_TIMESTAMP in DEFAULT or ON UPDATE clause

-- 意思是只能存在一个TIMESTAMP类型的字段。
drop table if exists usertest;
CREATE TABLE `usertest` (
	`uid` INT(11) NOT NULL AUTO_INCREMENT,
	`name` VARCHAR(50) NOT NULL COMMENT '用户名',
	`email` VARCHAR(100) NULL DEFAULT NULL,
	`age` INT(11) NOT NULL,
	`sex` VARCHAR(1) NOT NULL,
	`phone` VARCHAR(11) NULL DEFAULT NULL,
	`addtime` DATETIME(6) NULL DEFAULT NULL,
	`savetime` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时自动填充时间',
	`status` TINYINT(1) NOT NULL DEFAULT '0' COMMENT '用户状态',
	PRIMARY KEY (`uid`)
)COLLATE='utf8_general_ci' ENGINE=InnoDB AUTO_INCREMENT=1000 COMMENT 'django 测试表';