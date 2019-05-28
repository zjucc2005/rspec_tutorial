# 出库微服务接口文档

**文档信息**

| 系统名称 | 出库微服务 |
| :- | :- |
| 生产环境 | [https://micro_service/production/et_outbound/api/v1.0/](https://www.mypost4u.com/rest-api/v2.1/) |
| 测试环境 | http://47.96.153.174:9050/                                                   |
| 数据协议 | HTTP, JSON, SSL                                                                                    |
| 联系人 | chang.cai@quaie.com ; kater.jiang@quaie.com ; amy.wang@quaie.com ; samuel.uling@quaie.com    |

**版本记录**

| 版本编号 | 版本日期  | 修改者 | 说明 | 文件名 |
| :- | :- | :- | :- | :- |
| V1.0 | 2018/09/18 | 蔡畅 | 初稿 ||
| V1.1 | 2018/10/10 | 蔡畅 | 新增接口 2.2.10, 选择取货方式改为以出库订单为单位调用 | |
| V1.2 | 2018/10/19 | 蔡畅 | 新增接口 2.1.7, mypost4u包裹确认, 出库订单详情, 增加包裹确认标记字段和重量/长/宽/高/价格字段 | |
| V1.3 | 2018/10/26 | 蔡畅 | 出库预报增加返回need_mp4_confirm字段 ;新增接口 2.1.8/2.1.9 出库预报的关闭/重新打开(工作人员); 修改接口 2.1.5 出库预报完成改成由货主确认; 新增接口 2.2.11 出库订单批量取消 | |
| V1.4 | 2018/11/15 | 蔡畅 | 增加统计相关接口 2.4.1, 2.4.2 | | 
| V1.5 | 2019/02/19 | 蔡畅 | 新增接口 2.2.12 Mypost4u包裹确认日志 | |
| V1.6 | 2019/03/19 | 蔡畅 | 2.1.2 增加返回订单数字段outbound_orders_count ;2.2.1, 2.2.2 增加返回 outbound_num; 2.2.1 增加包裹确认信息查询和返回 ||

**版权声明**

Copyright © 2018上海诗禹信息技术有限公司 All Rights Reserved

**目录**

[1. 介绍](#introduction)
>[1.1 文档目的](#purpose)

[2. 接口](#api)
>[2.1 出库预报](#outbound_notifications)

>>[2.1.1 创建出库预报](#outbound_notifications_create)

>>[2.1.2 出库预报列表(查询)](#outbound_notifications_index)

>>[2.1.3 出库预报详情](#outbound_notifications_show)

>>[2.1.4 出库预报选择分配方式](#outbound_notifications_allocate_method)

>>[2.1.5 出库预报完成(货主)](#outbound_notifications_finish)

>>[2.1.6 出库预报删除](#outbound_notifications_delete)

>>[2.1.7 出库预报mypost4u包裹确认(货主)](#outbound_notifications_mypost4u_parcels_confirm)

>>[2.1.8 出库预报关闭(工作人员)](#outbound_notifications_close)

>>[2.1.9 出库预报重新打开(工作人员)](#outbound_notifications_reopen)

>[2.2 出库订单](#outbound_orders)

>>[2.2.1 出库订单列表(查询)](#outbound_orders_index)

>>[2.2.2 出库订单详情](#outbound_orders_show)

>>[2.2.3 出库订单分配操作员(单个)](#outbound_orders_allocate_operator)

>>[2.2.4 出库订单分配操作员(批量)](#outbound_orders_allocate_operators)

>>[2.2.5 查询出库订单的取货信息](#outbound_orders_picking_infos)

>>[2.2.6 待取货出库订单列表(操作员手持端)](#outbound_orders_wait_to_operate)

>>[2.2.7 出库订单操作(取货完毕)](#outbound_orders_picked)

>>[2.2.8 出库订单修改](#outbound_orders_update)

>>[2.2.9 出库订单取消](#outbound_orders_cancel)

>>[2.2.10 出库订单选择取货方式](#outbound_orders_allocate_method)

>>[2.2.11 出库订单取消(批量)](#outbound_orders_batch_cancel)

>>[2.2.12 Mypost4u包裹确认日志](#outbound_orders_mypost4u_parcel_confirmation_logs)

>[2.3 扫描](#scanning)

>>[2.3.1 扫描流水号创建Mypost4u包裹](#scanning_create_mypost4u_parcel)

>[2.4 统计](#statistics)

>>[2.4.1 出库订单数量](#statistics_outbound_orders_count)

>>[2.4.2 出库订单趋势](#statistics_outbound_orders_trend)

[3. 附录](#appendix)
>[3.1 数据查询规则(FilterRules)](#filter_rules)

>[3.2 接口消息语种选择(Locale)](#locale)

<h2 id="introduction">1. 介绍</h2>
本文档是详细描述出库微服务的API接口文档。文档共分为三部分：介绍，接口，附录。其中第二部分接口是本文档的正文部分，明确了本系统所提供的接口服务类型及请求与响应格式。

<h3 id="purpose">1.1 文档目的</h3>
撰写本文档的目的是指导代理服务器与微服务的对接开发，帮助项目经理了解系统功能。
本文档同样适用于商户以及合作伙伴。

<h2 id="api">2. 接口</h2>

<h3 id="outbound_notifications">2.1 出库预报</h3>

<h4 id="outbound_notifications_create">2.1.1 创建出库预报</h4>

| Request | Response |
| :- | :- |
| POST /api/v1.0/outbound_notifications/create | 200 OK  |
| Content-Type: application/json | Content-Type: application/json |

* 请求参数
```ruby
{
	# 验证请求用户身份
	"access_token": "NSnc8CK3ceqozl8vlwi46A",
	
	"scheduled_time": "2018-08-01",  # 出库计划时间
	
	# 每次提交创建一个出库预报, 由N个出库订单组成
	"outbound_orders": [
		{
			"order_num": "order001",  # 必填, 订单号
			"depot_code": "DUS",  # 必填, 仓库代码
			"outbound_skus": [
				{
					"sku_code": "sku001", # 必填, 商品代码
					"barcode": "bar001",  # 必填, 商品条码
					"quantity": 16,  #必填, 出库数量
					"sku_owner": "sku@owner.com"  # 商品所有者, 可不传, 默认为请求用户
					
				},
				{
					"sku_code": "sku002", # 必填, 商品代码
					"barcode": "bar002",  # 必填, 商品条码
					"quantity": 16,  #必填, 出库数量
					"sku_owner": "sku@owner.com",  # 商品所有者, 可不传, 默认为请求用户
				},
				...
			],
			"shpmt_num": "shpmt001",  # 运单号
			"shpmt_product": "DHL",  # 物流产品
			"shpmt_addr_info": {
				"sender": { "country": "DE", ... },  # 发件人地址
				"recipient": { "country": "CN", ... }  # 收件人地址
			}
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
		"outbound_num": "IN201808010001",
		"status": "new",
		"created_by": "lifuyuan@lifuyuan.com",
		"allocator": nil,
		"scheduled_time": "2018-09-08",
		"created_at": "2019-09-07",
		"updated_at": "2019-09-07"
	}	
}
# OR 认证失败
{
	"status": "fail",
	"reason": [ 
		"Invalid access token",
		"outbound_orders must be an Array"
	]
}
```

<h4 id="outbound_notifications_index">2.1.2 出库预报列表(查询)</h4>
| Request | Response |
| :- | :- |
| GET /api/v1.0/outbound_notifications | 200 OK  |
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
		"outbound_num": "OUT201808010001",  # 出库预报号
		"status": "new/in_process/finished", 
		"scheduled_time_lt": "2018-08-01",
		"created_at_gteq": "2018-08-01" , 
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
			"outbound_num": "OUT201808010001",
			"status": "new",
			"scheduled_time": "2018-08-01",
			"created_by": "sku@owner.com",
			"allocator": "allocator@warehouse.com"
			"created_at": "2018-08-01",
			"updated_at": "2018-08-02",
			"can_delete": true,	# 能否删除标志
			"mp4_confirmed": false, # mypost4u包裹确认标记
			"need_mp4_confirm": true, # 表示是否有待确认的mypost4u包裹
			"outbound_orders_count": 14, # -- v1.6 --
			# 预报列表返回不包含关联的出库订单详情
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

<h4 id="outbound_notifications_show">2.1.3 出库预报详情</h4>
| Request | Response |
| :- | :- |
| GET /api/v1.0/outbound_notifications/:id/show | 200 OK  |
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
		"outbound_num": "OUT201808010001",
		"status": "new",
		"scheduled_time": "2018-08-01",
		"created_by": "sku@owner.com",
		"allocator": "allocator@warehouse.com"
		"created_at": "2018-08-01",
		"updated_at": "2018-08-02",
		"can_delete": true,	# 能否删除标志
		
		"outbound_orders": [
			{
				"id": 1,
				"batch_num": "OUT201808010001N001", # 系统流水号
				"order_num": "order001",
				"depot_code": "DUS",
				"status": "new", # new/allocated/picked/printed/sent/cancelled
				"outbound_method": nil, # picking/seeding
				"operator": nil,
				"created_at": "2018-08-01",
				"updated_at": "2018-08-01",
				"outbound_skus": [
					{
						"sku_code": "sku001", 
						"barcode": "bar001",  
						"quantity": 16,  
						"sku_owner": "sku@owner.com"
					},
					{
						"sku_code": "sku002",
						"barcode": "bar002", 
						"quantity": 16, 
						"sku_owner": "sku@owner.com", 
					},
					# ...
				],
				"shpmt_num": "shpmt001",  # 运单号
				"shpmt_product": "DHL",  # 物流产品
				"shpmt_addr_info": {
					"sender": { "country": "DE", ... },  # 发件人地址
					"recipient": { "country": "CN", ... }  # 收件人地址
				},
				"parcel_num": "DE123456...", # mypost4u包裹号	
				"weight": 8.8, # 包裹重量
				"length": 50, # 包裹长度
				"width": 40, # 包裹宽度
				"height":  30, # 包裹高度
				"price": 20, # 包裹价格
				"currency": "EUR", # 价格货币单位
				"mp4_confirmed": false, # mypost4u包裹确认标记
				"mp4_confirmed_at": "2018-08-02", # -- v1.5 --, mypost4u包裹确认时间		
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
		"Not authorized"
	]
}
```

<h4 id="outbound_notifications_allocate_method">2.1.4 出库预报选择分配方式</h4>
| Request | Response |
| :- | :- |
| POST /api/v1.0/outbound_notifications/:id/allocate_method | 200 OK  |
| Content-Type: application/json | Content-Type: application/json |

* 请求参数
```ruby
# GET /api/v1.0/inbound_notifications/1/show
{
	# 验证请求用户身份
	"access_token": "NSnc8CK3ceqozl8vlwi46A",
	"outbound_method": "picking", # picking/seeding, 目前先支持picking方式
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
		"Not authorized"
	]
}
```

<h4 id="outbound_notifications_finish">2.1.5 出库预报完成</h4>
| Request | Response |
| :- | :- |
| POST /api/v1.0/outbound_notifications/:id/finish | 200 OK  |
| Content-Type: application/json | Content-Type: application/json |

* 请求参数
```ruby
# POST /api/v1.0/inbound_notifications/1/finish
{
	# 验证请求用户身份
	"access_token": "NSnc8CK3ceqozl8vlwi46A"
	
	# 当工作人员关闭出库预报后(closed), 货主可以进一步确认更新其状态为完成(finished), 之后将不能对预报做任何修改操作
	# 此接口为理论上最终步骤, 但和接口 2.1.7 出库预报mypost4u包裹确认 相互独立,即使finsihed之后, 仍可继续调用 2.1.7
}
```
* 响应代码
```ruby
# 认证 access_token 通过后, 返回对应用户的数据
{
	"status": "succ",
	"data": {
		"id": 1
		"outbound_num": "OUT201808010001",
		"status": "finished",
		"scheduled_time": "2018-08-01",
		"created_by": "sku@owner.com",
		"allocator": "allocator@warehouse.com"
		"created_at": "2018-08-01",
		"updated_at": "2018-08-02",
		"can_delete": true,	# 能否删除标志
		"mp4_confirmed": true, # mypost4u包裹确认标记
		"need_mp4_confirm": false, # 表示是否有待确认的mypost4u包裹
	}
}
# OR 认证失败
{
	"status": "fail",
	"reason": [ 
		"Invalid access token",
		"Not authorized",
		"InboundNotification with id 1 cannot be finished"
	]
}
```

<h4 id="outbound_notifications_delete">2.1.6 出库预报删除</h4>
| Request | Response |
| :- | :- |
| DELETE /api/v1.0/outbound_notifications/:id/delete | 200 OK  |
| Content-Type: application/json | Content-Type: application/json |

* 请求参数
```ruby
# DELETE /api/v1.0/inbound_notifications/1/delete
{
	# 验证请求用户身份
	"access_token": "NSnc8CK3ceqozl8vlwi46A"
	
	# 只有新建的出库预报才能删除
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
		"Not authorized",
		"InboundNotification with id 1 cannot be deleted"
	]
}
```

<h4 id="outbound_notifications_mypost4u_parcels_confirm">2.1.7 出库预报mypost4u包裹确认</h4>
| Request | Response |
| :- | :- |
| POST /api/v1.0/outbound_notifications/:id/mypost4u_parcels_confirm | 200 OK  |
| Content-Type: application/json | Content-Type: application/json |

* 请求参数
```ruby
# POST /api/v1.0/inbound_notifications/1/mypost4u_parcels_confirm
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
		"Not authorized"
	]
}
```

<h4 id="outbound_notifications_close">2.1.8 出库预报关闭(工作人员)</h4>
| Request | Response |
| :- | :- |
| POST /api/v1.0/outbound_notifications/:id/close | 200 OK  |
| Content-Type: application/json | Content-Type: application/json |

* 请求参数
```ruby
# POST /api/v1.0/inbound_notifications/1/close
{
	# 验证请求用户身份
	"access_token": "NSnc8CK3ceqozl8vlwi46A"
	
	# 工作人员关闭出库预报后(closed), 将不能对预报做出修改操作, 但可以通过 2.1.9 重新打开预报(reopened)
}
```
* 响应代码
```ruby
# 认证 access_token 通过后, 返回对应用户的数据
{
	"status": "succ",
	"data": {
		"id": 1
		"outbound_num": "OUT201808010001",
		"status": "closed",
		"scheduled_time": "2018-08-01",
		"created_by": "sku@owner.com",
		"allocator": "allocator@warehouse.com"
		"created_at": "2018-08-01",
		"updated_at": "2018-08-02",
		"can_delete": true,	# 能否删除标志
		"mp4_confirmed": true, # mypost4u包裹确认标记
		"need_mp4_confirm": false, # 表示是否有待确认的mypost4u包裹
	}
}
# OR 认证失败
{
	"status": "fail",
	"reason": [ 
		"Invalid access token",
		"Not authorized",
		"InboundNotification with id 1 cannot be operated"
	]
}
```

<h4 id="outbound_notifications_reopen">2.1.9 出库预报重新打开(工作人员)</h4>
| Request | Response |
| :- | :- |
| POST /api/v1.0/outbound_notifications/:id/reopen | 200 OK  |
| Content-Type: application/json | Content-Type: application/json |

* 请求参数
```ruby
# POST /api/v1.0/inbound_notifications/1/reopen
{
	# 验证请求用户身份
	"access_token": "NSnc8CK3ceqozl8vlwi46A"
	
	# 工作人员可重新打开已关闭的出库预报, 预报的状态改成重新打开(reopen), 和操作中(in_process)一样可以再次对预报进行操作, 但完成后的预报(finished)不能重新打开
}
```
* 响应代码
```ruby
# 认证 access_token 通过后, 返回对应用户的数据
{
	"status": "succ",
	"data": {
		"id": 1
		"outbound_num": "OUT201808010001",
		"status": "reopened",
		"scheduled_time": "2018-08-01",
		"created_by": "sku@owner.com",
		"allocator": "allocator@warehouse.com"
		"created_at": "2018-08-01",
		"updated_at": "2018-08-02",
		"can_delete": true,	# 能否删除标志
		"mp4_confirmed": false, # mypost4u包裹确认标记
		"need_mp4_confirm": true, # 表示是否有待确认的mypost4u包裹
	}
}
# OR 认证失败
{
	"status": "fail",
	"reason": [ 
		"Invalid access token",
		"Not authorized",
		"InboundNotification with id 1 cannot be operated"
	]
}
```



<h3 id="outbound_orders">2.2 出库订单</h3>

<h4 id="outbound_orders_index">2.2.1 出库订单列表(查询)</h4>

| Request | Response |
| :- | :- |
| GET /api/v1.0/outbound_orders | 200 OK  |
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
		"outbound_num": "OUT201808010001",  # 出库预报号
		"batch_num": "OUT201808010001N001", # 批次号/系统流水号(唯一)
		"order_num": "order001", # 订单号
		"depot_code": "DUS",
		"status": "new", # new/allocated/picked/printed/sent/cancelled
		"outbound_method": "picking", # picking/seeding
		"operator": "operator@warehouse.com"
		"created_at_gteq": "2018-08-01" , 
		"mp4_confirmed": true/false(nil), # 包裹是否确认
		"mp4_confirmed_at_gteq": "2018-09-01", # 包裹确认时间
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
			"id": 1,
			"outbound_num": "OUT201808010001", # -- v1.6 --
			"batch_num": "OUT201808010001N001", # 系统流水号
			"order_num": "order001",
			"depot_code": "DUS",
			"status": "new", # new/allocated/picked/printed/sent/cancelled
			"outbound_method": nil, # picking/seeding
			"operator": nil,
			"mp4_confirmed": true, # -- v1.6 --
			"mp4_confirmed_at": "2018-09-01", # -- v1.6 --
			"created_at": "2018-08-01",
			"updated_at": "2018-08-01",
			# outbound_skus 信息在出库订单详情中返回			
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

<h4 id="outbound_orders_show">2.2.2 出库订单详情</h4>

| Request | Response |
| :- | :- |
| GET /api/v1.0/outbound_orders/:id/show | 200 OK  |
| Content-Type: application/json | Content-Type: application/json |

* 请求参数
```ruby
# GET /api/v1.0/outbound_orders/1/show
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
		"id": 1,
		"outbound_num": "OUT201808010001", # -- v1.6 --
		"batch_num": "OUT201808010001N001", # 系统流水号
		"order_num": "order001",
		"depot_code": "DUS",
		"status": "new", # new/allocated/picked/printed/sent/cancelled
		"outbound_method": nil, # picking/seeding
		"operator": nil,
		"created_at": "2018-08-01",
		"updated_at": "2018-08-01",
		"outbound_skus": [
			{
				"sku_code": "sku001", 
				"barcode": "bar001",  
				"quantity": 16,  
				"sku_owner": "sku@owner.com"
			},
			{
				"sku_code": "sku002",
				"barcode": "bar002", 
				"quantity": 16, 
				"sku_owner": "sku@owner.com", 
			},
			# ...
		],
		"shpmt_num": "shpmt001",  # 运单号
		"shpmt_product": "DHL",  # 物流产品
		"shpmt_addr_info": {
			"sender": { "country": "DE", ... },  # 发件人地址
			"recipient": { "country": "CN", ... }  # 收件人地址
		},
		"parcel_num": nil,  # mypost4u 包裹号
		"weight": 8.8, # 包裹重量
		"length": 50, # 包裹长度
		"width": 40, # 包裹宽度
		"height":  30, # 包裹高度
		"price": 20, # 包裹价格
		"currency": "EUR", # 价格货币单位
		"mp4_confirmed": false, # mypost4u包裹确认标记
		"mp4_confirmed_at": "2018-08-02", # -- v1.5 --, mypost4u包裹确认时间	
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

<h4 id="outbound_orders_allocate_operator">2.2.3 出库订单分配操作员(单个)</h4>
| Request | Response |
| :- | :- |
| POST /api/v1.0/outbound_orders/:id/allocate_operator | 200 OK  |
| Content-Type: application/json | Content-Type: application/json |

* 请求参数
```ruby
# POST /api/v1.0/inbound_orders/1/allocate_operator
{
	# 验证请求用户身份
	"access_token": "NSnc8CK3ceqozl8vlwi46A",
	"operator": "operator@warehouse.com"  # 操作员帐号, string类型
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
		"Not authorized"
	]
}
```

<h4 id="outbound_orders_allocate_operators">2.2.4 出库订单分配操作员(批量)</h4>
| Request | Response |
| :- | :- |
| POST /api/v1.0/outbound_orders/allocate_operators | 200 OK  |
| Content-Type: application/json | Content-Type: application/json |

* 请求参数
```ruby
# POST /api/v1.0/inbound_orders/allocate_operators
{
	# 验证请求用户身份
	"access_token": "NSnc8CK3ceqozl8vlwi46A",
	"resource":[
		{ 
			"ids": [1, 2], # 出库订单id, Array 类型
			"operator": "operator1@warehouse.com"  # 操作员帐号, String类型
		},
		{ 
			"ids": [3, 4, 5],
			"operator": "operator2@warehouse.com" 
		},		
	]
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
		"Not authorized"
	]
}
```

<h4 id="outbound_orders_picking_infos">2.2.5 查询出库订单的取货信息</h4>
| Request | Response |
| :- | :- |
| GET /api/v1.0/outbound_orders/:id/picking_infos | 200 OK  |
| Content-Type: application/json | Content-Type: application/json |

* 请求参数
```ruby
# GET /api/v1.0/inbound_orders/1/picking_infos
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
			"sku_code": "sku001",
			"barcode": "bar001",
			"sku_owner": "sku@owner.com",
			"name": "商品名称 1",
			"foreign_name": "commodity name 1",
			"quantity": 14,
			"operate_infos": [
				{ "shelf_num": "DUS-A-01-01-01", "quantity": 2 },
				{ "shelf_num": "DUS-A-01-01-02", "quantity": 12 }
			]
		},
		{
			"sku_code": "sku002",
			"barcode": "bar002",
			"sku_owner": "sku@owner.com",
			"name": "商品名称 2",
			"foreign_name": "commodity name 2",
			"quantity": 54,
			"operate_infos": [
				{ "shelf_num": "DUS-A-01-02-01", "quantity": 22 },
				{ "shelf_num": "DUS-A-01-02-02", "quantity": 32 },

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
		"Not authorized"
	]
}
```

<h4 id="outbound_orders_wait_to_operate">2.2.6 待取货出库订单列表(操作员手持端)</h4>
| Request | Response |
| :- | :- |
| GET /api/v1.0/outbound_orders/wait_to_operate | 200 OK  |
| Content-Type: application/json | Content-Type: application/json |

* 请求参数
```ruby
# GET /api/v1.0/outboud_orders/wait_to_operate
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
			"batch_num": "OUT201808010001N001", # 系统流水号
			"order_num": "order001",
			"depot_code": "DUS",
			"status": "allocated",
			"outbound_method": "picking",
			"operator": "current@operator.com",
			"created_at": "2018-08-01",
			"updated_at": "2018-08-01",		
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

<h4 id="outbound_orders_picked">2.2.7 出库订单操作(取货完毕)</h4>
| Request | Response |
| :- | :- |
| POST /api/v1.0/outbound_orders/:id/picked | 200 OK  |
| Content-Type: application/json | Content-Type: application/json |

* 请求参数
```ruby
# POST /api/v1.0/inbound_orders/1/picked
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
		"Not authorized"
	]
}
```

<h4 id="outbound_orders_update">2.2.8 出库订单修改</h4>
| Request | Response |
| :- | :- |
| PUT /api/v1.0/outbound_orders/:id/update | 200 OK  |
| Content-Type: application/json | Content-Type: application/json |

* 请求参数
```ruby
# PUT /api/v1.0/inbound_orders/1/update
{
	# 验证请求用户身份
	"access_token": "NSnc8CK3ceqozl8vlwi46A",
	
	# 取消当前出库订单, 新建相同订单号的出库订单(系统流水号不同)
	# 如果当前出库订单已处于取货完毕或之后的状态, 则生成入库批次
	"outbound_skus": [
		{
			"sku_code": "sku001", # 必填, 商品代码
			"barcode": "bar001",  # 必填, 商品条码
			"quantity": 16,  #必填, 出库数量
			"sku_owner": "sku@owner.com"  # 商品所有者, 可不传, 默认为入库预报所属用户
		},
		{
			"sku_code": "sku002", # 必填, 商品代码
			"barcode": "bar002",  # 必填, 商品条码
			"quantity": 16,  #必填, 出库数量
			"sku_owner": "sku@owner.com",  # 商品所有者, 可不传, 默认为入库预报所属用户
		},
		...
	],
	# 下方字段可不传, 默认继承原出库订单信息
	"shpmt_num": "shpmt001",  # 运单号
	"shpmt_product": "DHL",  # 物流产品
	"shpmt_addr_info": {
		"sender": { "country": "DE", ... },  # 发件人地址
		"recipient": { "country": "CN", ... }  # 收件人地址
	}	
}
```
* 响应代码
```ruby
# 认证 access_token 通过后, 返回对应用户的数据
{
	"status": "succ",
	"data": {
		"id": 1,
		"batch_num": "OUT201808010001N001", # 系统流水号
		"order_num": "order001",
		"depot_code": "DUS",
		"status": "new", # new/allocated/picked/printed/sent/cancelled
		"outbound_method": nil, # picking/seeding
		"operator": nil,
		"created_at": "2018-08-01",
		"updated_at": "2018-08-01",
		"outbound_skus": [
			{
				"sku_code": "sku001", 
				"barcode": "bar001",  
				"quantity": 16,  
				"sku_owner": "sku@owner.com"
			},
			{
				"sku_code": "sku002",
				"barcode": "bar002", 
				"quantity": 16, 
				"sku_owner": "sku@owner.com", 
			},
			# ...
		],
		"shpmt_num": "shpmt001",  # 运单号
		"shpmt_product": "DHL",  # 物流产品
		"shpmt_addr_info": {
			"sender": { "country": "DE", ... },  # 发件人地址
			"recipient": { "country": "CN", ... }  # 收件人地址
		}			
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

<h4 id="outbound_orders_cancel">2.2.9 出库订单取消</h4>
| Request | Response |
| :- | :- |
| POST/api/v1.0/outbound_orders/:id/cancel | 200 OK  |
| Content-Type: application/json | Content-Type: application/json |

* 请求参数
```ruby
# POST /api/v1.0/inbound_orders/1/cancel
{
	# 验证请求用户身份
	"access_token": "NSnc8CK3ceqozl8vlwi46A"
	
	# 取消当前出库订单
	# 如果当前出库订单已处于取货完毕或之后的状态, 则生成入库批次
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
		"Not authorized"
	]
}
```

<h4 id="outbound_orders_allocate_method">2.2.10 出库订单选择取货方式</h4>
| Request | Response |
| :- | :- |
| POST/api/v1.0/outbound_orders/allocate_method | 200 OK  |
| Content-Type: application/json | Content-Type: application/json |

* 请求参数
```ruby
# POST /api/v1.0/inbound_orders/allocate_method
{
	# 验证请求用户身份
	"access_token": "NSnc8CK3ceqozl8vlwi46A"
	
	"ids": [1, 2], # 出库订单id, Array类型
	"outbound_method": "picking", # picking/seeding, 目前先支持picking方式
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
		"Not authorized",
		"OutboundOrder with id 1 cannot be allocated"
	]
}
```

<h4 id="outbound_orders_batch_cancel">2.2.11 出库订单取消(批量)</h4>
| Request | Response |
| :- | :- |
| POST /api/v1.0/outbound_orders/batch_cancel | 200 OK  |
| Content-Type: application/json | Content-Type: application/json |

* 请求参数
```ruby
# POST /api/v1.0/inbound_orders/batch_cancel
{
	# 验证请求用户身份
	"access_token": "NSnc8CK3ceqozl8vlwi46A"
	"ids": [ 1, 2, 3 ]
	
	# 取消当前出库订单
	# 如果当前出库订单已处于取货完毕或之后的状态, 则生成入库批次, 多个订单则合并成一个入库批次
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
		"Not authorized"
	]
}
```

<h4 id="outbound_orders_mypost4u_parcel_confirmation_logs">2.2.12 Mypost4u包裹确认日志</h4>

| Request | Response |
| :- | :- |
| GET /api/v1.0/outbound_orders/mypost4u_parcel_confirmation_logs | 200 OK  |
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
		"outbound_num": "OUT201808010001",  # 出库预报号
		"batch_num": "OUT201808010001N001", # 批次号/系统流水号(唯一)
		"order_num": "order001", # 订单号
		"parcel_num": "DE123456...", # mypost4u包裹号
		"mp4_confirmed_at_gteq": "2019-02-18" ,  # mypost4u 包裹确认时间
		"mp4_confirmed_at_lteq": "2019-02-19"
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
			"id": 1,
			"outbound_num": "OUT201808010001",  # 出库预报号
			"batch_num": "OUT201808010001N001", # 系统流水号
			"order_num": "order001", # 订单号
			"parcel_num": "DE123456...", # mypost4u包裹号
			"mp4_confirmed_at": "2019-02-18 12:00:00", # mypost4u 包裹确认时间		
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


<h3 id="scanning">2.3 扫描</h3>

<h4 id="scanning_create_mypost4u_parcel">2.3.1 扫描流水号(批次号)创建Mypost4u包裹</h4>

| Request | Response |
| :- | :- |
| POST /api/v1.0/scanning/create_mypost4u_parcel | 200 OK  |
| Content-Type: application/json | Content-Type: application/json |

* 请求参数
```ruby
# POST /api/v1.0/scanning/create_mypost4u_parcel
{
	# 验证请求用户身份
	"access_token": "NSnc8CK3ceqozl8vlwi46A",
	"batch_num": "OUT201808010001N001",
	"weight": 10,
	"length": 50,
	"width": 50,
	"height": 50
}
```
* 响应代码
```ruby
# 认证 access_token 通过后, 返回对应用户的数据
{
	"status": "succ",
	# 扫描打单的文件链接 pdf/html
	"posting_url": "http://www.mypost4u.com/pages/DE180131053728CN02YZE_posting.html",
	"shipment_url": "http://www.mypost4u.com/pages/DE180131053728CN02YZE_shipment.html"
}
# OR 认证失败
{
	"status": "fail",
	"reason": [ 
		"Invalid access token",
		"batch_num not found"
	]
}
```



<h3 id="statistics">2.4 统计</h3>

<h4 id="statistics_outbound_orders_count">2.4.1 出库订单数量</h4>

| Request | Response |
| :- | :- |
| GET /api/v1.0/statistics/outbound_orders/count | 200 OK  |
| Content-Type: application/json | Content-Type: application/json |

* 请求参数
```ruby
# GET /api/v1.0/statistics/outbound_orders/count
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
	"new_count": 100,  # 未处理的订单数量
	"in_process_count": 50,  # 处理中的订单数量(开始处理直到打单完成前的订单)
	"wait_to_mp4_confirm_count": 20  # 待确认的订单数量
}
# OR 认证失败
{
	"status": "fail",
	"reason": [ 
		"Invalid access token"
	]
}
```

<h4 id="statistics_outbound_orders_trend">2.4.2 出库订单趋势</h4>

| Request | Response |
| :- | :- |
| GET /api/v1.0/statistics/outbound_orders/trend | 200 OK  |
| Content-Type: application/json | Content-Type: application/json |

* 请求参数
```ruby
# GET /api/v1.0/statistics/outbound_orders/trend
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
	"trend": [10,20, ..., 30], # 最近30天内出库订单量趋势, 数组, 每天一个数值, 由早到晚按次序排列
	"ranking": [
		{ "rank": 1, "count": 99, "account": "sub_conginor_1@email.com"},
		{ "rank": 2, "count": 90, "account": "sub_conginor_2@email.com"},
		{ "rank": 3, "count": 67, "account": "sub_conginor_3@email.com"},
		{ "rank": 4, "count": 54, "account": "sub_conginor_4@email.com"},
		{ "rank": 5, "count": 25, "account": "sub_conginor_5@email.com"},
		{ "rank": 6, "count": 88, "account": "rest"}
	] # 最近30天出库量最大的5个子货主 + 其他货主(超过5个货主时)的出库量统计
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
