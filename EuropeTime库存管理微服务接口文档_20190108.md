# 库存管理微服务接口文档

**文档信息**

| 系统名称 | 库存管理微服务 |
| :- | :- |
| 生产环境 | [https://micro_service/production/et_inventory/api/v1.0/](https://www.mypost4u.com/rest-api/v2.1/) |
| 测试环境 | http://47.96.153.174:9050/                                                   |
| 数据协议 | HTTP, JSON, SSL                                                                                    |
| 联系人 | chang.cai@quaie.com ; kater.jiang@quaie.com ; amy.wang@quaie.com ; samuel.uling@quaie.com    |

**版本记录**

| 版本编号 | 版本日期  | 修改者 | 说明 | 文件名 |
| :- | :- | :- | :- | :- |
| V1.0 | 2018/06/15 | 蔡畅 | 初稿 ||
| V1.1 | 2018/09/21 | 蔡畅 | 增加库存操作接口(2.7.1~2.7.6)  |        |
| V1.2 | 2018/10/12 | 蔡畅 | 各接口根据用户角色添加权限控制,  接口2.1.1增加查询条件和数据分页返回| |
| V1.3 | 2018/10/24 | 蔡畅 | 增加库存操作日志查询接口 2.8.1, 2.8.2 | |
| V1.4 | 2018/11/09 | 蔡畅 | 更新库存操作接口(2.7.1~2.7.6), 增加库存登记操作, 登记时增加库存, 上架只分配货架号不再增加库存 |
| V1.5 | 2018/11/16 | 蔡畅 | 增加统计相接口 2.9.1~2.9.3 | | 
| V1.6 | 2019/01/08 | 蔡畅 | 接口2.4.1 库存列表返回值增加 outbound_last_month 字段; 增加接口 2.4.7 库存简易信息(右上) | |

**版权声明**

Copyright © 2018上海诗禹信息技术有限公司 All Rights Reserved

**目录**

[1. 介绍](#introduction)
>[1.1 文档目的](#purpose)

[2. 接口](#api)
>[2.1. 仓库管理](#depots)
>>[2.1.1 仓库列表查询](#depots_index)

>>[2.1.2 仓库单例查询](#depots_show)

>>[2.1.3 仓库创建](#depots_create)

>>[2.1.4 仓库信息更新](#depots_update)

>>[2.1.5 库区创建](#depots_create_depot_areas)

>>[2.1.6 仓库删除](#depots_delete)

>>[2.1.7 库区删除](#depot_areas_delete)

>[2.2 货架管理](#shelves)
>>[2.2.1 货架查询](#shelves_index)

>>[2.2.2 货架创建](#shelves_create)

>>[2.2.3 货架创建(批量)](#shelves_batch_create)

>>[2.2.4 货架参数验证](#shelves_validate)

>>[2.2.5 货架信息更新](#shelves_update)

>>[2.2.6 货架单元查询](#shelf_infos_index)

>>[2.2.7 货架删除](#shelves_delete)

>[2.3 货架单元(隔间/层)管理](#shelf_infos)
>>[2.3.1 货架单元信息更新](#shelf_infos_update)

>[2.4 库存管理](#inventories)
>>[2.4.1 库存列表](#inventories_index)

>>[2.4.2 库存批次查询](#inventory_infos_index)

>>[2.4.3 上月出库数量查询](#outbound_last_month)

>>[2.4.4 获取待解冻日志列表](#inventories_wait_to_unfreeze_logs)

>>[2.4.5 库存冻结](#inventories_inventory_freeze)

>>[2.4.6 库存解冻](#inventory_operation_logs_inventory_unfreeze)

>>[2.4.7 库存简易信息(右上)](#inventories_show_top_right)

>[2.5 库存任务管理](#inventory_tasks)
>>[2.5.1 库存任务查询](#inventory_tasks_index)

>>[2.5.2 库存任务详情查询](#inventory_tasks_show)

>>[2.5.3 创建库存转移任务](#inventory_tasks_create_transfer)

>>[2.5.4 完成库存转移任务(系统调用)](#inventory_tasks_finish_transfer)

>>[2.5.5 取消库存转移任务(系统调用)](#inventory_tasks_cancel_transfer)

>>[2.5.6 创建库存盘点任务](#inventory_tasks_create_check)

>>[2.5.7 更新库存盘点任务](#inventory_tasks_update_check)

>>[2.5.8 完成库存盘点任务](#inventory_tasks_finish_check)

>>[2.5.9 取消库存(盘点)任务](#inventory_tasks_cancel)

>>[2.5.10 库存任务分配/更新](#inventory_tasks_allocate)

>[2.6 库存设置管理](#inventory_settings)
>>[2.6.1 库存全局设置查询](#inventory_settings_index)

>>[2.6.2 库存全局设置更新](#inventory_settings_update)

>>[2.6.3 库存设置(全局余量预警阈值)](#global_caution_threshold_setting)

>>[2.6.4 库存设置(个别余量预警阈值)](#single_caution_threshold_setting)

>[2.7 库存操作](#inventory_operation)

>>[2.7.1 库存增加(入库登记)](#inventory_register_operation)

>>[2.7.2 库存减少(入库登记取消)](#inventory_unregister_operation)

>>[2.7.3 库存调整(库存上架)](#inventory_mount_operation)

>>[2.7.4 库存减少(取货下架)](#inventory_outbound_operation)

>>[2.7.5 生成待取货信息(冻结取货库存)](#inventory_get_picking_infos)

>>[2.7.6 取消待取货信息(解冻取货库存)](#inventory_remove_picking_infos)

>>[2.7.7 库存信息查询(单个)](#inventory_search)

>>[2.7.8 库存减少(问题sku登记)](#inventory_register_decrease_operation)

>[2.8 库存操作日志](#inventory_operation_logs)

>>[2.8.1 库存操作日志列表(通用)](#inventory_operation_logs_index)

>>[2.8.2 单个库存的操作日志(简易)](#inventories_operation_logs)

>[2.9 统计](#statistics)

>>[2.9.1 库存数量统计](#statistics_inventories_count)

>>[2.9.2 库存盘点任务数量统计](#statistics_inventory_check_tasks_count)

>>[2.9.3 绩效统计](#statistics_performance_ranking)

[3. 附录](#appendix)
>[3.1 数据查询规则(FilterRules)](#filter_rules)

>[3.2 接口消息语种选择(Locale)](#locale)

<h2 id="introduction">1. 介绍</h2>
本文档是详细描述库存管理微服务的API接口文档。文档共分为三部分：介绍，接口，附录。其中第二部分接口是本文档的正文部分，明确了本系统所提供的接口服务类型及请求与响应格式。

<h3 id="purpose">1.1 文档目的</h3>
撰写本文档的目的是指导代理服务器与微服务的对接开发，帮助项目经理了解系统功能。
本文档同样适用于商户以及合作伙伴。

<h2 id="api">2. 接口</h2>

<h3 id="depots">2.1 仓库管理</h3>

<h4 id="depots_index">2.1.1 仓库列表查询</h4>

| Request | Response |
| :- | :- |
| GET /api/v1.0/depots | 200 OK  |
| Content-Type: application/json | Content-Type: application/json |

* 请求参数
```ruby
# 验证请求用户身份
{
	"access_token": "NSnc8CK3ceqozl8vlwi46A",
	
	"page": 1,
	"per_page": 10,
	# 参数查询规则请参照 FilterRules
	"q": {
		"name": "浦东仓库", # 仓库名称
		"depot_code": "PD",  # 仓库代码
		"country": "中国",
		"province": "上海",
		"city": "上海市",
		"district": "浦东新区",
		"street": "某某路",
		"street_number": "1",
		"house_number": "110",
		"postcode": "200120",
		"telephone": "12312341234"
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
			"name": "浦东仓库",
			"depot_code": "PD",
			"depot_areas": [
				{ "id": 11, "areas_code": "A" },
				{ "id": 12, "areas_code": "B" }
				# ...
			],
			"country": "中国",
			"province": "上海",
			"city": "上海市",
			"district": "浦东新区",
			"street": "某某路",
			"street_number": "1",
			"house_number": "110",
			"postcode": "200120",
			"telephone": "12312341234",
			"can_delete": false
		},
		{
			"id": 2,
			"name": "Hamburger",
			"depot_code": "HAM",
			"depot_areas": [
				{ "id": 21, "areas_code": "A" },
				{ "id": 22, "areas_code": "B" }
				# ...
			],
			"country": "de",
			"province": "Hamburger",
			"city": "Hamburger",
			"district": "Hamburger",
			"street": "Hamburger",
			"street_number": "1",
			"house_number": "110",
			"postcode": "20095",
			"telephone": "12312341234",
			"can_delete": false
		}
		# ...
	],
	"page": 1,
	"per_page": 10,
	"count": 20	
}
# OR 认证失败
{
	"status": "fail",
	"reason": [ "Invalid access token" ]
}
```

<h4 id="depots_show">2.1.2 仓库单例查询</h4>

| Request | Response |
| :- | :- |
| GET /api/v1.0/depots/:id/show | 200 OK  |
| Content-Type: application/json | Content-Type: application/json |

* 请求参数
```ruby
# 验证请求用户身份
{
	"access_token": "NSnc8CK3ceqozl8vlwi46A"
}
```
* 响应代码
```ruby
# GET /api/v1.0/depots/1/show
# 认证 access_token 通过后, 返回对应用户的数据
{
	"status": "succ",
	"data": 
	{
		"id": 1,
		"name": "浦东仓库",
		"depot_code": "PD",
		"depot_areas": [
			{ "id": 11, "areas_code": "A" },
			{ "id": 12, "areas_code": "B" }
			# ...
		],
		"country": "中国",
		"province": "上海",
		"city": "上海市",
		"district": "浦东新区",
		"street": "某某路",
		"street_number": "1",
		"house_number": "110",
		"postcode": "200120",
		"telephone": "12312341234",
		"can_delete": false
	}
}
# OR
{
	"status": "fail",
	"reason": [ 
		"Invalid access token",
		"Depot with id 1 not found"
	]
}
```

<h4 id="depots_create">2.1.3 仓库创建</h4>

| Request | Response |
| :- | :- |
| POST /api/v1.0/depots/create | 200 OK |
| Content-Type: application/json | Content-Type: application/json |

* 请求参数
```ruby
{
	# 验证请求用户身份
	"access_token": "4E0_W8z4jCdOVxf3DgVuARejvR8T8g...", 

	# 仓库参数
	"name": "浦东仓库", # 必填, 仓库名
	"depot_code": "PD", # 必填, 仓库代码, 创建后不可修改
	"country": "中国", # 必填
	"province": "上海",
	"city": "上海市", # 必填
	"district": "浦东新区",
	"street": "某某路",
	"street_number": "1",
	"house_number": "110",
	"postcode": "200120",
	"telephone": "12312341234"
}
```
* 响应代码
```ruby
# 创建成功
{
	"status": "succ",
	"data": {
		"id": 1,
		"name": "浦东仓库", 
		"depot_code": "PD", 
		"depot_areas": [],
		"country": "中国", 
		"province": "上海",
		"city": "上海市", 
		"district": "浦东新区",
		"street": "某某路",
		"street_number": "1",
		"house_number": "110",
		"postcode": "200120",
		"telephone": "12312341234",
		"can_delete": true
	}
}
# OR 创建失败
{
	"status": "fail",
	"reason": [
		"Name can't be blank",
		"Country can't be blank"
	]
}
```

<h4 id="depots_update">2.1.4 仓库信息更新</h4>

| Request | Response |
| :- | :- |
| PUT /api/v1.0/depots/:id/update | 200 OK |
| Content-Type: application/json | Content-Type: application/json |

* 请求参数
```ruby
# PUT /api/v1.0/depots/1/update
{
	# 验证请求用户身份
	"access_token": "4E0_W8z4jCdOVxf3DgVuARejvR8T8g...", 

	# 仓库参数
	"name": "浦东仓库2", # 必填, 仓库名
	# depot_code 不能修改
	"country": "中国", # 必填
	"province": "上海",
	"city": "上海市", # 必填
	"district": "浦东新区",
	"street": "某某路",
	"street_number": "1",
	"house_number": "110",
	"postcode": "200120",
	"telephone": "12312341234"
}
```
* 响应代码
```ruby
# 更新成功
{
	"status": "succ",
	"data": {
		"id": 1,
		"name": "浦东仓库2", 
		"depot_code": "PD", 
		"depot_areas": [],
		"country": "中国", 
		"province": "上海",
		"city": "上海市", 
		"district": "浦东新区",
		"street": "某某路",
		"street_number": "1",
		"house_number": "110",
		"postcode": "200120",
		"telephone": "12312341234",
		"can_delete": false
	}
}
# OR 更新失败
{
	"status": "fail",
	"reason": [
		"Name can't be blank",
		"Country can't be blank"
	]
}
```

<h4 id="depots_create_depot_areas">2.1.5 库区创建</h4>

| Request | Response |
| :- | :- |
| POST /api/v1.0/depots/:id/create_depot_areas | 200 OK |
| Content-Type: application/json | Content-Type: application/json |

* 请求参数
```ruby
# POST /api/v1.0/depots/1/create_depot_areas
{
	# 验证请求用户身份
	"access_token": "4E0_W8z4jCdOVxf3DgVuARejvR8T8g...", 

	"area_codes": [
		"A", "B"  #...
	]
}
```
* 响应代码
```ruby
# 创建成功
{
	"status": "succ",
	"data": [
		{
			"id": 1,
			"area_code": "A",
			"can_delete": true
		},
		{
			"id": 2,
			"area_code": "B",
			"can_delete": true
		}
		# ...
	]
}
# OR 创建失败
{
	"status": "fail",
	"reason": [ 
		"Area code A has been taken" 
	]
}
```

<h4 id="depots_delete">2.1.6 仓库删除</h4>

| Request | Response |
| :- | :- |
| POST /api/v1.0/depots/:id/delete | 200 OK |
| Content-Type: application/json | Content-Type: application/json |

* 请求参数
```ruby
# DELETE /api/v1.0/depots/1/delete
{
	# 验证请求用户身份
	"access_token": "4E0_W8z4jCdOVxf3DgVuARejvR8T8g..."
}
```
* 响应代码
```ruby
# 删除成功
{
	"status": "succ"
}
# OR 删除失败
{
	"status": "fail",
	"reason": [ 
		"Depot with id 1 cannot be deleted" 
	]
}
```

<h4 id="depot_areas_delete">2.1.7 库区删除</h4>

| Request | Response |
| :- | :- |
| POST /api/v1.0/depot_areas/:id/delete | 200 OK |
| Content-Type: application/json | Content-Type: application/json |

* 请求参数
```ruby
# DELETE /api/v1.0/depot_areas/1/delete
{
	# 验证请求用户身份
	"access_token": "4E0_W8z4jCdOVxf3DgVuARejvR8T8g..."
}
```
* 响应代码
```ruby
# 删除成功
{
	"status": "succ"
}
# OR 删除失败
{
	"status": "fail",
	"reason": [ 
		"DepotArea with id 1 cannot be deleted" 
	]
}
```

<h3 id="shelves">货架管理</h3>

<h4 id="shelves_index">2.2.1 货架查询</h4>

| Request | Response |
| :- | :- |
| GET /api/v1.0/shelves | 200 OK |
| Content-Type: application/json | Content-Type: application/json |

* 请求参数
```ruby
{
	# 验证请求用户身份
	"access_token": "4E0_W8z4jCdOVxf3DgVuARejvR8T8g...", 

	"page": 1,
	"per_page": 10,
	# 参数查询规则请参照 FilterRules
	"q": {
		"depot_code": "PD",  # 仓库代码
		"area_code": "A",  # 库区代码
		"seq": 1,	# 货架序号
		"column_number": 10, # 货架隔间数
		"row_number": 3, # 货架层数
		"spec": "L"  # 货架规格
	}
}
```
* 响应代码
```ruby
{
	"status": "succ",
	"data": [
		{
			"id": 2,
			"depot_id": 5,
			"depot_area_id": 6,
			"depot_code": "PD",
			"area_code": "A",
			"seq": 1,
			"column_number": 10,
			"row_number": 3,
			"spec": "L",
			"can_delete": false
		}
		# ...
	],
	"page": 1,
	"per_page": 10,
	"count": 20
}
# OR
{
	"status": "fail",
	"reason": [ "Invalid access token" ]
}
```

<h4 id="shelves_create"> 2.2.2 货架创建</h4>

| Request | Response |
| :- | :- |
| POST /api/v1.0/shelves/create | 200 OK |
| Content-Type: application/json | Content-Type: application/json |

* 请求参数
```ruby
{
	# 验证请求用户身份
	"access_token": "4E0_W8z4jCdOVxf3DgVuARejvR8T8g...", 

	"depot_id": 1,  # 仓库 ID
	"depot_area_id": 11, # 库区 ID
	"column_number": 10, # 货架隔间数
	"row_number": 2, # 货架层数
	"spec": "L" # 货架规格标识
}
```
* 响应代码
```ruby
# 创建成功
{
	"status": "succ",
	"data": {
		"id": 2,
		"depot_id": 1,
		"depot_area_id": 11,
		"depot_code": "DU",
		"area_code": "B",
		"seq": 2,
		"column_number": 10,
		"row_number": 2,
		"spec": "L",
		"can_delete": 
	}
}
# OR
{
	"status": "fail",
	"reason": [ 
		"Invalid access token",
		"Depot with id 1 not found",
		"Not authorized",
		"DepotArea with id 11 not found",
		"column_number must be greater than 0" 
	]
}
```

<h4 id="shelves_batch_create">2.2.3 货架创建(批量)</h4>

| Request | Response |
| :- | :- |
| POST /api/v1.0/shelves/batch_create | 200 OK |
| Content-Type: application/json | Content-Type: application/json |

* 请求参数
```ruby
{
	# 验证请求用户身份
	"access_token": "4E0_W8z4jCdOVxf3DgVuARejvR8T8g...", 
	
	"resource": [
		{	# 货架 1
			"depot_id": 1,  # 仓库 ID
			"depot_area_id": 11, # 库区 ID
			"column_number": 10, # 货架隔间数
			"row_number": 2, # 货架层数
			"spec": "L" # 货架规格标识
		},
		{	# 货架 2
			"depot_id": 1,  # 仓库 ID
			"depot_area_id": 11, # 库区 ID
			"column_number": 11, # 货架隔间数
			"row_number": 2, # 货架层数
			"spec": "M" # 货架规格标识
		}
		# ...
	]
}
```
* 响应代码
```ruby
# 创建成功
{
	"status": "succ",
	"data": [
		{
			"id": 2,
			"depot_id": 1,
			"depot_area_id": 11,
			"depot_code": "DU",
			"area_code": "B",
			"seq": 2,
			"column_number": 10,
			"row_number": 2,
			"spec": "L",
			"can_delete": true
		},
		{
			"id": 3,
			"depot_id": 1,
			"depot_area_id": 11,
			"depot_code": "DU",
			"area_code": "B",
			"seq": 3,
			"column_number": 11,
			"row_number": 2,
			"spec": "M",
			"can_delete": true
		}
		# ...
	]
}
# OR
{
	"status": "fail",
	"reason": [ 
		"Invalid access token",
		"resource must be an Array",
		"Invalid params, index 1"
	]
}
```

<h4 id="shelves_validate">2.2.4 货架参数验证</h4>

| Request | Response |
| :- | :- |
| POST /api/v1.0/shelves/validate | 200 OK |
| Content-Type: application/json | Content-Type: application/json |

* 请求参数
```ruby
{
	# 验证请求用户身份
	"access_token": "4E0_W8z4jCdOVxf3DgVuARejvR8T8g...", 

	"depot_id": 1,  # 仓库 ID
	"depot_area_id": 11, # 库区 ID
	"column_number": 10, # 货架隔间数
	"row_number": 2, # 货架层数
	"spec": "L" # 货架规格标识
}
```
* 响应代码
```ruby
# 验证成功
{
	"status": "succ",
}
# OR
{
	"status": "fail",
	"reason": [ 
		"Invalid access token",
		"Depot with id 1 not found",
		"Not authorized",
		"DepotArea with id 11 not found",
		"column_number must be greater than 0" 
	]
}
```

<h4 id="shelves_update">2.2.5 货架信息更新</h4>

| Request | Response |
| :- | :- |
| PUT /api/v1.0/shelves/:id/update | 200 OK |
| Content-Type: application/json | Content-Type: application/json |

* 请求参数
```ruby
# PUT /api/v1.0/shelves/2/update
{
	# 验证请求用户身份
	"access_token": "4E0_W8z4jCdOVxf3DgVuARejvR8T8g...", 

	"column_number": 15, # 货架隔间数
	"row_number": 3, # 货架层数
	"spec": "M" # 货架规格标识
}
```
* 响应代码
```ruby
# 更新成功
{
	"status": "succ",
	"data": {
		"id": 2,
		"depot_id": 1,
		"depot_area_id": 11,
		"depot_code": "DU",
		"area_code": "B",
		"seq": 2,
		"column_number": 15,
		"row_number": 3,
		"spec": "M",
		"can_delete": false
	}
}
# OR 更新失败
{
	"status": "fail",
	"reason": [ 
		"Invalid access token",
		"Depot with id 1 not found",
		"Not authorized",
		"DepotArea with id 11 not found",
		"column_number must be greater than 0" 
	]
}
```

<h4 id="shelf_infos_index">2.2.6 货架单元查询</h4>

| Request | Response |
| :- | :- |
| GET /api/v1.0/shelves/:id/shelf_infos | 200 OK |
| Content-Type: application/json | Content-Type: application/json |

* 请求参数
```ruby
# GET /api/v1.0/shelves/2/shelf_infos
{
	# 用于验证请求用户身份
	"access_token": "4E0_W8z4jCdOVxf3DgVuARejvR8T8g..."
}
```
* 响应代码
```ruby
{
	"status": "succ",
	"data": [
		{
			"id": 31,
			"shelf_id": 6,
			"shelf_num": "DD-A-01-01-01",
			"column": 1,
			"row": 1,
			"spec": "M"
		},
		{
			"id": 32,
			"shelf_id": 6,
			"shelf_num": "DD-A-01-01-02",
			"column": 1,
			"row": 2,
			"spec": "M"
		}
		# ...
	]
}
# OR
{
	"status": "fail",
	"reason": [ 
		"Invalid access token",
		"Shelf with id 2 not found",
		"Not authorized"
	]
}
```

<h4 id="shelves_delete">2.2.7 货架删除</h4>

| Request | Response |
| :- | :- |
| POST /api/v1.0/shelves/:id/delete | 200 OK |
| Content-Type: application/json | Content-Type: application/json |

* 请求参数
```ruby
# DELETE /api/v1.0/shelves/1/delete
{
	# 验证请求用户身份
	"access_token": "4E0_W8z4jCdOVxf3DgVuARejvR8T8g..."
}
```
* 响应代码
```ruby
# 删除成功
{
	"status": "succ"
}
# OR 删除失败
{
	"status": "fail",
	"reason": [ 
		"Shelf with id 1 cannot be deleted" 
	]
}
```

<h3 id="shelf_infos">2.3 货架单元(隔间/层)管理</h3>

<h4 id="shelf_infos_update">2.3.1 货架单元信息更新</h4>

| Request | Response |
| :- | :- |
| PUT /api/v1.0/shelf_infos/:id/update | 200 OK |
| Content-Type: application/json | Content-Type: application/json |

* 请求参数
```ruby
# PUT /api/v1.0/shelf_infos/32/update
{
	# 用于验证请求用户身份
	"access_token": "4E0_W8z4jCdOVxf3DgVuARejvR8T8g...",
	
	"spec": "S"
}
```
* 响应代码
```ruby
{
	"status": "succ",
	"data": {
		"id": 32,
		"shelf_id": 6,
		"shelf_num": "DD-A-01-01-02",
		"column": 1,
		"row": 2,
		"spec": "S" # M => S
	}
}
# OR
{
	"status": "fail",
	"reason": [ 
		"Invalid access token",
		"ShelfInfo with id 32 not found",
		"Not authorized"
	]
}
```

<h3 id="inventories">2.4 库存管理</h3>

<h4 id="inventories_index">2.4.1 库存列表</h4>

| Request | Response |
| :- | :- |
| GET /api/v1.0/inventories | 200 OK |
| Content-Type: application/json | Content-Type: application/json |

* 请求参数
```ruby
{
	# 用于验证请求用户身份
	"access_token": "4E0_W8z4jCdOVxf3DgVuARejvR8T8g...",
	
	"page": 1,
	"per_page": 10,
	# 参数查询规则请参照 FilterRules
	"q": {
		"sku_owner": "admin@inventory.com", # 货主, 可不传值, 默认返回请求用户对应的库存信息
		"sku_code": "sku001", # 商品代码
		"barcode": "bar001", # 商品条码
		"name": "商品名称", 
		"foreign_name": "sku_name",
		"abc_category": "A", # 商品货值等级
		"quantity": 100, # 库存总数
		"available_quantity": 100, # 库存可用数量
		"frozen_quantity": 0, # 库存冻结数量
		"created_at": "2018-06-26", # 库存信息创建日期
		"updated_at": "2018-06-26" # 库存信息更新日期
	}
}
```
* 响应代码
```ruby
{
	"status": "succ",
	"data": [
		{
			"id": 1,
			"sku_owner": "admin@inventory.com",
			"sku_code": "sku001",
			"barcode": "bar001", 
			"name": "商品名称", 
			"foreign_name": "sku_name",
			"abc_category": "A", 
			"quantity": 100, 
			"available_quantity": 100, 
			"frozen_quantity": 0,
			"caution_threshold": 10,  # 库存预警阈值
			"outbound_last_month": 233, # -- v1.6 --, 上个月消耗库存数
			"created_at": "2018-06-26", 
			"updated_at": "2018-06-26"		
		},
		{
			"id": 2,
			# ...
		}
		# ...
	],
	"page": 1,
	"per_page": 10,
	"count": 21
}
# OR
{
	"status": "fail",
	"reason": [ "Invalid access token" ]
}
```

<h4 id="inventory_infos_index">2.4.2 库存批次查询</h4>

| Request | Response |
| :- | :- |
| GET /api/v1.0/inventories/:id/inventory_infos | 200 OK |
| Content-Type: application/json | Content-Type: application/json |

* 请求参数
```ruby
# GET /api/v1.0/inventories/1/inventory_infos
{
	# 用于验证请求用户身份
	"access_token": "4E0_W8z4jCdOVxf3DgVuARejvR8T8g..."
}
```
* 响应代码
```ruby
{
	"status": "succ",
	"data": [
		{
			"id": 1,
			"inventory_id": 1, # 库存总表id
			"batch_num": "20160625", # 批次号
			"quantity": 50, 
			"available_quantity": 50, 
			"frozen_quantity": 0, 
			"shelf_num": "DP-A-01-01-01",
			"depot_code": "DP",
			"production_date": "2018-01-01",
			"expiry_date": "2019-01-01",
			"created_at": "2018-06-25"		
		},
		{
			"id": 2,
			"inventory_id": 1, # 库存总表id
			"batch_num": "20160626", # 批次号
			"quantity": 50, 
			"available_quantity": 50, 
			"frozen_quantity": 0, 
			"shelf_num": "DP-A-01-04-03",
			"depot_code": "DP",
			"production_date": "2018-01-01",
			"expiry_date": "2019-01-01",
			"created_at": "2018-06-26"	
		}
	],
	"page": 1,
	"per_page": 10,
	"count": 21
}
# OR
{
	"status": "fail",
	"reason": [ 
		"Invalid access token",
		"Inventory with id 1 not found"
	]
}
```

<h4 id="outbound_last_month">2.4.3 上月出库数量查询</h4>

| Request | Response |
| :- | :- |
| GET /api/v1.0/inventories/:id/outbound_last_month | 200 OK |
| Content-Type: application/json | Content-Type: application/json |

* 请求参数
```ruby
# GET /api/v1.0/inventories/1/outbound_last_month
{
	# 用于验证请求用户身份
	"access_token": "4E0_W8z4jCdOVxf3DgVuARejvR8T8g..."
}
```
* 响应代码
```ruby
{
	"status": "succ",
	"data": 666, # 目前还没做出入库模块, 无法统计, 此处直接返回固定值
}
# OR
{
	"status": "fail",
	"reason": [ 
		"Invalid access token",
		"Inventory with id 1 not found"
	]
}
```

<h4 id="inventories_wait_to_unfreeze_logs">2.4.4 获取待解冻日志列表</h4>

| Request | Response |
| :- | :- |
| GET /api/v1.0/inventories/:id/wait_to_unfreeze_logs | 200 OK |
| Content-Type: application/json | Content-Type: application/json |

* 请求参数
```ruby
# GET /api/v1.0/inventories/1/wait_to_unfreeze_logs
{
	# 用于验证请求用户身份
	"access_token": "4E0_W8z4jCdOVxf3DgVuARejvR8T8g..."
}
```
* 响应代码
```ruby
{
	"status": "succ",
	"data": [
		# 返回待处理的冻结日志信息
		{
			"id": 1,
			"operation": "freeze",
			"sku_code": "sku1t",
			"barcode": "bar1t",
			"sku_owner": "sku_owner",
			"batch_num": "batch001",
			"shelf_num": "SD-A-01-01-01",
			"quantity": 100,
			"remark": "破损",
			"operator": "sku_owner",
			"created_at: "2099-12-31"
		},
		# ...
	]
}
# OR
{
	"status": "fail",
	"reason": [ 
		"Invalid access token",
		"Inventory with id 1 not found"
	]
}
```

<h4 id="inventories_inventory_freeze">2.4.5 库存冻结</h4>

| Request | Response |
| :- | :- |
| POST /api/v1.0/inventories/:id/inventory_freeze | 200 OK |
| Content-Type: application/json | Content-Type: application/json |

* 请求参数
```ruby
# POST /api/v1.0/inventories/1/inventory_freeze
{
	# 用于验证请求用户身份
	"access_token": "4E0_W8z4jCdOVxf3DgVuARejvR8T8g..."
	
	"batch_num": "batch001", # 库存批次号, 冻结指定批次时填写, 选填, 留空则默认选择全部可用批次
	"shelf_num": "SD-A-01-01-01", # 货架号, 冻结指定货架号时填写, 选填, 留空则默认选择全部可用货架
	"freeze_quantity": 100, # 冻结库存数量, 选填, 留空则默认冻结全部可用数量
	"freeze_reason": "破损" # 冻结原因, 选填
}
```
* 响应代码
```ruby
{
	"status": "succ",
	"data": [
		# 返回待处理的冻结日志信息
		{
			"id": 1,
			"operation": "freeze",
			"sku_code": "sku1t",
			"barcode": "bar1t",
			"sku_owner": "sku_owner",
			"batch_num": "batch001",
			"shelf_num": "SD-A-01-01-01",
			"quantity": 100,
			"remark": "破损",
			"operator": "sku_owner",
			"created_at: "2099-12-31"
		},
		# ...
	]
}
# OR
{
	"status": "fail",
	"reason": [ 
		"Invalid access token",
		"Batch num not found",
		"Shelf num not found",
		"Freeze quantity must be less than or equal to available quantity"
	]
}
```

<h4 id="inventory_operation_logs_inventory_unfreeze">2.4.6 库存解冻</h4>

| Request | Response |
| :- | :- |
| POST /api/v1.0/inventory_operation_logs/:id/inventory_unfreeze | 200 OK |
| Content-Type: application/json | Content-Type: application/json |

* 请求参数
```ruby
# POST /api/v1.0/inventory_operation_logs/1/inventory_unfreeze
# 请求URL中的 :id 为冻结日志 ID
{
	# 用于验证请求用户身份
	"access_token": "4E0_W8z4jCdOVxf3DgVuARejvR8T8g..."
}
```
* 响应代码
```ruby
{
	"status": "succ",
}
# OR
{
	"status": "fail",
	"reason": [ 
		"Invalid access token",
		"InventoryOperationLog with id 1 not found"
	]
}
```

<h4 id="inventories_show_top_right">2.4.7 单个库存信息</h4>

| Request | Response |
| :- | :- |
| GET /api/v1.0/inventories/:id/show_top_right | 200 OK |
| Content-Type: application/json | Content-Type: application/json |

* 请求参数
```ruby
# GET /api/v1.0/inventories/1/show_top_right
{
	# 用于验证请求用户身份
	"access_token": "4E0_W8z4jCdOVxf3DgVuARejvR8T8g..."
}
```
* 响应代码
```ruby
{
	"status": "succ",
	"data": {
		"quantity": 100, 
		"depot_code": "DUS", # -- v1.6 --, 仓库代码, 取最近库存批次的仓库代码 
		"caution_threshold": 10,  # 库存预警阈值
		"outbound_last_month": 233, # -- v1.6 --, 上个月消耗库存数
		"last_checked_at": "2019-01-01" # -- v1.6 --, 最后盘点时间, 没有盘点记录则为空值
	}
}
# OR
{
	"status": "fail",
	"reason": [ 
		"Invalid access token",
		"Inventory with id 1 not found"
	]
}
```

<h3 id="inventory_tasks">2.5 库存任务管理</h3>

<h4 id="inventory_tasks_index">2.5.1 库存任务查询</h4>

| Request | Response |
| :- | :- |
| GET /api/v1.0/inventory_tasks | 200 OK |
| Content-Type: application/json | Content-Type: application/json |

* 请求参数
```ruby
# 库存任务总表
{
	# 用于验证请求用户身份
	"access_token": "4E0_W8z4jCdOVxf3DgVuARejvR8T8g...",
	
	"page": 1,
	"per_page": 10,
	# 参数查询规则请参照 FilterRules
	"q": {
		"task_num": "T000001",
		"operation": "transfer/check", # 任务类型包括, 库存转移, 库存盘点等
		"status": "new/finished",
		"created_at": "2018-06-25",
		"updated_at": "2018-06-26"
	}
}
```
* 响应代码
```ruby
{
	"status": "succ",
	"data": [
		{
			"id": 1,
			"task_num": "T000001",
			"operation": "transfer",
			"status": "finished", 
			"operators": ["first@operator.com", "second@operator.com"],
			"created_at": "2018-06-25",
			"updated_at": "2018-06-26"	
		},
		{
			"id": 2,
			"task_num": "T000002",
			"operation": "transfer",
			"status": "new",
			"operators": ["first@operator.com", "second@operator.com"],
			"created_at": "2018-06-26",
			"updated_at": "2018-06-26"
		}
		# ...
	],
	"page": 1,
	"per_page": 10,
	"count": 98
}
# OR
{
	"status": "fail",
	"reason": [ "Invalid access token" ]
}
```

<h4 id="inventory_tasks_show">2.5.2 库存任务详情查询</h4>

| Request | Response |
| :- | :- |
| GET /api/v1.0/inventory_tasks/:id/show | 200 OK |
| Content-Type: application/json | Content-Type: application/json |

* 请求参数
```ruby
# GET /api/v1.0/inventory_tasks/1/show
{
	# 用于验证请求用户身份
	"access_token": "4E0_W8z4jCdOVxf3DgVuARejvR8T8g..."
}
```
* 响应代码
```ruby
{
	"status": "succ",
	"data": {
		"id": 1,
		"task_num": "T000001"
		"operation": "transfer/check",
		"status": "new/finished",
		"created_at": "2018-06-25",
		"updated_at": "2018-06-26",
		"operators": [
			"first@operator.com",
			"second@operator.com"
		],
		# 根据 operation(任务类型) 返回详情
		# 转移子任务格式
		"transfer_infos": [
			{
				"id": 1,
				"inventory_id": 1, # 库存总表 id
				"sku_code": "sku001", # 冗余字段, 用于查询显示
				"barcode": "bar001",  # 冗余字段, 用于查询显示
				"to_depot_code": "DP",
				"from_shelf_num": "DP-A-01-01-01",
				"to_shelf_num": "DP-B-01-02-03",
				"transfer_quantity": 50, 
				"status": "finished", 
				"operator": "operator@inventory.com",
				"created_at": "2018-06-25",
				"updated_at": "2018-06-25"
			}
			# ...
		],
		# 盘点子任务格式
		"check_type": {
			"check_type": "sku/shelf",
			"shelf_num": "DUS-A-01-01-01", # shelf 专属
			"sku_code": "sku001", # sku 专属
			"barcode": "123456", # sku 专属
			"sku_owner": "sku@owner.com", # sku 专属
			"shelf_nums": ["DUS-A-01-01-01", "DUS-A-01-01-02"], # sku 专属, 提示用途
		}
		"check_infos": [
			{
				"id": 1, # 单条盘点信息 id
				"inventory_id": 1, # 库存总表 id
				"sku_code": "sku001", # 冗余字段, 用于查询显示
				"barcode": "bar001",  # 冗余字段, 用于查询显示
				"shelf_num": "SD-A-01-01-01",
				"quantity": 50, # 系统中库存数量(盘点完成前返回实时库存数量, 盘点完成后返回日志中的快照数值)
				"check_quantity": 48,  # 盘点数量
				"status": "finished", 
				"operator": "operator@inventory.com",
				"created_at": "2018-06-25",
				"updated_at": "2018-06-25"
			}
		]
	}
}
# OR
{
	"status": "fail",
	"reason": [ 
		"Invalid access token",
		"InventoryTask with id 1 not found"
	]
}
```

<h4 id="inventory_tasks_create_transfer">2.5.3 创建库存转移任务</h4>

| Request | Response |
| :- | :- |
| POST /api/v1.0/inventory_tasks/create_transfer | 200 OK |
| Content-Type: application/json | Content-Type: application/json |

* 请求参数
```ruby
# POST /api/v1.0/inventory_tasks/create_transfer
{
	# 用于验证请求用户身份
	"access_token": "4E0_W8z4jCdOVxf3DgVuARejvR8T8g...",
	
	"scheduled_time": "2018-08-01",  # 不传则默认为当前时间
	"to_depot_code": "DP",  # 必填
	
	"transfer_infos": [
		{
			"inventory_id": 1, # 库存总表 id
			"transfer_quantity": 50
		},
		{
			"inventory_id": 3, 
			"transfer_quantity": 40
		},
		# ...	
	],
	"operators": [
		"first@operator.com",
		"second@operator.com"
	]
}
```
* 响应代码
```ruby
# 创建转移任务后, 等待转移的库存会被暂时冻结
{
	"status": "succ",
	# 返回库存转移任务信息
	"data": {
		"id": 1,
		"operation": "transfer",
		"status": "new",
		"created_at": "2018-06-25",
		"updated_at": "2018-06-26",
		"operators": [
			"first@operator.com",
			"second@operator.com"
		],
		"transfer_infos": [
			{
				"id": 1, # 单条转移信息 id
				"inventory_id": 1, # 库存总表 id
				"sku_code": "sku001", # 冗余字段, 用于查询显示
				"barcode": "bar001",  # 冗余字段, 用于查询显示
				"to_depot_code": "DP",
				"from_shelf_num": "DP-A-01-01-01",
				"to_shelf_num": nil,
				"transfer_quantity": 50, 
				"status": "new", 
				"operator": nil,
				"created_at": "2018-06-25",
				"updated_at": "2018-06-25"
			},
			{
				"id": 2, # 单条转移信息 id
				"inventory_id": 3, # 库存总表 id
				"sku_code": "sku003", # 冗余字段, 用于查询显示
				"barcode": "bar003",  # 冗余字段, 用于查询显示
				"to_depot_code": "DP",
				"from_shelf_num": "DP-A-01-02-02",
				"to_shelf_num": nil,
				"transfer_quantity": 40, 
				"status": "new", 
				"operator": nil,
				"created_at": "2018-06-25",
				"updated_at": "2018-06-25"				
			}
			# ...
		]
	}
}
# OR
{
	"status": "fail",
	"reason": [ 
		"Invalid access token"
	]
}
```

<h4 id="inventory_tasks_finish_transfer">2.5.4 完成库存转移任务(系统调用)</h4>

| Request | Response |
| :- | :- |
| POST /api/v1.0/inventory_tasks/finish_transfer | 200 OK |
| Content-Type: application/json | Content-Type: application/json |

* 请求参数
```ruby
# POST /api/v1.0/inventory_tasks/finish_transfer
# 该接口在转移任务对应的入库预报完成后由系统自动调用
{
	# 用于验证请求用户身份
	"access_token": "4E0_W8z4jCdOVxf3DgVuARejvR8T8g...",
	"task_num": "T001"
}
```
* 响应代码
```ruby
{
	"status": "succ"
}
# OR
{
	"status": "fail",
	"reason": [ 
		"Invalid access token"
	]
}
```

<h4 id="inventory_tasks_cancel_transfer">2.5.5 取消库存转移任务(系统调用)</h4>

| Request | Response |
| :- | :- |
| POST /api/v1.0/inventory_tasks/cancel_transfer | 200 OK |
| Content-Type: application/json | Content-Type: application/json |

* 请求参数
```ruby
# POST /api/v1.0/inventory_tasks/cancel_transfer
# 该接口在转移任务对应的入库预报删除后由系统自动调用
{
	# 用于验证请求用户身份
	"access_token": "4E0_W8z4jCdOVxf3DgVuARejvR8T8g...",
	"task_num": "T001"
}
```
* 响应代码
```ruby
{
	"status": "succ"
}
# OR
{
	"status": "fail",
	"reason": [ 
		"Invalid access token"
	]
}
```

<h4 id="inventory_tasks_create_check">2.5.6 创建库存盘点任务</h4>

| Request | Response |
| :- | :- |
| POST /api/v1.0/inventory_tasks/create_check | 200 OK |
| Content-Type: application/json | Content-Type: application/json |

* 请求参数
```ruby
# POST /api/v1.0/inventory_tasks/create_check
{
	# 用于验证请求用户身份
	"access_token": "4E0_W8z4jCdOVxf3DgVuARejvR8T8g...",
	
	"check_type": "sku", # 盘点类型, sku 或 shelf
	"inventory_id": 1, # check_type 为 sku 时, 传此值
	"shelf_num": "SD-A-01-01-01", # check_type 为 shelf 时, 传此值
	# 分配操作员, 可不传
	"operators": [
		"first@operator.com",
		"second@operator.com"
	]
}
```
* 响应代码
```ruby
{
	"status": "succ",
	# 返回库存盘点任务信息
	"data": {
		"id": 1,
		"operation": "check",
		"status": "new",
		"created_at": "2018-06-25",
		"updated_at": "2018-06-26",
		"operators": [],
		"check_type": {
			"check_type": "sku",
			"inventory_id": 1,
			"shelf_num": nil
		},
		"check_infos": []
	}
}
# OR
{
	"status": "fail",
	"reason": [ 
		"Invalid access token"
	]
}
```

<h4 id="inventory_tasks_update_check">2.5.7 更新库存盘点任务</h4>

| Request | Response |
| :- | :- |
| POST /api/v1.0/inventory_tasks/:id/update_check | 200 OK |
| Content-Type: application/json | Content-Type: application/json |

* 请求参数
```ruby
# POST /api/v1.0/inventory_tasks/1/update_check
{
	# 用于验证请求用户身份
	"access_token": "4E0_W8z4jCdOVxf3DgVuARejvR8T8g...",
	
	# 可以分批提交, 在确认前可以更新覆盖, 全部sku完成盘点后进入待确认状态
	"check_info": {
		"barcode": "123456",
		"shelf_num": "SD-A-01-01-01",
		"check_quantity": 48
	}
}
```
* 响应代码
```ruby
{
	"status": "succ",
	# 返回库存盘点任务信息
	"data": {
		"id": 1,
		"operation": "check",
		"status": "new", 
		"created_at": "2018-06-25",
		"updated_at": "2018-06-26",
		"operators": [],
		"check_type": {
			"check_type": "sku",
			"inventory_id": 1,
			"shelf_num": nil
		},
		"check_infos": [
			{
				"id": 1, # 单条盘点信息 id
				"inventory_id": 1, # 库存总表 id
				"sku_code": "sku001", # 冗余字段, 用于查询显示
				"barcode": "bar001",  # 冗余字段, 用于查询显示
				"shelf_num": "SD-A-01-01-01",
				"quantity": 50, # 系统中库存数量(盘点前)
				"check_quantity": 48,  # 盘点数量
				"status": "finished", 
				"operator": "operator@inventory.com",
				"created_at": "2018-06-25",
				"updated_at": "2018-06-25"
			},
			{
				"id": 2, # 单条转移信息 id
				"inventory_id": 3, # 库存总表 id
				"sku_code": "sku003", # 冗余字段, 用于查询显示
				"barcode": "bar003",  # 冗余字段, 用于查询显示
				"shelf_num": "SD-A-01-03-01",
				"quantity": 233, # 系统中库存数量(盘点前)
				"check_quantity": 231, # 盘点数量
				"status": "finished", 
				"operator": "operator@inventory.com",
				"created_at": "2018-06-25",
				"updated_at": "2018-06-25"				
			}
			# ...
		]
	}
}
# OR
{
	"status": "fail",
	"reason": [ 
		"Invalid access token",
		"InventoryTask with id 1 not found"
	]
}
```

<h4 id="inventory_tasks_finish_check">2.5.8 完成库存盘点任务</h4>

| Request | Response |
| :- | :- |
| POST /api/v1.0/inventory_tasks/:id/finish_check | 200 OK |
| Content-Type: application/json | Content-Type: application/json |

* 请求参数
```ruby
# POST /api/v1.0/inventory_tasks/1/finish_check
{
	# 用于验证请求用户身份
	"access_token": "4E0_W8z4jCdOVxf3DgVuARejvR8T8g...",
	
	# 确认完成盘点任务, 之后盘点任务信息不能再更新
}
```
* 响应代码
```ruby
{
	"status": "succ"
}
# OR
{
	"status": "fail",
	"reason": [ 
		"Invalid access token",
		"InventoryTask with id 1 not found",
		"InventoryTask with id 1 cannot be finished"
	]
}
```

<h4 id="inventory_tasks_cancel">2.5.9 取消库存任务</h4>

| Request | Response |
| :- | :- |
| POST /api/v1.0/inventory_tasks/:id/cancel | 200 OK |
| Content-Type: application/json | Content-Type: application/json |

* 请求参数
```ruby
# POST /api/v1.0/inventory_tasks/1/cancel
{
	# 用于验证请求用户身份
	"access_token": "4E0_W8z4jCdOVxf3DgVuARejvR8T8g...",

	# 确认取消库存任务后, 不能再对任务进行其他操作
}
```
* 响应代码
```ruby
{
	"status": "succ"
}
# OR
{
	"status": "fail",
	"reason": [
		"Invalid access token",
		"InventoryTask with id 1 not found",
		"InventoryTask with id 1 cannot be cancelled"
	]
}
```

<h4 id="inventory_tasks_allocate">2.5.10 库存任务分配/更新</h4>

| Request | Response |
| :- | :- |
| POST /api/v1.0/inventory_tasks/:id/allocate | 200 OK |
| Content-Type: application/json | Content-Type: application/json |

* 请求参数
```ruby
# POST /api/v1.0/inventory_tasks/1/allocate
{
	# 用于验证请求用户身份
	"access_token": "4E0_W8z4jCdOVxf3DgVuARejvR8T8g...",

	"operators": [
		"first@operator.com",
		"second@operator.com"
	]
}
```
* 响应代码
```ruby
{
	"status": "succ",
	"data": {
		"id": 1,
		"operation": "check",
		"status": "new",
		"created_at": "2018-06-25",
		"updated_at": "2018-06-26",
		"operators": [
			"first@operator.com",
			"second@operator.com"
		],
		"check_type": {
			"check_type": "sku",
			"inventory_id": 1,
			"shelf_num": nil
		},
		"check_infos": []
	}
}
# OR
{
	"status": "fail",
	"reason": [
		"Invalid access token",
		"InventoryTask with id 1 not found"
	]
}
```

<h3 id="inventory_settings">2.6 库存设置管理</h3>

<h4 id="inventory_settings_index">2.6.1 库存全局设置查询</h4>

| Request | Response |
| :- | :- |
| GET /api/v1.0/inventory_settings | 200 OK |
| Content-Type: application/json | Content-Type: application/json |

* 请求参数
```ruby
# GET /api/v1.0/inventory_settings
{
	# 用于验证请求用户身份
	"access_token": "4E0_W8z4jCdOVxf3DgVuARejvR8T8g..."
}
```
* 响应代码
```ruby
{
	"status": "succ",
	"data": {
		"global_caution_threshold": 0, # 全局余量预警阈值
		"periodic_check_task_switch": "off", # 周期盘点任务开关
		"check_task_generation_interval": 7, # 盘点任务自动生成间隔(单位:天)
		"check_frequency_yearly_default": 52, #年度计划盘点次数(默认)
		"check_frequency_yearly_cat_a": 52, # 年度计划盘点次数(A类)
		"check_frequency_yearly_cat_b": 52, # 年度计划盘点次数(B类)
		"check_frequency_yearly_cat_c": 52, # 年度计划盘点次数(C类)
		# ...
	}
}
# OR
{
	"status": "fail",
	"reason": [ "Invalid access token" ]
}
```

<h4 id="inventory_settings_update">2.6.2 库存全局设置更新</h4>

| Request | Response |
| :- | :- |
| GET /api/v1.0/inventory_settings/update | 200 OK |
| Content-Type: application/json | Content-Type: application/json |

* 请求参数
```ruby
# PUT /api/v1.0/inventory_settings/update
{
	# 用于验证请求用户身份
	"access_token": "4E0_W8z4jCdOVxf3DgVuARejvR8T8g...",
	
	"global_caution_threshold": 123, # 全局余量预警阈值, positive integer
	"periodic_check_task_switch": "on", # 周期盘点任务开关, string(on/off)
	"check_task_generation_interval": 7, # 盘点任务自动生成间隔(单位:天), positive integer
	"check_frequency_yearly_default": 52, #年度计划盘点次数(默认), positive integer
	"check_frequency_yearly_cat_a": 52, # 年度计划盘点次数(A类), positive integer
	"check_frequency_yearly_cat_b": 52, # 年度计划盘点次数(B类), positive integer
	"check_frequency_yearly_cat_c": 52, # 年度计划盘点次数(C类), positive integer
	...
}
```
* 响应代码
```ruby
{
	"status": "succ",
	"data": {
		"global_caution_threshold": 123, # 全局余量预警阈值
		"periodic_check_task_switch": "on", # 周期盘点任务开关
		"check_task_generation_interval": 7, # 盘点任务自动生成间隔(单位:天)
		"check_frequency_yearly_default": 52, #年度计划盘点次数(默认)
		"check_frequency_yearly_cat_a": 52, # 年度计划盘点次数(A类)
		"check_frequency_yearly_cat_b": 52, # 年度计划盘点次数(B类)
		"check_frequency_yearly_cat_c": 52, # 年度计划盘点次数(C类)
		# ...
	}
}
# OR
{
	"status": "fail",
	"reason": [ 
		"Invalid access token",
		"Invalid params, global_caution_threshold"
	 ]
}
```

<h4 id="global_caution_threshold_setting">2.6.3 库存设置(全局余量预警阈值)</h4>

| Request | Response |
| :- | :- |
| PUT /api/v1.0/inventory_settings/update_global_caution_threshold | 200 OK |
| Content-Type: application/json | Content-Type: application/json |

* 请求参数
```ruby
# PUT /api/v1.0/inventory_settings/update_global_caution_threshold
{
	# 用于验证请求用户身份
	"access_token": "4E0_W8z4jCdOVxf3DgVuARejvR8T8g...",
	
	"global_caution_threshold": 100
}
```
* 响应代码
```ruby
{
	"status": "succ"
}
# OR
{
	"status": "fail",
	"reason": [ "Invalid access token" ]
}
```

<h4 id="single_caution_threshold_setting">2.6.4 库存设置(个别余量预警阈值)</h4>

| Request | Response |
| :- | :- |
| PUT /api/v1.0/inventories/:id/update_caution_threshold | 200 OK |
| Content-Type: application/json | Content-Type: application/json |

* 请求参数
```ruby
# PUT /api/v1.0/inventories/1/update_caution_threshold
{
	# 用于验证请求用户身份
	"access_token": "4E0_W8z4jCdOVxf3DgVuARejvR8T8g...",
	
	"caution_threshold": 100
}
```
* 响应代码
```ruby
{
	"status": "succ",
	"data": {
		"id": 1,
		"sku_owner": "admin@inventory.com",
		"sku_code": "sku001",
		"barcode": "bar001", 
		"name": "商品名称", 
		"foreign_name": "sku_name",
		"abc_category": "A", 
		"quantity": 100, 
		"available_quantity": 100, 
		"frozen_quantity": 0, 
		"caution_threshold": 100,  # 库存预警阈值
		"created_at": "2018-06-26", 
		"updated_at": "2018-06-26"		
	}
}
# OR
{
	"status": "fail",
	"reason": [ 
		"Invalid access token",
		"Inventory with id 1 not found"
	 ]
}
```

<h3 id="inventory_operation">2.7 库存操作</h3>

<h4 id="inventory_register_operation">2.7.1 库存增加(入库登记)</h4>

| Request | Response |
| :- | :- |
| POST /api/v1.0/inventories/register_operation | 200 OK |
| Content-Type: application/json | Content-Type: application/json |

* 请求参数
```ruby
{
	# 用于验证请求用户身份
	"access_token": "4E0_W8z4jCdOVxf3DgVuARejvR8T8g...",
	
	"batch_num": "IN201808010001N001", # 必填
	"depot_code": "DUS", # 必填
	
	"inbound_batch_skus": [
		{
			"sku_code": "SKU001T", # 必填
			"barcode": "123456", # 必填
			"name": "商品名称",
			"foreign_name": "commodity name",
			"sku_owner": "sku@owner.com", # 必填
			"channel": "ETEU001", # 必填
			"quantity": 100, # 必填
			"production_date": "2018-01-01",
			"expiry_date": "2019-01-01",
			"country_of_origin": "CN",
			"abc_category": "A"
		},
		#...
	]
}
```
* 响应代码
```ruby
{
	"status": "succ"
}
# OR
{
	"status": "fail",
	"reason": [ "Invalid access token" ]
}
```

<h4 id="inventory_unregister_operation">2.7.2 库存减少(入库登记取消)</h4>

| Request | Response |
| :- | :- |
| POST /api/v1.0/inventories/unregister_operation | 200 OK |
| Content-Type: application/json | Content-Type: application/json |

* 请求参数
```ruby
{
	# 用于验证请求用户身份
	"access_token": "4E0_W8z4jCdOVxf3DgVuARejvR8T8g...",
	
	"batch_num": "IN201808010001N001"
}
```
* 响应代码
```ruby
{
	"status": "succ"
}
# OR
{
	"status": "fail",
	"reason": [ "Invalid access token" ]
}
```

<h4 id="inventory_mount_operation">2.7.3 库存调整(库存上架)</h4>

| Request | Response |
| :- | :- |
| POST /api/v1.0/inventories/mount_operation | 200 OK |
| Content-Type: application/json | Content-Type: application/json |

* 请求参数
```ruby
{
	# 用于验证请求用户身份
	"access_token": "4E0_W8z4jCdOVxf3DgVuARejvR8T8g...",
	
	"batch_num": "IN201808010001N001", # 必填
	"sku_code": "SKU001T", # 必填
	"barcode": "123456", # 必填
	"sku_owner": "sku@owner.com", # 必填
	"quantity": 100, # 必填
	"shelf_num": "DUS-A-01-01-01", # 必填
	"depot_code": "DUS", # 必填
}
```
* 响应代码
```ruby
{
	"status": "succ"
}
# OR
{
	"status": "fail",
	"reason": [ "Invalid access token" ]
}
```

<h4 id="inventory_outbound_operation">2.7.4 库存减少(取货下架)</h4>

| Request | Response |
| :- | :- |
| POST /api/v1.0/inventories/outbound_operation | 200 OK |
| Content-Type: application/json | Content-Type: application/json |

* 请求参数
```ruby
{
	# 用于验证请求用户身份
	"access_token": "4E0_W8z4jCdOVxf3DgVuARejvR8T8g...",
	
	"batch_num": "OUT201809010001N001", # 出库流水号
	"order_num": "ORDER_NUM", # 出库订单号
	"outbound_skus": [
		{
			"sku_code": "sku001",
			"barcode": "bar001",
			"sku_owner": "sku@owner.com",
			"operate_infos": [
				{ "shelf_num": "DUS-A-01-01-01", "quantity": 2,　"batch_num": "IN20180801N001" }, # 入库批次号
				{ "shelf_num": "DUS-A-01-01-02", "quantity": 12, "batch_num": "IN20180808N001" }
			]
		},
		{
			"sku_code": "sku002",
			"barcode": "bar002",
			"sku_owner": "sku@owner.com",
			"operate_infos": [
				{ "shelf_num": "DUS-A-01-01-03", "quantity": 22,　"batch_num": "IN20180801N001" },
				{ "shelf_num": "DUS-A-01-01-04", "quantity": 32, "batch_num": "IN20180808N001" }
			]
		}
	]
}
```
* 响应代码
```ruby
{
	"status": "succ"
}
# OR
{
	"status": "fail",
	"reason": [ "Invalid access token" ]
}
```

<h4 id="inventory_get_picking_infos">2.7.5 生成待取货信息(冻结取货库存)</h4>

| Request | Response |
| :- | :- |
| POST /api/v1.0/inventories/get_picking_infos | 200 OK |
| Content-Type: application/json | Content-Type: application/json |

* 请求参数
```ruby
{
	# 用于验证请求用户身份
	"access_token": "4E0_W8z4jCdOVxf3DgVuARejvR8T8g...",
	
	"batch_num": "OUT201809010001N001",
	"outbound_skus": [
		{
			"sku_code": "sku001",
			"barcode": "bar001",
			"sku_owner": "sku@owner.com",
			"quantity": 14
		},
		{
			"sku_code": "sku002",
			"barcode": "bar002",
			"sku_owner": "sku@owner.com",
			"quantity": 54
		}
	]
}
```
* 响应代码
```ruby
{
	"status": "succ",
	"data": {
		"batch_num": "OUT201809010001N001", # 出库流水号
		"outbound_skus": [
			{
				"sku_code": "sku001",
				"barcode": "bar001",
				"sku_owner": "sku@owner.com",
				"quantity": 14,
				"operate_infos": [
					{ "shelf_num": "DUS-A-01-01-01", "quantity": 2,　"batch_num": "IN20180801N001" }, # 入库批次号
					{ "shelf_num": "DUS-A-01-01-02", "quantity": 12, "batch_num": "IN20180808N001" }
				]
			},
			{
				"sku_code": "sku002",
				"barcode": "bar002",
				"sku_owner": "sku@owner.com",
				"quantity": 54,
				"operate_infos": [
					{ "shelf_num": "DUS-A-01-01-03", "quantity": 22,　"batch_num": "IN20180801N001" },
					{ "shelf_num": "DUS-A-01-01-04", "quantity": 32, "batch_num": "IN20180808N001" }
				]
			}
		]
	}
}
# OR
{
	"status": "fail",
	"reason": [ "Invalid access token" ]
}
```

<h4 id="inventory_remove_picking_infos">2.7.6 取消待取货信息(解冻取货库存)</h4>

| Request | Response |
| :- | :- |
| POST /api/v1.0/inventories/remove_picking_infos | 200 OK |
| Content-Type: application/json | Content-Type: application/json |

* 请求参数
```ruby
{
	# 用于验证请求用户身份
	"access_token": "4E0_W8z4jCdOVxf3DgVuARejvR8T8g...",
	
	"batch_num": "OUT201809010001N001",
	"outbound_skus": [
		{
			"sku_code": "sku001",
			"barcode": "bar001",
			"sku_owner": "sku@owner.com",
			"quantity": 14,
			"operate_infos": [
				{ "shelf_num": "DUS-A-01-01-01", "quantity": 2,　"batch_num": "IN20180801N001" }, # 入库批次号
				{ "shelf_num": "DUS-A-01-01-02", "quantity": 12, "batch_num": "IN20180808N001" }
			]
		},
		{
			"sku_code": "sku002",
			"barcode": "bar002",
			"sku_owner": "sku@owner.com",
			"quantity": 54,
			"operate_infos": [
				{ "shelf_num": "DUS-A-01-01-03", "quantity": 22,　"batch_num": "IN20180801N001" },
				{ "shelf_num": "DUS-A-01-01-04", "quantity": 32, "batch_num": "IN20180808N001" }
			]
		}
	]
}
```
* 响应代码
```ruby
{
	"status": "succ"
}
# OR
{
	"status": "fail",
	"reason": [ "Invalid access token" ]
}
```

<h4 id="inventory_search">2.7.7 库存信息查询(单个)</h4>

| Request | Response |
| :- | :- |
| GET /api/v1.0/inventories/search | 200 OK |
| Content-Type: application/json | Content-Type: application/json |

* 请求参数
```ruby
{
	# 用于验证请求用户身份
	"access_token": "4E0_W8z4jCdOVxf3DgVuARejvR8T8g...",
	
	"sku_code": "sku001t",
	"barcode": "123456",
	"sku_owner": "sku@owner.com"
}
```
* 响应代码
```ruby
{
	"status": "succ",
	"data": {
		"id": 1,
		"sku_owner": "admin@inventory.com",
		"sku_code": "sku001",
		"barcode": "bar001", 
		"name": "商品名称", 
		"foreign_name": "sku_name",
		"abc_category": "A", 
		"quantity": 100, 
		"available_quantity": 100, 
		"frozen_quantity": 0, 
		"caution_threshold": 10,  # 库存预警阈值
		"created_at": "2018-06-26", 
		"updated_at": "2018-06-26"	
	}
}
# OR
{
	"status": "fail",
	"reason": [ 
		"Invalid access token",
		"Inventory not found"
	 ]
}
```

<h4 id="inventory_register_decrease_operation">2.7.8 库存减少(问题sku登记)</h4>

| Request | Response |
| :- | :- |
| POST /api/v1.0/inventories/register_decrease_operation | 200 OK |
| Content-Type: application/json | Content-Type: application/json |

* 请求参数
```ruby
{
	# 用于验证请求用户身份
	"access_token": "4E0_W8z4jCdOVxf3DgVuARejvR8T8g...",
	
	"batch_num": "IN201808010001N001", # 必填
	"sku_code": "SKU001T", # 必填
	"barcode": "123456", # 必填
	"sku_owner": "sku@owner.com", # 必填
	"quantity": 100, # 必填, 问题登记数量
	"memo": "破损", # 问题备注
}
```
* 响应代码
```ruby
{
	"status": "succ"
}
# OR
{
	"status": "fail",
	"reason": [ "Invalid access token" ]
}
```

<h3 id="inventory_operation_logs">2.8 库存操作日志</h3>

<h4 id="inventory_operation_logs_index">2.8.1 库存操作日志列表(通用)</h4>

| Request | Response |
| :- | :- |
| GET /api/v1.0/inventory_operation_logs | 200 OK |
| Content-Type: application/json | Content-Type: application/json |

* 请求参数
```ruby
# GET /api/v1.0/inventory_operation_logs
# 此接口为库存操作日志查询的通用接口, 提供几乎所有日志细节
{
	# 用于验证请求用户身份
	"access_token": "4E0_W8z4jCdOVxf3DgVuARejvR8T8g...",
	
	"page": 1,
	"per_page": 10,
	# 参数查询规则请参照 FilterRules
	"q": {
		"operation": "mount", # 库存操作方式, 类型: mount/unmount/freeze/unfreeze/transfer/check
		"sku_code": "sku001", # 商品代码
		"barcode": "bar001", # 商品条码
		"sku_owner": "admin@inventory.com", # 货主
		"batch_num": "IN123456N001", # 商品库存批次
		"shelf_num": "DUS-A-01-01-01", # 货架号
		"quantity": 100, # 库存操作数量
		"operator": "staff@wms.role", # 操作员
		"refer_num": "OUT123456N001", # 出库操作相关号码(比如: 出库订单的系统流水号, 获取待取货信息和下架时记录)
		"created_at": "2018-06-26", # 日志创建日期
		"updated_at": "2018-06-26" # 日志更新日期
	}
}
```
* 响应代码
```ruby
{
	"status": "succ",
	"data": [
		{
			"id": 21,  # - 数据 ID
			"operation": "mount", # 库存操作方式
			"sku_code": "sku001", # 商品代码
			"barcode": "bar001",  # 商品条码
			"sku_owner": "admin@inventory.com", # 货主
			"channel": "ETEU010", # - 数据渠道
			"batch_num": "IN123456N001", # 商品库存批次
			"shelf_num": "DUS-A-01-01-01", # 货架号
			"quantity": 100, # 库存操作数量
			"operator": "staff@wms.role", # 操作员
			"remark": "some description", # - 日志备注
			"refer_num": nil, # 出库操作相关号码
			"created_at": "2018-06-26", # 日志创建日期
			"updated_at": "2018-06-26" # 日志更新日期		
		},
		{
			"id": 45,  # - 数据 ID
			"operation": "unmount", # 库存操作方式
			"sku_code": "sku001", # 商品代码
			"barcode": "bar001",  # 商品条码
			"sku_owner": "admin@inventory.com", # 货主
			"channel": "ETEU010", # - 数据渠道
			"batch_num": "IN123456N001", # 商品库存批次
			"shelf_num": "DUS-A-01-01-01", # 货架号
			"quantity": 100, # 库存操作数量
			"operator": "staff@wms.role", # 操作员
			"remark": "some description", # - 日志备注
			"refer_num": "OUT123456N001", # 出库操作相关号码
			"created_at": "2018-06-26", # 日志创建日期
			"updated_at": "2018-06-26" # 日志更新日期	
		}
		# ...
	],
	"page": 1,
	"per_page": 10,
	"count": 21
}
# OR
{
	"status": "fail",
	"reason": [ "Invalid access token" ]
}
```

<h4 id="inventories_operation_logs">2.8.2 单个库存的操作日志(简易)</h4>

| Request | Response |
| :- | :- |
| GET /api/v1.0/inventories/:id/operation_logs | 200 OK |
| Content-Type: application/json | Content-Type: application/json |

* 请求参数
```ruby
# GET /api/v1.0/inventories/1/operation_logs
# 此接口为单个库存对应的操作日志的查询接口, 只返回登记/登记问题sku/下架/转移/盘点(register/register_decrease/unmount/transfer/check)等反应库存总数量变化的日志
# mount操作不影响库存总量, 故不再返回
{
	# 用于验证请求用户身份
	"access_token": "4E0_W8z4jCdOVxf3DgVuARejvR8T8g...",
	
	"page": 1,
	"per_page": 10,
	# 参数查询规则请参照 FilterRules
	"q": {
		"operation": "register", # 库存操作方式, 类型: register/register_decrease/unmount/transfer/check
		"created_at": "2018-06-26", # 日志创建日期
	}
}
```
* 响应代码
```ruby
{
	"status": "succ",
	"data": [
		{
			"operation": "register", # 库存操作方式
			"batch_num": "IN123456N001", # 商品库存批次
			"quantity": 100, # 库存操作数量, 同批次同时间点数量合并
			"refer_num": nil, # 出库操作相关号码
			"created_at": "2018-06-26", # 日志创建日期
		},
		{
			"operation": "unmount", # 库存操作方式
			"batch_num": "IN123456N001", # 商品库存批次
			"quantity": 100, # 库存操作数量
			"refer_num": "OUT123456N001", # 出库操作相关号码
			"created_at": "2018-06-26", # 日志创建日期
		}
		# ...
	],
	"page": 1,
	"per_page": 10,
	"count": 21
}
# OR
{
	"status": "fail",
	"reason": [ "Invalid access token" ]
}
```

<h3 id="statistics">2.9 统计</h3>

<h4 id="statistics_inventories_count">2.9.1 库存数量统计</h4>

| Request | Response |
| :- | :- |
| GET /api/v1.0/statistics/inventories/count | 200 OK |
| Content-Type: application/json | Content-Type: application/json |

* 请求参数
```ruby
# GET /api/v1.0/statistics/inventories/count
# 自动根据请求用户的最高权限(角色/渠道), 返回对应的统计
{
	# 用于验证请求用户身份
	"access_token": "4E0_W8z4jCdOVxf3DgVuARejvR8T8g..."
}
```
* 响应代码
```ruby
{
	"status": "succ",
	"caution_count": 10, # 库存量小于预警阈值的库存数量
}
# OR
{
	"status": "fail",
	"reason": [ "Invalid access token" ]
}
```

<h4 id="statistics_inventory_check_tasks_count">2.9.2 库存盘点任务数量统计</h4>

| Request | Response |
| :- | :- |
| GET /api/v1.0/statistics/inventory_check_tasks/count | 200 OK |
| Content-Type: application/json | Content-Type: application/json |

* 请求参数
```ruby
# GET /api/v1.0/statistics/inventory_check_tasks/count
# 自动根据请求用户的最高权限(角色/渠道), 返回对应的统计
{
	# 用于验证请求用户身份
	"access_token": "4E0_W8z4jCdOVxf3DgVuARejvR8T8g..."
}
```
* 响应代码
```ruby
{
	"status": "succ",
	"new_count": 2, # 待处理库存盘点任务数量
}
# OR
{
	"status": "fail",
	"reason": [ "Invalid access token" ]
}
```

<h4 id="statistics_performance_ranking">2.9.3 绩效统计</h4>

| Request | Response |
| :- | :- |
| GET /api/v1.0/statistics/performance/ranking | 200 OK |
| Content-Type: application/json | Content-Type: application/json |

* 请求参数
```ruby
# GET /api/v1.0/statistics/performance/ranking
# 自动根据请求用户的最高权限(角色/渠道), 返回对应的统计
{
	# 用于验证请求用户身份
	"access_token": "4E0_W8z4jCdOVxf3DgVuARejvR8T8g...",
	
	# 统计开始时间和统计结束时间可不传, 默认统计时间范围为最近30天
	# 传值时两个值都要传, 有任意一个时间未传值, 则采用默认统计时间
	"begin_time": "2018-10-01", # 统计开始时间
	"end_time": "2018-11-01",  # 统计结束时间
	"top": 5, # 返回前5名工作人员操作数, 如果总工作人员大于5, 则合并剩余, 默认值: 5
}
```
* 响应代码
```ruby
{
	"status": "succ",
	"begin_time": "2018-10-01",
	"end_time": "2018-11-01",
	"top": 5,
	"mount_ranking": [
		{ "rank": 1, "count": 99, "account": "staff_1@email.com"},
		{ "rank": 2, "count": 90, "account": "staff_2@email.com"},
		{ "rank": 3, "count": 67, "account": "staff_3@email.com"},
		{ "rank": 4, "count": 54, "account": "staff_4@email.com"},
		{ "rank": 5, "count": 25, "account": "staff_5@email.com"},
		{ "rank": 6, "count": 88, "account": "rest"}
	],
	"unmount_ranking": [
		{ "rank": 1, "count": 88, "account": "staff_5@email.com"},
		{ "rank": 2, "count": 81, "account": "staff_4@email.com"},
		{ "rank": 3, "count": 69, "account": "staff_3@email.com"},
		{ "rank": 4, "count": 59, "account": "staff_2@email.com"},
		{ "rank": 5, "count": 40, "account": "staff_1@email.com"},
		{ "rank": 6, "count": 66, "account": "rest"}
	]
}
# OR
{
	"status": "fail",
	"reason": [ "Invalid access token" ]
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
