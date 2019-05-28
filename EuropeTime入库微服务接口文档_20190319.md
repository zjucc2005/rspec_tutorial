# 入库微服务接口文档

**文档信息**

| 系统名称 | 入库微服务 |
| :- | :- |
| 生产环境 | [https://micro_service/production/et_inbound/api/v1.0/](https://www.mypost4u.com/rest-api/v2.1/) |
| 测试环境 | http://47.96.153.174:9050/                                                   |
| 数据协议 | HTTP, JSON, SSL                                                                                    |
| 联系人 | chang.cai@quaie.com ; kater.jiang@quaie.com ; amy.wang@quaie.com ; samuel.uling@quaie.com    |

**版本记录**

| 版本编号 | 版本日期  | 修改者 | 说明 | 文件名 |
| :- | :- | :- | :- | :- |
| V1.0 | 2018/08/01 | 蔡畅 | 初稿 ||
| V1.1 | 2018/09/25 | 蔡畅 | 增加接口 2.1.14 取消出库订单重新生成入库预报 ||
| V1.2 | 2018/10/25 | 蔡畅 | 增加接口 2.1.15/2.1.16 入库预报的关闭和重新打开(工作人员), 和 2.1.7 区分, 更新 2.1.7 ||
| V1.3 | 2018/11/13 | 蔡畅 | 增加接口 2.4.1 入库预报数量统计 ||
| V1.4 | 2019/01/08 | 蔡畅 | 2.1.2/2.1.3/...等多个接口, 返回的入库预报列表/详情增加 created_by(用户email) 字段 ||
| V1.5 | 2019/01/21 | 蔡畅 | 入库预报创建/查询相关接口,增加支持transport_method和transport_memo两个字段 | | 
| V1.6 | 2019/03/19 | 蔡畅 | 2.1.3 sku信息增加返回商品名称; 2.1.8 增加收货人相关字段; 2.1.9 增加验货人相关字段; ||

**版权声明**

Copyright © 2018上海诗禹信息技术有限公司 All Rights Reserved

**目录**

[1. 介绍](#introduction)
>[1.1 文档目的](#purpose)

[2. 接口](#api)
>[2.1 入库预报](#inbound_skus)

>>[2.1.1 创建入库预报(SKU)](#inbound_notifications_create)

>>[2.1.2 入库预报列表](#inbound_notifications_index)

>>[2.1.3 入库预报详情](#inbound_notifications_show)

>>[2.1.4 入库预报收货](#inbound_notifications_receive)

>>[2.1.5 入库预报批次登记/入库批次生成](#inbound_notifications_register)

>>[2.1.6 入库预报完成登记<接口已停用>](#inbound_notifications_finish_register)

>>[2.1.7 入库预报完成(货主)](#inbound_notifications_finish)

>>[2.1.8 入库预报的收货信息](#inbound_notifications_inbound_received_infos)

>>[2.1.9 入库预报的批次登记信息](#inbound_notifications_inbound_batches)

>>[2.1.10 入库预报删除](#inbound_notifications_delete)

>>[2.1.11 入库预报sku增加](#inbound_notifications_create_inbound_sku)

>>[2.1.12 入库预报sku修改](#inbound_skus_update)

>>[2.1.13 入库预报sku删除](#inbound_skus_delete)

>>[2.1.14 取消出库订单并生成入库预报重新上架(出库服务调用)](#inbound_notifications_create_reshelf)

>>[2.1.15 入库预报关闭(工作人员)](#inbound_notifications_close)

>>[2.1.16 入库预报重新打开(工作人员)](#inbound_notifications_reopen)

>[2.2 入库批次](#inbound_batches)

>>[2.2.1 入库批次列表](#inbound_batches_index)

>>[2.2.2 入库批次详情](#inbound_batches_show)

>>[2.2.3 入库批次分配(操作员)](#inbound_batches_allocate)

>>[2.2.4 入库批次删除](#inbound_batches_delete)

>>[2.2.5 等待上架的入库批次](#inbound_batches_wait_to_operate)

>>[2.2.6 入库批次操作(sku上架)](#inbound_batches_operate)

>>[2.2.7 入库批次操作(问题sku登记)](#inbound_batches_register_problem)

>[2.3 包裹入库](#inbound_parcels)

>>[2.3.1 入库包裹列表(已收货)](#inbound_parcels_received)

>>[2.3.2 入库包裹登记](#inbound_parcels_register)

>>[2.3.3 入库包裹上架](#inbound_parcels_operate)

>[2.4 统计](#statistics)

>>[2.4.1 入库预报数量](#statistics_inbound_notifications_count)

[3. 附录](#appendix)
>[3.1 数据查询规则(FilterRules)](#filter_rules)

>[3.2 接口消息语种选择(Locale)](#locale)

<h2 id="introduction">1. 介绍</h2>
本文档是详细描述入库微服务的API接口文档。文档共分为三部分：介绍，接口，附录。其中第二部分接口是本文档的正文部分，明确了本系统所提供的接口服务类型及请求与响应格式。

<h3 id="purpose">1.1 文档目的</h3>
撰写本文档的目的是指导代理服务器与微服务的对接开发，帮助项目经理了解系统功能。
本文档同样适用于商户以及合作伙伴。

<h2 id="api">2. 接口</h2>

<h3 id="inbound_skus">2.1 SKU入库</h3>

<h4 id="inbound_notifications_create">2.1.1 创建入库预报</h4>

| Request | Response |
| :- | :- |
| POST /api/v1.0/inbound_notifications/create | 200 OK  |
| Content-Type: application/json | Content-Type: application/json |

* 请求参数
```ruby
{
	# 验证请求用户身份
	"access_token": "NSnc8CK3ceqozl8vlwi46A",
	
	"scheduled_time": "2018-08-01", # 必填, 计划时间
	"inbound_depot_code": "DUS",  # 必填, 仓库缩写
	"transport_method": "truck", # -- v1.5 --, 运输方式, self-delivery/express/truck/pickup
	"transport_memo": "一些备注信息", # -- v1.5 --, 运输信息备注 
	"inbound_skus": [
		{
			"sku_code": "SKU001", # 必填
			"barcode": "123456", # 必填
			"sku_owner": "sku_owner@gmail.com", # 不传值则默认为当前请求用户
			"quantity": 100,  # 必填, 预报数量
			"production_date": "2018-07-01", # 商品生产日期, 如果同一sku批次不同, 可以分多个预报填写
			"expiry_date": "2019-07-01",
			"country_of_origin": "CN",
			"abc_category": "A/B/C"
		},
		# ...
	]
}
```
* 响应代码
```ruby
# 认证 access_token 通过后, 返回对应用户的数据
{
	"status": "succ",
	"data": {
		"id": 1
		"inbound_num": "IN201808010001",
		"inbound_type": "general",
		"status": "new",
		"scheduled_time": "2018-08-01",
		"inbound_depot_code": "DUS",
		"created_by": "sku@owner.com", # -- v1.4 --, 预报所属用户/创建人, sku@owner.com 或者 system
		"inbound_skus": [
			{
				"id": 1,
				"status": "new",
				"sku_code": "SKU001",
				"barcode": "123456", 
				"sku_owner": "sku_owner@gmail.com", 
				"name": "商品名称", # -- v1.6 --
				"foreign_name": "commodity name", # -- v1.6 --
				"quantity": 100, 
				"production_date": "2018-07-01",
				"expiry_date": "2019-07-01",
				"country_of_origin": "CN",
				"abc_category": "A"
			},
			# ...
		]
	}	
}
# OR 认证失败
{
	"status": "fail",
	"reason": [ "Invalid access token" ]
}
```

<h4 id="inbound_notifications_index">2.1.2 入库预报列表</h4>

| Request | Response |
| :- | :- |
| GET /api/v1.0/inbound_notifications | 200 OK  |
| Content-Type: application/json | Content-Type: application/json |

* 请求参数
```ruby
{
	# 验证请求用户身份
	"access_token": "NSnc8CK3ceqozl8vlwi46A",
	
	"page": 1,
	"per_page": 10,
	# 参数查询规则请参照 FilterRules
	"q": {
		"inbound_num": "IN201808010001",  # 入库预报号
		"inbound_type": "general/transfer/parcel",  # 预报类型
		"status": "new/in_process/reopened/closed/finished", 
		"scheduled_time_lt": "2018-08-01",
		"inbound_depot_code": "DUS",
		"created_by": "sku@owner.com", # -- v1.4 --, 预报所属用户/创建人, sku@owner.com 或者 system
		"transport_method": "truck", # -- v1.5 --, 运输方式, self-delivery/express/truck/pickup
		"inbound_skus": {
			"sku_code": "SKU001",
			# ...
		},
		"inbound_parcels": {
			"parcel_num": "CN180801234567DE",
			# ...
		},
		# ...
	}
}
```
* 响应代码
```ruby
# 认证 access_token 通过后, 返回对应用户的数据
{
	"status": "succ",
	"data": [
		{
			"id": 1
			"inbound_num": "IN201808010001",
			"inbound_type": "general",
			"status": "new",
			"scheduled_time": "2018-08-01",
			"inbound_depot": "DUS",
			"created_at": "2018-08-01",
			"updated_at": "2018-08-02",
			"can_delete": true	# 2018-08-15 新增字段
			"transport_method": "truck", # -- v1.5 --, 运输方式, self-delivery/express/truck/pickup
			"transport_memo": "一些备注信息", # -- v1.5 --, 运输信息备注 
			# 预报列表返回不包含关联的inbound_skus或inbound_parcels详情
		},
		# ...
	],
	"page": 1,
	"per_page": 10,
	"count": 100
}
# OR 认证失败
{
	"status": "fail",
	"reason": [ 
		"Invalid access token",
		"Not authorized"
	]
}
```

<h4 id="inbound_notifications_show">2.1.3 入库预报详情</h4>

| Request | Response |
| :- | :- |
| GET /api/v1.0/inbound_notifications/:id/show | 200 OK  |
| Content-Type: application/json | Content-Type: application/json |

* 请求参数
```ruby
# GET /api/v1.0/inbound_notifications/1/show
{
	# 验证请求用户身份
	"access_token": "NSnc8CK3ceqozl8vlwi46A"
}
```
* 响应代码
```ruby
# 认证 access_token 通过后, 返回对应用户的数据
{
	"status": "succ",
	"data": {
		"id": 1
		"inbound_num": "IN201808010001",
		"inbound_type": "general",
		"status": "new",
		"scheduled_time": "2018-08-01",
		"inbound_depot": "DUS",
		"created_by": "sku@owner.com", # -- v1.4 --, 预报所属用户/创建人, sku@owner.com 或者 system
		"created_at": "2018-08-01",
		"updated_at": "2018-08-02",
		"can_delete": false, # 2018-08-15 新增字段
		"transport_method": "truck", # -- v1.5 --, 运输方式, self-delivery/express/truck/pickup
		"transport_memo": "一些备注信息", # -- v1.5 --, 运输信息备注 
		# inbound_type 为 "general/transfer" 时
		"inbound_skus": [
			{
				"id": 1,
				"status": "new/finished",
				"sku_code": "SKU001",
				"barcode": "123456",
				"sku_owner": "sku@owner.com",
				"name": "商品名称", # -- v1.6 --
				"foreign_name": "commodity name", # -- v1.6 --
				"quantity": 100, # 预报数量
				"received_quantity": 100, # 实收数量
				"registered_quantity": 50, # 登记数量
				"operated_quantity": 40, # 上架数量
				"problem_quantity": 10, # 问题数量
				"production_date": "2018-01-01",
				"expiry_date": "2019-01-01",
				"country_of_origin": "CN",
				"abc_category": "A",
				"can_delete": true, # 2018-08-15 新增字段
				"created_at": "2018-10-10",
				"updated_at": "2018-10-10"
			},
			# ...
		],
		# inbound_type 为 "parcel" 时
		"inbound_parcels": [
			{
				"id": 1,
				"parcel_num": "CN1801010001xxx",
				"status": "notified/received/on_shelf/sent",
				"space_num": "DUS-A-01-01-01",
				"operator": "receive@operator.com",
				"created_at": "2018-08-01",
				"updated_at": "2018-08-02"
			},
			#  ...
		]
	}
}
# OR 认证失败
{
	"status": "fail",
	"reason": [ 
		"Invalid access token",
		"Not authorized"
	]
}
```
<h4 id="inbound_notifications_receive">2.1.4 入库预报收货</h4>

| Request | Response |
| :- | :- |
| POST /api/v1.0/inbound_notifications/:id/receive | 200 OK  |
| Content-Type: application/json | Content-Type: application/json |

* 请求参数
```ruby
# POST /api/v1.0/inbound_notifications/1/receive
# 该接口用于登记入库预报的收货信息, 适用于 inbound_type: general/transfer
{
	# 验证请求用户身份
	"access_token": "NSnc8CK3ceqozl8vlwi46A",
	
	"inbound_received_skus": [
		{
			"barcode": "123456", # 必填
			"quantity": 50, # 必填, 收货数量
		},
		# ...
	]
}
```
* 响应代码
```ruby
# 认证 access_token 通过后, 返回对应用户的数据
{
	"status": "succ",
	"data": {
		"id": 1
		"inbound_num": "IN201808010001",
		"inbound_received_skus": [
			{
				"id": 1,
				"sku_code": "SKU001",
				"barcode": "123456", 
				"sku_owner": "sku_owner@gmail.com", 
				"quantity": 50
			},
			# ...
		]
	}	
}
# OR 认证失败
{
	"status": "fail",
	"reason": [ 
		"Invalid access token",
		"InboundNotification with id 1 not found"
	]
}
```

<h4 id="inbound_notifications_register">2.1.5 入库预报批次登记/入库批次生成</h4>

| Request | Response |
| :- | :- |
| POST /api/v1.0/inbound_notifications/:id/register | 200 OK  |
| Content-Type: application/json | Content-Type: application/json |

* 请求参数
```ruby
# POST /api/v1.0/inbound_notifications/1/register
# 该接口用于登记一个入库批次, 适用于 inbound_type: general/transfer
# 同一个sku号(商品)在一个批次中只能出现一次
{
	# 验证请求用户身份
	"access_token": "NSnc8CK3ceqozl8vlwi46A",
	
	"inbound_batch_skus": [
		{
			"barcode": "123456", # 必填
			"quantity": 50, # 必填
			"problem_type": nil, # 问题类型, 非nil时表示问题sku
			"problem_memo": "问题备注",
			"production_date": "2017-12-12", # 不传则默认继承预报中的值
			"expiry_date": "2018-12-12", # 不传则默认继承预报中的值
			"country_of_origin": "CN", # 不传则默认继承预报中的值
			"abc_category": "A/B/C", # 不传则默认继承预报中的值
		},
		# ...
	]
}
```
* 响应代码
```ruby
# 认证 access_token 通过后, 返回对应用户的数据
{
	"status": "succ",
	"data": {
		"id": 1
		"inbound_notification_id": 1,
		"batch_num": "IN201808010001N001"
		"status": "new/partial_mounted/mounted",
		"operators": [],
		"inbound_batch_skus": [
			{
				"id": 1,
				"status": "new/mounted",
				"sku_code": "SKU001",
				"barcode": "123456", 
				"sku_owner": "sku_owner@gmail.com", 
				"quantity": 50, 
				"problem_type": nil,
				"problem_memo": nil,
				"production_date": "2018-07-01",
				"expiry_date": "2019-07-01"
			},
			# ...
		]
	}	
}
# OR 认证失败
{
	"status": "fail",
	"reason": [ 
		"Invalid access token",
		"InboundNotification with id 1 not found",
		"Inbound Type parcel cannot be registered by this way"
	]
}
```

<h4 id="inbound_notifications_finish_register">2.1.6 入库预报完成登记(强制)</h4>

| Request | Response |
| :- | :- |
| POST /api/v1.0/inbound_notifications/:id/finish_register | 200 OK  |
| Content-Type: application/json | Content-Type: application/json |

* 请求参数
```ruby
# POST /api/v1.0/inbound_notifications/1/finish_register
# 适用于 inbound_type: general/transfer
# 该接口仅有阶段性状态提示作用, 实际调用与否, 不影响后续流程
{
	# 验证请求用户身份
	"access_token": "NSnc8CK3ceqozl8vlwi46A",
}
```
* 响应代码
```ruby
# 认证 access_token 通过后, 返回对应用户的数据
{
	"status": "succ",
	"data": {
		"id": 1
		"inbound_num": "IN201808010001",
		"inbound_type": "general",
		"status": "registered",
		"scheduled_time": "2018-08-01",
		"inbound_depot": "DUS",
		"inbound_skus": [
			{
				"id": 1,
				"status": "new",
				"sku_code": "SKU001",
				"barcode": "123456", 
				"sku_owner": "sku_owner@gmail.com", 
				"quantity": 100, 
				"production_date": "2018-07-01",
				"expiry_date": "2019-07-01",
				"country_of_origin": "CN",
				"abc_category": "A"
			},
			# ...
		]
	}
}
# OR 认证失败
{
	"status": "fail",
	"reason": [ 
		"Invalid access token",
		"InboundNotification with id 1 not found"
	]
}
```

<h4 id="inbound_notifications_finish">2.1.7 入库预报完成(货主)</h4>

| Request | Response |
| :- | :- |
| POST /api/v1.0/inbound_notifications/:id/finish | 200 OK  |
| Content-Type: application/json | Content-Type: application/json |

* 请求参数
```ruby
# POST /api/v1.0/inbound_notifications/1/finish
# 由货主进行确认操作, 表示预报操作无误, 正常完成, 之后将不能对入库预报进行任何更新修改操作
# ADMIN端工作人员的关闭操作, 转移至接口 2.1.15
{
	# 验证请求用户身份
	"access_token": "NSnc8CK3ceqozl8vlwi46A"
}
```
* 响应代码
```ruby
# 认证 access_token 通过后, 返回对应用户的数据
{
	"status": "succ",
	"data": {
		"id": 1
		"inbound_num": "IN201808010001",
		"inbound_type": "general",
		"status": "finished",
		"scheduled_time": "2018-08-01",
		"inbound_depot": "DUS",
		"created_by": "sku@owner.com", # -- v1.4 --, 预报所属用户/创建人, sku@owner.com 或者 system
		"inbound_skus": [
			{
				"id": 1,
				"status": "new",
				"sku_code": "SKU001",
				"barcode": "123456", 
				"sku_owner": "sku_owner@gmail.com", 
				"quantity": 100, 
				"production_date": "2018-07-01",
				"expiry_date": "2019-07-01",
				"country_of_origin": "CN",
				"abc_category": "A"
			},
			# ...
		]
	}
}
# OR 认证失败
{
	"status": "fail",
	"reason": [ 
		"Invalid access token",
		"InboundNotification with id 1 not found",
		"InboundNotification with id 1 cannot be finished"
	]
}
```

<h4 id="inbound_notifications_inbound_received_infos">2.1.8 入库预报的收货信息</h4>

| Request | Response |
| :- | :- |
| GET /api/v1.0/inbound_notifications/:id/inbound_received_infos | 200 OK  |
| Content-Type: application/json | Content-Type: application/json |

* 请求参数
```ruby
# GET /api/v1.0/inbound_notifications/1/inbound_received_infos
{
	# 验证请求用户身份
	"access_token": "NSnc8CK3ceqozl8vlwi46A"
}
```
* 响应代码
```ruby
# 认证 access_token 通过后, 返回对应用户的数据
{
	"status": "succ",
	"data": [
		{
			"id": 1,
			"inbound_num": "IN201808010001",
			"created_at": "2018-08-08",
			"created_by": "operator", 
			"receiver_email": "operator", # -- v1.6 --
			"receiver_id": 123, # -- v1.6 --
			"inbound_received_skus": [
				{
					"id": 1,
					"sku_code": "SKU001",
					"barcode": "123456", 
					"sku_owner": "sku_owner@gmail.com", 
					"quantity": 50
				},
				# ...				
			]
		},
		# ...
	]
}
# OR 认证失败
{
	"status": "fail",
	"reason": [ 
		"Invalid access token",
		"InboundNotification with id 1 not found"
	]
}
```

<h4 id="inbound_notifications_inbound_batches">2.1.9 入库预报的批次登记信息</h4>

| Request | Response |
| :- | :- |
| GET /api/v1.0/inbound_notifications/:id/inbound_batches | 200 OK  |
| Content-Type: application/json | Content-Type: application/json |

* 请求参数
```ruby
# GET /api/v1.0/inbound_notifications/1/inbound_batches
{
	# 验证请求用户身份
	"access_token": "NSnc8CK3ceqozl8vlwi46A"
}
```
* 响应代码
```ruby
# 认证 access_token 通过后, 返回对应用户的数据
{
	"status": "succ",
	"data": [
		{
			"id": 1,
			"inbound_notification_id": 1,
			"batch_num": "IN201808010001N001"
			"status": "new/partial_mounted/mounted",
			"created_at": "2018-08-01",
			"operators": [],
			"registrar_email": "operator", # -- v1.6 --
			"registrar_id": 88, # -- v1.6 --
		},
		# ...
	]
}
# OR 认证失败
{
	"status": "fail",
	"reason": [ 
		"Invalid access token",
		"InboundNotification with id 1 not found"
	]
}
```

<h4 id="inbound_notifications_delete">2.1.10 入库预报删除</h4>

| Request | Response |
| :- | :- |
| DELETE /api/v1.0/inbound_notifications/:id/delete | 200 OK  |
| Content-Type: application/json | Content-Type: application/json |

* 请求参数
```ruby
# DELETE /api/v1.0/inbound_notifications/1/delete
{
	# 验证请求用户身份
	"access_token": "NSnc8CK3ceqozl8vlwi46A"
}
```
* 响应代码
```ruby
# 认证 access_token 通过后, 返回对应用户的数据
{
	"status": "succ"
}
# OR 认证失败
{
	"status": "fail",
	"reason": [ 
		"Invalid access token",
		"InboundNotification with id 1 not found",
		"InboundNotification with id 1 cannot be deleted"
	]
}
```

<h4 id="inbound_notifications_create_inbound_sku">2.1.11 入库预报sku增加</h4>

| Request | Response |
| :- | :- |
| POST /api/v1.0/inbound_notifications/:id/create_inbound_sku | 200 OK  |
| Content-Type: application/json | Content-Type: application/json |

* 请求参数
```ruby
# POST /api/v1.0/inbound_notifications/1/create_inbound_sku
{
	# 验证请求用户身份
	"access_token": "NSnc8CK3ceqozl8vlwi46A",
	
	"sku_code": "SKU002",  # 必填
	"barcode": "1234567",  # 必填
	"sku_owner": "sku_owner@gmail.com",  # 必填
	"quantity": 123,  # 必填
	"production_date": "2018-07-01",
	"expiry_date": "2018-07-01",
	"country_of_origin": "CN",
	"abc_category": "A"
}
```
* 响应代码
```ruby
# 认证 access_token 通过后, 返回对应用户的数据
{
	"status": "succ",
	"data": {
		
	}
}
# OR 认证失败
{
	"status": "fail",
	"reason": [ 
		"Invalid access token",
		"InboundNotification with id 1 not found",
		"sku_code cannot be blank",
		"sku_code has been taken"
	]
}
```

<h4 id="inbound_skus_update">2.1.12 入库预报sku修改</h4>

| Request | Response |
| :- | :- |
| POST /api/v1.0/inbound_skus/:id/update | 200 OK  |
| Content-Type: application/json | Content-Type: application/json |

* 请求参数
```ruby
# POST /api/v1.0/inbound_skus/1/update
{
	# 验证请求用户身份
	"access_token": "NSnc8CK3ceqozl8vlwi46A",
	
	"sku_code": "SKU002",  # 必填
	"barcode": "1234567",  # 必填
	"sku_owner": "sku_owner@gmail.com",  # 必填
	"quantity": 123,  # 必填
	"production_date": "2018-07-01",
	"expiry_date": "2018-07-01",
	"country_of_origin": "CN",
	"abc_category": "A",
	"created_at": "2018-10-10",
	"updated_at": "2018-10-10",
	# ...
}
```
* 响应代码
```ruby
# 认证 access_token 通过后, 返回对应用户的数据
{
	"status": "succ"
}
# OR 认证失败
{
	"status": "fail",
	"reason": [ 
		"Invalid access token",
		"InboundSku with id 1 not found",
		"sku_code cannot be blank",
		"sku_code has been taken"
	]
}
```

<h4 id="inbound_skus_delete">2.1.13 入库预报sku删除</h4>

| Request | Response |
| :- | :- |
| DELETE /api/v1.0/inbound_skus/:id/delete | 200 OK  |
| Content-Type: application/json | Content-Type: application/json |

* 请求参数
```ruby
# DELETE /api/v1.0/inbound_skus/1/delete
{
	# 验证请求用户身份
	"access_token": "NSnc8CK3ceqozl8vlwi46A"
}
```
* 响应代码
```ruby
# 认证 access_token 通过后, 返回对应用户的数据
{
	"status": "succ"
}
# OR 认证失败
{
	"status": "fail",
	"reason": [ 
		"Invalid access token",
		"InboundSku with id 1 not found",
		"InboundSku with id 1 cannot be deleted",
	]
}
```

<h4 id="inbound_notifications_create_reshelf">2.1.14 取消出库订单并生成入库预报重新上架(出库服务调用)</h4>

| Request | Response |
| :- | :- |
| POST /api/v1.0/inbound_notifications/create_reshelf | 200 OK  |
| Content-Type: application/json | Content-Type: application/json |

* 请求参数
```ruby
# POST /api/v1.0/inbound_notifications/create_reshelf
{
	# 验证请求用户身份
	"access_token": "NSnc8CK3ceqozl8vlwi46A",
	
	"refer_num": "OUT20181010U001", # 必填, 出库订单流水号
	"scheduled_time": "2018-08-01", # 必填, 计划时间
	"inbound_depot_code": 'DUS',  # 必填, 仓库缩写
	"inbound_skus": [
		{
			"sku_code": "SKU001", # 必填
			"barcode": "123456", # 必填
			"sku_owner": "sku_owner@gmail.com", # 不传值则默认为当前请求用户
			"quantity": 100,  # 必填, 预报数量
		},
		# ...
	]
}
```
* 响应代码
```ruby
# 认证 access_token 通过后, 返回对应用户的数据
{
	"status": "succ",
	"data": {
		"id": 1
		"inbound_num": "IN201808010001",
		"inbound_type": "general",
		"status": "new",
		"scheduled_time": "2018-08-01",
		"inbound_depot_code": "DUS",
		"created_by": "sku@owner.com", # -- v1.4 --, 预报所属用户/创建人, sku@owner.com 或者 system
		"inbound_skus": [
			{
				"id": 1,
				"status": "new",
				"sku_code": "SKU001",
				"barcode": "123456", 
				"sku_owner": "sku_owner@gmail.com", 
				"quantity": 100, 
				"production_date": nil,
				"expiry_date": nil,
				"country_of_origin": nil,
				"abc_category": nil
			},
			# ...
		]
	}
}
# OR 认证失败
{
	"status": "fail",
	"reason": [ 
		"Invalid access token"
	]
}
```

<h4 id="inbound_notifications_close">2.1.15 入库预报关闭(工作人员)</h4>

| Request | Response |
| :- | :- |
| POST /api/v1.0/inbound_notifications/:id/close | 200 OK  |
| Content-Type: application/json | Content-Type: application/json |

* 请求参数
```ruby
# POST /api/v1.0/inbound_notifications/1/close
# 适用于 inbound_type: general/transfer
# 该接口用于工作人员确认入库预报是否完成, 确认后状态改成关闭 closed, 之后再由货主进一步确认
# 关闭后将不能再操作, 但可以通过 2.1.16 重新打开
{
	# 验证请求用户身份
	"access_token": "NSnc8CK3ceqozl8vlwi46A"
}
```
* 响应代码
```ruby
# 认证 access_token 通过后, 返回对应用户的数据
{
	"status": "succ",
	"data": {
		"id": 1
		"inbound_num": "IN201808010001",
		"inbound_type": "general",
		"status": "closed",
		"scheduled_time": "2018-08-01",
		"inbound_depot": "DUS",
		"created_by": "sku@owner.com", # -- v1.4 --, 预报所属用户/创建人, sku@owner.com 或者 system
		"inbound_skus": [
			{
				"id": 1,
				"status": "new",
				"sku_code": "SKU001",
				"barcode": "123456", 
				"sku_owner": "sku_owner@gmail.com", 
				"quantity": 100, 
				"production_date": "2018-07-01",
				"expiry_date": "2019-07-01",
				"country_of_origin": "CN",
				"abc_category": "A"
			},
			# ...
		]
	}
}
# OR 认证失败
{
	"status": "fail",
	"reason": [ 
		"Invalid access token",
		"InboundNotification with id 1 not found"
	]
}
```

<h4 id="inbound_notifications_reopen">2.1.16 入库预报重新打开(工作人员)</h4>

| Request | Response |
| :- | :- |
| POST /api/v1.0/inbound_notifications/:id/reopen | 200 OK  |
| Content-Type: application/json | Content-Type: application/json |

* 请求参数
```ruby
# POST /api/v1.0/inbound_notifications/1/reopen
# 适用于 inbound_type: general/transfer
# 该接口用于工作人员将关闭的入库预报重新打开, 操作后状态改成重新打开reopened, 之后可继续进行收货/登记等操作
# 货主确认后则不能重新打开
{
	# 验证请求用户身份
	"access_token": "NSnc8CK3ceqozl8vlwi46A"
}
```
* 响应代码
```ruby
# 认证 access_token 通过后, 返回对应用户的数据
{
	"status": "succ",
	"data": {
		"id": 1
		"inbound_num": "IN201808010001",
		"inbound_type": "general",
		"status": "reopened",
		"scheduled_time": "2018-08-01",
		"inbound_depot": "DUS",
		"created_by": "sku@owner.com", # -- v1.4 --, 预报所属用户/创建人, sku@owner.com 或者 system
		"inbound_skus": [
			{
				"id": 1,
				"status": "new",
				"sku_code": "SKU001",
				"barcode": "123456", 
				"sku_owner": "sku_owner@gmail.com", 
				"quantity": 100, 
				"production_date": "2018-07-01",
				"expiry_date": "2019-07-01",
				"country_of_origin": "CN",
				"abc_category": "A"
			},
			# ...
		]
	}
}
# OR 认证失败
{
	"status": "fail",
	"reason": [ 
		"Invalid access token",
		"InboundNotification with id 1 not found"
	]
}
```



<h3 id="inbound_batches">2.2 入库批次</h3>

<h4 id="inbound_batches_index">2.2.1 入库批次列表</h4>

| Request | Response |
| :- | :- |
| GET /api/v1.0/inbound_batches | 200 OK  |
| Content-Type: application/json | Content-Type: application/json |

* 请求参数
```ruby
# GET /api/v1.0/inbound_batches
{
	# 验证请求用户身份
	"access_token": "NSnc8CK3ceqozl8vlwi46A",
	
	"page": 1,
	"per_page": 10,
	# 参数查询规则请参照 FilterRules
	"q": {
		"batch_num_cont": "IN201808010001", # 批次号
		"status": "new/in_process/finished", # 处理状态
		"created_at_gt": "2018-01-01",  # 登记时间
		"operators_cont": "first@operator.com" # 操作员
	}
}
```
* 响应代码
```ruby
# 认证 access_token 通过后, 返回对应用户的数据
{
	"status": "succ",
	"data": [
		{
			"id": 1
			"inbound_num": "IN201808010001",
			"batch_num": "IN201808010001N001",
			"status": "new/in_process/finished",
			"created_at": "2018-08-01",
			"operators": [
				"first@operator.com",
				"second@operator.com"
			]			
		},
		# ...
	],
	"page": 1,
	"per_page": 10,
	"count": 100	
}
# OR 认证失败
{
	"status": "fail",
	"reason": [ 
		"Invalid access token"
	]
}
```

<h4 id="inbound_batches_show">2.2.2 入库批次详情</h4>

| Request | Response |
| :- | :- |
| GET /api/v1.0/inbound_batches/:id/show | 200 OK  |
| Content-Type: application/json | Content-Type: application/json |

* 请求参数
```ruby
# GET /api/v1.0/inbound_batches/1/show
{
	# 验证请求用户身份
	"access_token": "NSnc8CK3ceqozl8vlwi46A"
}
```
* 响应代码
```ruby
# 认证 access_token 通过后, 返回对应用户的数据
{
	"status": "succ",
	"data": {
		"id": 1
		"inbound_num": "IN201808010001",
		"batch_num": "IN201808010001N001",
		"status": "new/in_process/finished",
		"created_at": "2018-08-01",
		"operators": [
			"first@operator.com",
			"second@operator.com"
		],
		"inbound_batch_skus": [
			{
				"id": 1,
				"status": "new/finished",
				"sku_code": "SKU001",
				"barcode": "123456", 
				"sku_owner": "sku_owner@gmail.com", 
				"quantity": 50, 
				"operate_infos": [
					{ "shelf_num": "DU-A-01-01-01", "quantity": 10, operator: "xx" },
					{ "shelf_num": "DU-A-01-01-02", "quantity": 40, operator: "xx"}
				],
				"operate_memo": nil,
				"problem_type": nil,
				"problem_memo": nil,
				"production_date": "2018-07-01",
				"expiry_date": "2019-07-01",
				"country_of_origin": "CN",
				"abc_category": "A"
			},
			# ...
		]	
	}
}
# OR 认证失败
{
	"status": "fail",
	"reason": [ 
		"Invalid access token",
		"InboundBatch with id 1 not found"
	]
}
```

<h4 id="inbound_batches_allocate">2.2.3 入库批次分配(操作员)</h4>

| Request | Response |
| :- | :- |
| POST /api/v1.0/inbound_batches/:id/allocate | 200 OK  |
| Content-Type: application/json | Content-Type: application/json |

* 请求参数
```ruby
# POST /api/v1.0/inbound_batches/1/allocate
{
	# 验证请求用户身份
	"access_token": "NSnc8CK3ceqozl8vlwi46A",
	
	"operators": [
		"first@operator.com",
		"second@operator.com"
	]
}
```
* 响应代码
```ruby
# 认证 access_token 通过后, 返回对应用户的数据
{
	"status": "succ",
	"data": {
		"id": 1
		"inbound_num": "IN201808010001",
		"batch_num": "IN201808010001N001",
		"status": "new/in_process/finished",
		"operators": [
			"first@operator.com",
			"second@operator.com"
		]
	}
}
# OR 认证失败
{
	"status": "fail",
	"reason": [ 
		"Invalid access token",
		"InboundBatch with id 1 not found"
	]
}
```

<h4 id="inbound_batches_delete">2.2.4 入库批次删除</h4>

| Request | Response |
| :- | :- |
| DELETE /api/v1.0/inbound_batches/:id/delete | 200 OK  |
| Content-Type: application/json | Content-Type: application/json |

* 请求参数
```ruby
# DELETE /api/v1.0/inbound_batches/1/delete
{
	# 验证请求用户身份
	"access_token": "NSnc8CK3ceqozl8vlwi46A"
}
```
* 响应代码
```ruby
# 认证 access_token 通过后, 返回对应用户的数据
{
	"status": "succ"
}
# OR 认证失败
{
	"status": "fail",
	"reason": [ 
		"Invalid access token",
		"InboundBatch with id 1 not found",
		"InboundBatch with id 1 cannot be deleted"
	]
}
```

<h4 id="inbound_batches_wait_to_operate">2.2.5 等待上架的入库批次</h4>

| Request | Response |
| :- | :- |
| GET /api/v1.0/inbound_batches/wait_to_operate | 200 OK  |
| Content-Type: application/json | Content-Type: application/json |

* 请求参数
```ruby
# GET /api/v1.0/inbound_batches/wait_to_operate
{
	# 验证请求用户身份
	"access_token": "NSnc8CK3ceqozl8vlwi46A"
}
```
* 响应代码
```ruby
# 认证 access_token 通过后, 返回对应用户的数据
# 只返回operators包含当前请求用户的入库批次(有操作权限)
{
	"status": "succ",
	"data": [
		{
			"id": 1,
			"inbound_notification_id": 1,
			"batch_num": "IN201808010001N001"
			"status": "new",
			"operators": [
				"first@operator.com",
				"second@operator.com"
			]
		},
		# ...
	]
}
# OR 认证失败
{
	"status": "fail",
	"reason": [ 
		"Invalid access token"
	]
}
```

<h4 id="inbound_batches_operate">2.2.6 入库批次操作(sku上架)</h4>

| Request | Response |
| :- | :- |
| POST /api/v1.0/inbound_batches/:id/operate | 200 OK  |
| Content-Type: application/json | Content-Type: application/json |

* 请求参数
```ruby
# POST /api/v1.0/inbound_batches/:id/operate
{
	# 验证请求用户身份
	"access_token": "NSnc8CK3ceqozl8vlwi46A",
	
	"inbound_batch_sku": {
		"barcode": "123456", # 必填
		"quantity": 20, # 必填
		"shelf_num": "DUS-A-01-01-01", # 必填
		"operate_memo": '上架备注'	
	}
}
```
* 响应代码
```ruby
# 认证 access_token 通过后, 返回对应用户的数据
# 只返回operators包含当前请求用户的入库批次(有操作权限)
{
	"status": "succ"
}
# OR 认证失败
{
	"status": "fail",
	"reason": [ 
		"Invalid access token",
		"InboundBatch with id 1 not found",
		"Not authorized",
		"Commodity has already been put on shelf",
		"Not enough quantity for SKU001 to operate"
	]
}
```

<h4 id="inbound_batches_register_problem">2.2.7 入库批次操作(问题sku登记)</h4>

| Request | Response |
| :- | :- |
| POST /api/v1.0/inbound_batches/:id/register_problem | 200 OK  |
| Content-Type: application/json | Content-Type: application/json |

* 请求参数
```ruby
# POST /api/v1.0/inbound_batches/:id/register_problem
{
	# 验证请求用户身份
	"access_token": "NSnc8CK3ceqozl8vlwi46A",
	
	"inbound_batch_sku": {
		"barcode": "123456", # 必填
		"quantity": 20, # 必填
		"problem_type": "破损", # 必填
		"problem_memo": "问题备注",
		"production_date": "2017-12-12",
		"expiry_date": "2018-12-12",
		"country_of_origin": "CN",
		"abc_category": "A"
	}
}
```
* 响应代码
```ruby
# 认证 access_token 通过后, 返回对应用户的数据
# 只返回operators包含当前请求用户的入库批次(有操作权限)
{
	"status": "succ"
}
# OR 认证失败
{
	"status": "fail",
	"reason": [ 
		"Invalid access token",
		"InboundBatch with id 1 not found",
		"Not authorized",
		"Commodity has already been put on shelf",
		"Not enough quantity for SKU001 to operate"
	]
}
```




<h3 id="inbound_parcels">2.3 包裹入库</h3>

<h4 id="inbound_parcels_received">2.3.1 入库包裹列表(已收货)</h4>

| Request | Response |
| :- | :- |
| GET /api/v1.0/inbound_parcels/received | 200 OK  |
| Content-Type: application/json | Content-Type: application/json |

* 请求参数
```ruby
# GET /api/v1.0/inbound_parcels/received
{
	# 验证请求用户身份
	"access_token": "NSnc8CK3ceqozl8vlwi46A"
}
```
* 响应代码
```ruby
# 认证 access_token 通过后, 返回对应用户的数据
{
	"status": "succ",
	"data": [
		{
			"id": 1,
			"parcel_num": "CN1808012345"
			"status": "registered/on_shelf/off_shelf/sent",
			"shelf_num": nil,
			"parcel_owner": "parcel@owner.com"
		},
		{
			"id": 2,
			"parcel_num": "CN1808013579"
			"status": "registered/on_shelf/off_shelf/sent",
			"shelf_num": nil,
			"parcel_owner": "parcel@owner.com"
		},		
		# ...
	]
}
# OR 认证失败
{
	"status": "fail",
	"reason": [ 
		"Invalid access token"
	]
}
```

<h4 id="inbound_parcels_register">2.3.2 入库包裹登记</h4>

| Request | Response |
| :- | :- |
| POST /api/v1.0/inbound_parcels/register | 200 OK  |
| Content-Type: application/json | Content-Type: application/json |

* 请求参数
```ruby
# GET /api/v1.0/inbound_parcels/received
{
	# 验证请求用户身份
	"access_token": "NSnc8CK3ceqozl8vlwi46A",
	
	"parcel_num": "CN1808012345"
}
```
* 响应代码
```ruby
# 认证 access_token 通过后, 返回对应用户的数据
{
	"status": "succ"
}
# OR 认证失败
{
	"status": "fail",
	"reason": [
		"Invalid access token",
		"Unknown parcel",
		"Parcel has already been registered"
	]
}
```

<h4 id="inbound_parcels_operate">2.3.3 入库包裹上架</h4>

| Request | Response |
| :- | :- |
| POST /api/v1.0/inbound_parcels/operate | 200 OK  |
| Content-Type: application/json | Content-Type: application/json |

* 请求参数
```ruby
# GET /api/v1.0/inbound_parcels/received
{
	# 验证请求用户身份
	"access_token": "NSnc8CK3ceqozl8vlwi46A",
	
	"parcel_num": "CN1808012345",
	"shelf_num": "DUS-A-01-01-01"
}
```
* 响应代码
```ruby
# 认证 access_token 通过后, 返回对应用户的数据
{
	"status": "succ"
}
# OR 认证失败
{
	"status": "fail",
	"reason": [
		"Invalid access token",
		"Unknown parcel",
		"Parcel cannot be put on shelf",
		"Parcel has already been put on shelf"
	]
}
```

<h3 id="statistics">2.4 统计</h3>

<h4 id="statistics_inbound_notifications_count">2.4.1 入库预报数量统计</h4>

| Request | Response |
| :- | :- |
| POST /api/v1.0/statistics/inbound_notifications/count | 200 OK  |
| Content-Type: application/json | Content-Type: application/json |

* 请求参数
```ruby
# GET /api/v1.0/statistics/inbound_notifications/count
# 自动根据请求用户的最高权限(角色/渠道), 返回对应的统计
{
	# 验证请求用户身份
	"access_token": "NSnc8CK3ceqozl8vlwi46A"
}
```
* 响应代码
```ruby
# 认证 access_token 通过后, 返回对应用户的数据
{
	"status": "succ",
	"new_count": 8,  # 未入库(未处理)的入库预报数量
	"in_process_count": 2, # 处理中的入库预报数量
	
}
# OR 认证失败
{
	"status": "fail",
	"reason": [
		"Invalid access token"
	]
}
```

<h2 id="appendix">3. 附录</h2>
<h3 id="filter_rules">3.1 数据查询规则(Filter Rules)</h3>

| Matcher | Example | Rule | Query Syntax |
| :- | :- | :- | :- |
| (blank) | name | equal to | name = ? |
| eq | name_eq | equal to | name = ? |
| in | name_in | in | name in (?) |
| cont | name_cont | string contain | name like ? |
| cont | name_cont | array/list contain | name @> ? |
| gt | name_gt | greater than | name > ? |
| gteq | name_gteq | greater than or equal to | name >= ? |
| lt | name_lt | less than | name < ? |
| lteq | name_lteq | less than or equal to | name <= ? |

<h3 id="locale">3.2 接口消息语种选择(Locale)</h3>
* 支持语种: en(default), zh_cn
* 选择其他语种时, 请在请求的 url 后加上参数 locale=zh_cn
* 例如: POST /api/v1.0/depots/create?locale=zh_cn

| Locale | Example |
| :- | :- |
| en | depot_code can't be blank |
| zh_cn | depot_code 不能为空 |
e 