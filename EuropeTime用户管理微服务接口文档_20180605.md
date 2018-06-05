# 用户管理微服务接口文档

**文档信息**

| 系统名称 | 用户管理微服务 |
| :- | :- |
| 生产环境 | [https://micro_service/production/cm_user_mgmt/api/v1.0/](https://www.mypost4u.com/rest-api/v2.1/) |
| 测试环境 | http://47.96.153.174:9050/                                                   |
| 数据协议 | HTTP, JSON, SSL                                                                                    |
| 联系人 | chang.cai@quaie.com ; kater.jiang@quaie.com ; amy.wang@quaie.com ; samuel.uling@quaie.com    |

**版本记录**

| 版本编号 | 版本日期  | 修改者 | 说明 | 文件名 |
| :- | :- | :- | :- | :- |
| V1.0 | 2018/04/18 | 王倩 |||
|   |   |       |      |        |
|   |   |       |      |        |

**版权声明**

Copyright © 2018上海诗禹信息技术有限公司 All Rights Reserved

**目录**

[1. 介绍](#introduction)
>[1.1 文档目的](#purpose)

[2. 接口](#api)
>[2.1. 用户管理](#accounts)
>>[2.1.1 用户认证/登录](#access_token)

>>[2.1.2 获取当前认证用户](#current_account)

>>[2.1.3 用户注册](#registration)

>>[2.1.4 用户激活](#confirmation)

>>[2.1.5 用户创建](#accounts_create)

>>[2.1.6 用户创建(批量)](#accounts_batch_create)

>>[2.1.7 用户参数验证](#accounts_validate)

>>[2.1.8 用户删除](#accounts_delete)

>>[2.1.9 用户信息更新](#accounts_update)

>>[2.1.10 单个用户详情](#accounts_show)

>>[2.1.11 用户列表查询](#accounts_index)

>[2.2 用户组管理](#account_groups)
>>[2.2.1 用户组创建](#account_groups_create)

>>[2.2.2 用户组删除](#account_groups_delete)

>>[2.2.3 用户组信息更新](#account_groups_update)

>>[2.2.4 单个用户组详情](#account_groups_show)

>>[2.2.5 用户组列表查询](#account_groups_index)

>[2.3 角色管理](#roles)
>>[2.3.1 单个角色详情](#roles_show)

>>[2.3.2 角色列表查询](#roles_index)


>[2.4 渠道管理](#channels)
>>[2.4.1 渠道创建](#channels_create)

>>[2.4.2 渠道删除](#channels_delete)

>>[2.4.3 渠道信息更新](#channels_update)

>>[2.4.4 单个渠道详情](#channels_show)

>>[2.4.5 渠道列表查询](#channels_index)

[3. 附录](#appendix)
>[3.1. FilterRules](#filter_rules)

<h2 id="introduction">1. 介绍</h2>
本文档是详细描述用户管理微服务的API接口文档。文档共分为三部分：介绍，接口，附录。其中第二部分接口是本文档的正文部分，明确了本系统所提供的接口服务类型及请求与响应格式。

<h3 id="purpose">1.1 文档目的</h3>
撰写本文档的目的是指导代理服务器与微服务的对接开发，帮助项目经理了解系统功能。
本文档同样适用于商户以及合作伙伴。

<h2 id="api">2. 接口</h2>

<h3 id="accounts">2.1用户管理</h3>

<h4 id="access_token">2.1.1 用户认证/登录</h4>

| Request | Response |
| :- | :- |
| POST /oauth2/token | 200 OK  |
| Content-Type: application/x-www-form-urlencoded | Content-Type: application/json |

* 请求参数
```ruby
# client_id, client_secret 由用户管理服务事先创建并提供, 用于验证第三方服务身份
{
	"client_id": "NSnc8CK3ceqozl8vlwi46A", # 固定值
	"client_secret": "h-_hEIFPWZoVUZjWcNIKrzO208VC56P...",  # 固定值
	"grant_type": "password",  # oauth2协议获取token认证类型, 固定值
	"username": "email@email.email",
	"password": "pa$$w0rd"
}
```
* 响应代码
```ruby
# 认证成功返回 access_token,后续数据请求中需要带上access_token,用于验证用户身份
{
 	"access_token": "4E0_W8z4jCdOVxf3DgVuARejvR8T8g...", 
	"token_type": "bearer", 
	"expires_in": 7200   # token 过期剩余时间, 单位: 秒(second)
}
# OR 认证失败
{
	"error": "invalid_grant",
	"error_description": "The provided access grant is invalid..."
}
```

<h4 id="current_account">2.1.2 获取当前认证用户</h4>

| Request | Response |
| :- | :- |
| GET /oauth2/current_account | 200 OK |
| Content-Type: application/x-www-form-urlencoded | Content-Type: application/json |

* 请求参数
```ruby
# GET /oauth2/current_account?access_token=4E0_W8z4jCdOVxf3DgVuARejvR8T8g...
{
	"access_token": "4E0_W8z4jCdOVxf3DgVuARejvR8T8g..."
}
```
* 响应代码
```ruby
{
	"status": "succ",
	"account": {
		"id": 1,
		"email": "first@account.info",
		"nickname": "first",
		"telephone": "123123",
		"parent_id": nil,
		"roles": [
			{ 
				"id": 8, 
				"application_name": "wms", 
				"name": "admin",
				"description": "administrator of wms"
			},
			{
				"id": 11, 
				"application_name": "wms", 
				"name": "staff",
				"description": "staff of wms"
			}
		],
		"channels": [
			{ 
				"id": 1, 
				"name": "ETCN001"
			}
		],
		"account_groups": [
			{ 
				"id": 1, 
				"name": "TestGroup"
			}
		]
	},
	"access_token": {
	 	"access_token": "4E0_W8z4jCdOVxf3DgVuARejvR8T8g...", 
		"token_type": "bearer", 
		"expires_in": 5888   # token 过期剩余时间, 单位: 秒(second)
	}
}
```

<h4 id="registration">2.1.3 用户注册</h4>

| Request | Response |
| :- | :- |
| POST /api/v1.0/accounts/registration | 200 OK |
| Content-Type: application/json | Content-Type: application/json |

* 请求参数
```ruby
{
	"email": "email@email.email",	# 邮箱
	"password": "pa$$w0rd",	# 密码
	"password_confirmation": "pa$$w0rd",	# 确认密码
	"nickname": "NICK"	# 昵称
}
```
* 响应代码
```ruby
# 成功注册后返回邮箱和确认激活token，否则不返回 data
{
	"status": "succ",
	"data": {
		"email": "email@email.email",
		"confirmation_token": "YcKV2siyztdBw8nU8Yqt"
	}
}
# OR
{
	"status": "fail",
	"reason": [ 'email has been used' ]
}
```

<h4 id="confirmation">2.1.4 用户激活</h4>

| Request | Response |
| :- | :- |
| GET /api/v1.0/accounts/confirm | 200 OK |
| Content-Type: application/json | Content-Type: application/json |

* 请求参数
```ruby
{
	"email": "email@email.email",
	"confirmation_token": "YcKV2siyztdBw8nU8Yqt"
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
	"reason": [ "invalid email or confirmation token" ]
}
```

<h4 id="accounts_create">2.1.5 用户创建</h4>

| Request | Response |
| :- | :- |
| POST /api/v1.0/accounts/create | 200 OK |
| Content-Type: application/json | Content-Type: application/json |

* 请求参数
```ruby
{
	"access_token": "abcd",  # 用于验证请求用户身份
	"email": "email@email.email",
	"password": "pa$$w0rd",
	"password_confirmation": "pa$$w0rd",
	"nickname": "NICK",
	"telephone": 123456,
	"role_ids": [18],
	"channel_ids": [5],
	"account_group_ids": [19]
}
```
* 响应代码
```ruby
{
	"status": "succ",
	"data": {
		"id": 1916,
		"email": "email@email.email",
		"nickname": "NICK",
		"telephone": "123456",
		"roles": [
			{ "id": 18, "name": "consignor" }
		],
		"channels": [
			{ "id": 5, "names": "ETCN001" }
		],
		"account_groups": [
			{ "id": 19, "names": "SAMPLE" }
		]
	}
}
# OR
{
	"status": "fail",
	"reason": [
		"invalid access token", "email has already been used"
	]
}
```

<h4 id="accounts_batch_create">2.1.6 用户创建(批量)</h4>

| Request | Response |
| :- | :- |
| POST /api/v1.0/accounts/batch_create | 200 OK |
| Content-Type: application/json | Content-Type: application/json |

* 请求参数
```ruby
{
	"access_token": "abcd",  # 用于验证请求用户身份
	"resource": [  # 批量创建用户信息(数组)
		{
			"email": "first@email.email",
			"password": "pa$$w0rd",
			"password_confirmation": "pa$$w0rd",
			"nickname": "first",
			"telephone": 123456,
			"role_ids": [18],
			"channel_ids": [5],
			"account_group_ids": [19]
		},
		{
			"email": "second@email.email",
			"password": "pa$$w0rd",
			"password_confirmation": "pa$$w0rd",
			"nickname": "second",
			"telephone": 654321,
			"role_ids": [18],
			"channel_ids": [5],
			"account_group_ids": [19]
		}
		# ...		
	]
}
```
* 响应代码
```ruby
{
	"status": "succ",
	"data": [
		{
			"id": 1916,
			"email": "first@email.email",
			"nickname": "first",
			"telephone": "123456"
			"roles": [
				{ "id": 18, "name": "consignor" }
			],
			"channels": [
				{ "id": 5, "names": "ETCN001" }
			],
			"account_groups": [
				{ "id": 19, "names": "SAMPLE" }
			]
		},
		{
			"id": 1916,
			"email": "second@email.email",
			"nickname": "second",
			"telephone": "654321"
			"roles": [
				{ "id": 18, "name": "consignor" }
			],
			"channels": [
				{ "id": 5, "names": "ETCN001" }
			],
			"account_groups": [
				{ "id": 19, "names": "SAMPLE" }
			]
		}
		# ...
	]
}
# OR
{
	"status": "fail",
	"reason": [
		"invalid params, index[0]"  # 表述数组中index为0的参数错误
	]
}
```

<h4 id="accounts_validate">2.1.7 用户参数验证</h4>

| Request | Response |
| :- | :- |
| POST /api/v1.0/accounts/validate | 200 OK |
| Content-Type: application/json | Content-Type: application/json |

* 请求参数
```ruby
{
	"access_token": "abcd",  # 用于验证请求用户身份
	"email": "email@email.email",
	"password": "123456",
	"password_confirmation": "123456",
	"nickname": nil,
	"telephone": 123456,
	"role_ids": [18],
	"channel_ids": [5],
	"account_group_ids": [19]
}
```
* 响应代码
```ruby
{
	"status": "succ"
}
# OR 验证失败
{
	"status": "fail",
	"reason": [
		"Password is too short (minimum is 8 characters)", 
		"Nickname can't be blank", 
		"Nickname is too short (minimum is 3 characters)", 
		"Nickname is invalid"
	] 
}

```

<h4 id="accounts_delete">2.1.8 用户删除</h4>

| Request | Response |
| :- | :- |
| DELETE /api/v1.0/accounts/:id/delete | 200 OK |
| Content-Type: application/json | Content-Type: application/json |

* 请求参数
```ruby
{
	"access_token": "abcd",  # 用于验证请求用户身份
}
```
* 响应代码
```ruby
# DELETE /api/v1.0/accounts/1/delete
{
	"status": "succ"
}
# OR
{
	"status": "fail",
	"reason": [ "account with id 1 can not be deleted" ]
}
```

<h4 id="accounts_update">2.1.9 用户信息更新</h4>

| Request | Response |
| :- | :- |
| PUT /api/v1.0/accounts/:id/update | 200 OK |
| Content-Type: application/json | Content-Type: application/json |

* 请求参数
```ruby
 # PUT /api/v1.0/accounts/1/update
 {
 	"access_token": "abcd",  # 用于验证请求用户身份
 	"password": "12341234",
 	"password_confirmation": "12341234",
 	"nickname": "Samuel",
 	"telephone": "456456",
 	"role_ids": [ 8, 10, 11 ],
 	"channel_ids": [1],
 	"account_group_ids": []
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
	"reason": [ "account with id 1 not found" ]
}
```

<h4 id="accounts_show"> 2.1.10 单个用户详情</h4>

| Request | Response |
| :- | :- |
| GET /api/v1.0/accounts/:id/show | 200 OK |
| Content-Type: application/json | Content-Type: application/json |

* 请求参数
```ruby
{
	"access_token": "abcd",  # 用于验证请求用户身份
}
```
* 响应代码
```ruby
# GET /api/v1.0/accounts/1/show
{
	"status": "succ",
	"data": {
		"id": 1,
		"email": "first@account.info",
		"nickname": "first",
		"telephone": "123123",
		"parent_id": nil,
		"roles": [
			{ 
				"id": 8, 
				"application_name": "wms", 
				"name": "admin",
				"description": "administrator of wms"
			},
			{
				"id": 11, 
				"application_name": "wms", 
				"name": "staff",
				"description": "staff of wms"
			}
		],
		"channels": [
			{ 
				"id": 1, 
				"name": "ETCN001"
			}
		],
		"account_groups": [
			{ 
				"id": 1, 
				"name": "TestGroup"
			}
		]
	}
}
# OR
{
	"status": "fail",
	"reason": [ "account with id 1 not found" ]
}
```

<h4 id="accounts_index"> 2.1.11 用户列表查询</h4>

| Request | Response |
| :- | :- |
| GET /api/v1.0/accounts | 200 OK |
| Content-Type: application/json | Content-Type: application/json |

* 请求参数
```ruby
{
	"access_token": "abcd",  # 用于验证请求用户身份,
	"page": 1,  # 请求第几页
	"per_page": 10,  # 每页的数据条数
	"q": {  # 组合查询条件 -- 详见附录FilterRules
		"email_cont": "admin",
		"telephone_cont": "123123",
		"created_at_gteq": "2018-01-01",
		"roles": {
			"name_eq": "admin"
		},
		"channels": {
			"name_cont": "ETCN"
		}
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
			"email": "samuel@admin.com",
			"nickname": "samuel",
			"telephone": "123123123",
			"parent_id": nil,
			"roles": [
				{ 
					"id": 8, 
					"application_name": "wms", 
					"name": "admin",
					"description": "administrator of wms"
				}
			],
			"channels": [
				{ 
					"id": 1, 
					"name": "ETCN001"
				}
			],
			"account_groups": [
				{ 
					"id": 1, 
					"name": "TestGroup"
				}
			]
		},
		{
			"id": 2,
			"email": "levine@admin.com",
			"nickname": "levine",
			"telephone": "123123124",
			"parent_id": nil,
			"roles": [
				{ 
					"id": 8, 
					"application_name": "wms", 
					"name": "admin",
					"description": "administrator of wms"
				}
			],
			"channels": [
				{ 
					"id": 1, 
					"name": "ETCN002"
				}
			],
			"account_groups": [ ]
		}
	],
	"page": 1,
	"per_page": 10,
	"count": 2 # 满足搜索条件的数据总数
}
# OR
{
	"status": "fail",
	"reason": [ "fail reasons" ]
}
```

<h3 id="account_groups">用户组管理</h3>

<h4 id="account_groups_create">2.2.1. 用户组创建</h4>

| Request | Response |
| :- | :- |
| POST /api/v1.0/account_groups/create | 200 OK |
| Content-Type: application/json | Content-Type: application/json |

* 请求参数
```ruby
{
	"access_token": "abcd",  # 用于验证请求用户身份
	"name": "test_account_group_1"  # 用户组名称
	"role_ids": [ 8 ]
}
```
* 响应代码
```ruby
{
	"status": "succ",
	"data": {
		"id": 1,
		"name": "test_account_group_1",
		"roles": [
			"id": 8,
			"application_name": "wms", 
			"name": "admin",
			"description": "administrator of wms"		
		],
		"can_delete": false  # 是否能删除标志
	}
}
# OR
{
	"status": "fail",
	"reason": [ "Name has already been taken" ]
}
```

<h4 id="account_groups_delete"> 2.2.2 用户组删除</h4>

| Request | Response |
| :- | :- |
| DELETE /api/v1.0/account_groups/:id/delete | 200 OK |
| Content-Type: application/json | Content-Type: application/json |

* 请求参数
```ruby
{
	"access_token": "abcd",  # 用于验证请求用户身份
}
```
* 响应代码
```ruby
# DELETE /api/v1.0/account_groups/1/delete
{
	"status": "succ"
}
# OR
{
	"status": "fail",
	"reason": [ "account group with id 1 can not be deleted" ]
}
```

<h4 id="account_groups_update">2.2.3 用户组信息更新</h4>

| Request | Response |
| :- | :- |
| PUT /api/v1.0/account_groups/:id/update | 200 OK |
| Content-Type: application/json | Content-Type: application/json |

* 请求参数
```ruby
# PUT /api/v1.0/account_groups/1/update 
{
	"access_token": "abcd",  # 用于验证请求用户身份
	"name": "new_name",
	"role_ids": [ 11 ]
}
```
* 响应代码
```ruby
{
	"status": "succ",
	"data": {
		"id": 1,
		"name": "new_name",
		"roles": [
			"id": 1,
			"application_name": "wms", 
			"name": "staff",
			"description": "staff of wms"		
		],
		"can_delete": false  # 是否能删除标志
	}
}
# OR
{
	"status": "fail",
	"reason": [ "Name has already been taken" ]
}
```

<h4 id="account_groups_show">2.2.4 单个用户组详情</h4>

| Request | Response |
| :- | :- |
| GET /api/v1.0/account_groups/:id/show | 200 OK |
| Content-Type: application/json | Content-Type: application/json |

* 请求参数
```ruby
{
	"access_token": "abcd",  # 用于验证请求用户身份
}
```
* 响应代码
```ruby
# GET /api/v1.0/account_groups/1/show
{
	"status": "succ",
	"data": {
		"id": 1,
		"name": "test_account_group_1",
		"roles": [
			"id": 8,
			"application_name": "wms", 
			"name": "admin",
			"description": "administrator of wms"		
		],
		"can_delete": false  # 是否能删除标志
	}
}
# OR
{
	"status": "fail",
	"reason": [ "account group with id 1 not found" ]
}
```

<h4 id="account_groups_index">2.2.5 用户组列表查询</h4>

| Request | Response |
| :- | :- |
| GET /api/v1.0/account_groups | 200 OK |
| Content-Type: application/json | Content-Type: application/json |

* 请求参数
```ruby
{
	"access_token": "abcd",  # 用于验证请求用户身份
	"page": 1,
	"per_page": 10,
	"q": {
		"name_cont": "test"
		"roles": {
			"name": "staff"
		}
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
			"name": "test_account_group_1",
			"roles": [
				"id": 1,
				"application_name": "wms", 
				"name": "staff",
				"description": "staff of wms"		
			],
			"can_delete": false  # 是否能删除标志
		}
	],
	"page": 1,
	"per_page": 10,
	"count": 1  # 满足搜索条件的数据总数
}
# OR
{
	"status": "fail",
	"reason": [ "some fail resons" ]
}
```

<h3 id="roles">角色管理</h3>

<h4 id="roles_show">2.3.1 单个角色详情</h4>

| Request | Response |
| :- | :- |
| GET /api/v1.0/roles/:id/show | 200 OK |
| Content-Type: application/json | Content-Type: application/json |

* 请求参数
```ruby
{
	"access_token": "abcd",  # 用于验证请求用户身份
}
```
* 响应代码
```ruby
# GET /api/v1.0/roles/12/show
{
	"status": "succ",
	"data": {
		"id": 12,
		"application_name": "wms",
		"name": "warehouse_staff",
		"description": "some description"
	}
}
# OR
{
	"status": "fail",
	"reason": [ "role with id 12 not found" ]
}
```

<h4 id="roles_index">2.3.2 角色列表查询</h4>

| Request | Response |
| :- | :- |
| GET /api/v1.0/roles | 200 OK |
| Content-Type: application/json | Content-Type: application/json |

* 请求参数
```ruby
{
	"access_token": "abcd",  # 用于验证请求用户身份
	"page": 1,
	"per_page": 10,
	"q": {
		"name_cont": "admin",
		"application": {
			"name_eq": "wms"
		}
	}
}
```
* 响应代码
```ruby
{
	"status": "succ",
	"data": [
		{
			"id": 9,
			"application_name": "wms",
			"name": "super_admin",
			"description": "some description"
		},
		{
			"id": 11,
			"application_name": "wms",
			"name": "admin",
			"description": "some description"
		}		
	],
	"page": 1,
	"per_page": 10,
	"count": 2
}
# OR
{
	"status": "fail",
	"reason": [ "some fail reasons" ]
}
```

<h3 id="channels">用户渠道管理</h3>

<h4 id="channels_create">2.4.1 渠道创建</h4>

| Request | Response |
| :- | :- |
| POST /api/v1.0/channels/create | 200 OK |
| Content-Type: application/json | Content-Type: application/json |

* 请求参数
```ruby
{
	"access_token": "abcd",  # 用于验证请求用户身份
	"name": "ETCN001"
}
```
* 响应代码
```ruby
{
	"status": "succ",
	"data": {
		"id": 1,
		"name": "ETCN001"
	}
}
# OR
{
	"status": "fail",
	"reason": [ "name has already been taken" ]
}
```

<h4 id="channels_delete">2.4.2 渠道删除</h4>
| Request | Response |
| :- | :- |
| DELETE /api/v1.0/channels/:id/delete | 200 OK |
| Content-Type: application/json | Content-Type: application/json |

* 请求参数
```ruby
{
	"access_token": "abcd",  # 用于验证请求用户身份
}
```
* 响应代码
```ruby
# DELETE /api/v1.0/channels/1/delete
{
	"status": "succ"
}
# OR
{
	"status": "fail",
	"reason": [ "channel with id 1 cannot be deleted" ]
}
```

<h4 id="channels_update">2.4.3 渠道信息更新</h4>
| Request | Response |
| :- | :- |
| PUT /api/v1.0/channels/:id/update | 200 OK |
| Content-Type: application/json | Content-Type: application/json |

* 请求参数
```ruby
# PUT /api/v1.0/channels/1/update
{
	"access_token": "abcd",  # 用于验证请求用户身份
	"name": "ETCN001U"
}
```
* 响应代码
```ruby
{
	"status": "succ",
	"data": {
		"id": 1,
		"name": "ETCN001U"
	}
}
# OR
{
	"status": "fail",
	"reason": [ "name has already been taken" ]
}
```

<h4 id="channels_show">2.4.4 单个渠道详情</h4>

| Request | Response |
| :- | :- |
| GET /api/v1.0/channels/:id/show | 200 OK |
| Content-Type: application/json | Content-Type: application/json |

* 请求参数
```ruby
{
	"access_token": "abcd",  # 用于验证请求用户身份
}
```
* 响应代码
```ruby
# GET /api/v1.0/channels/1/show
{
	"status": "succ",
	"data": {
		"id": 1,
		"name": "ETCN001"
	}
}
# OR
{
	"status": "fail",
	"reason": [ "channel with id 1 not found" ]
}
```

<h4 id="channels_index">2.4.5 渠道列表查询</h4>

| Request | Response |
| :- | :- |
| GET /api/v1.0/channels | 200 OK |
| Content-Type: application/json | Content-Type: application/json |

* 请求参数
```ruby
{
	"access_token": "abcd",  # 用于验证请求用户身份
	"page": 1,
	"per_page": 10,
	"q": {
		"name_cont": "ETCN"
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
			"name": "ETCN001"
		},
		{
			"id": 2,
			"name": "ETCN002"
		}
	],
	"page": 1,
	"per_page": 10,
	"count": 2
}

```

<h2 id="appendix">附录</h2>
<h3 id="filter_rules">Filter Rules</h3>

| matcher | example | rule | query_syntax |
| :- | :- | :- | :- |
| (blank) | name | equal to | name = ? |
| eq | name_eq | equal to | name = ? |
| in | name_in | in | name in (?) |
| cont | name_cont | contain | name like ? |
| gt | name_gt | greater than | name > ? |
| gteq | name_gteq | greater than or equal to | name >= ? |
| lt | name_lt | less than | name < ? |
| lteq | name_lteq | less than or equal to | name <= ? |
