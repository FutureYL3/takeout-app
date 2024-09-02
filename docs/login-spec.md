# 外卖 app 端 —— 登录相关接口文档

## 账号密码登录

**参数列表：**

| 参数名     | 含义             | 说明   |
| ---------- | ---------------- | ------ |
| `phone`    | 手机号（即账号） | 字符串 |
| `password` | 密码             | 字符串 |

**举例：**

```json
{
    "phone": "17282138462",
    "password": "123456"
}
```



**返回数据列表：**

| 参数名         | 含义                         | 说明   |
| -------------- | ---------------------------- | ------ |
| `accessToken`  | `jwt` 访问令牌               | 字符串 |
| `refreshToken` | `jwt` 刷新令牌               | 字符串 |
| `isSuccess`    | 是否成功登录                 | 布尔值 |
| `msg`          | 错误提示信息（如果登录失败） | 字符串 |

**举例：**

```json
{
    "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxODU4ODYwMjYxNiIsIm5hbWUiOiJaZW5nIFhpYW5nbGluIiwiaWF0IjoxNTE2MjM5MDIyfQ.e9PD35YfzJA9od-w4HsgPrLI2epHRzMSqLb5WNXaIks",
    "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxODU4ODYwMjYxNiIsImlhdCI6MTUxNjIzOTAyMn0._fceiBH6ZVkG9T2BlBwcbY75uxMKJObrw8NK6UyV-II",
    "isSuccess": true,
    "msg": "" // 登录成功，不需要错误信息
}
```



## 短信验证码登录

### 获取验证码

**参数列表：**

| 参数名  | 含义   | 说明   |
| ------- | ------ | ------ |
| `phone` | 手机号 | 字符串 |

**举例：**

```json
{
    "phone": "17282138462"
}
```



**返回数据列表：**

| 参数名      | 含义                               | 说明   |
| ----------- | ---------------------------------- | ------ |
| `isSuccess` | 是否成功发送验证码                 | 布尔值 |
| `msg`       | 错误提示信息（如果获取验证码失败） | 字符串 |

**举例：**

```json
{
    "isSuccess": true,
    "msg": "" // 获取验证码成功，不需要错误信息
}
```



### 登录

**参数列表：**

| 参数名  | 含义       | 说明   |
| ------- | ---------- | ------ |
| `phone` | 手机号     | 字符串 |
| `code`  | 短信验证码 | 字符串 |

**举例：**

```json
{
    "phone": "17282138462",
    "code": "273821"
}
```



**返回数据列表：**

| 参数名         | 含义                         | 说明   |
| -------------- | ---------------------------- | ------ |
| `accessToken`  | `jwt` 访问令牌               | 字符串 |
| `refreshToken` | `jwt` 刷新令牌               | 字符串 |
| `isSuccess`    | 是否成功登录                 | 布尔值 |
| `msg`          | 错误提示信息（如果登录失败） | 字符串 |

**举例：**

```json
{
    "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxODU4ODYwMjYxNiIsIm5hbWUiOiJaZW5nIFhpYW5nbGluIiwiaWF0IjoxNTE2MjM5MDIyfQ.e9PD35YfzJA9od-w4HsgPrLI2epHRzMSqLb5WNXaIks",
    "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxODU4ODYwMjYxNiIsImlhdCI6MTUxNjIzOTAyMn0._fceiBH6ZVkG9T2BlBwcbY75uxMKJObrw8NK6UyV-II",
    "isSuccess": true,
    "msg": "" // 登录成功，不需要错误信息
}
```



## 微信登录

**参数列表：**

| 参数名   | 含义               | 说明   |
| -------- | ------------------ | ------ |
| `openID` | 微信用户的唯一标识 | 字符串 |

**举例：**

```json
{
    "openID": "OPENID" // 真实的openid是一串数字字母串
}
```



**返回数据列表：**

| 参数名         | 含义                         | 说明   |
| -------------- | ---------------------------- | ------ |
| `accessToken`  | `jwt` 访问令牌               | 字符串 |
| `refreshToken` | `jwt` 刷新令牌               | 字符串 |
| `isSuccess`    | 是否成功登录                 | 布尔值 |
| `msg`          | 错误提示信息（如果登录失败） | 字符串 |

**举例：**

```json
{
    "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxODU4ODYwMjYxNiIsIm5hbWUiOiJaZW5nIFhpYW5nbGluIiwiaWF0IjoxNTE2MjM5MDIyfQ.e9PD35YfzJA9od-w4HsgPrLI2epHRzMSqLb5WNXaIks",
    "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxODU4ODYwMjYxNiIsImlhdCI6MTUxNjIzOTAyMn0._fceiBH6ZVkG9T2BlBwcbY75uxMKJObrw8NK6UyV-II",
    "isSuccess": true,
    "msg": "" // 登录成功，不需要错误信息
}
```

