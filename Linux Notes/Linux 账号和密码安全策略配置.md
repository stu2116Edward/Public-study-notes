# Linux 账号和密码安全策略配置

## CentOS 账号和密码安全策略配置
CentOS 7/RHEL 7 使用 pam_pwquality 模块来控制密码复杂度策略  
配置文件：/etc/pam.d/system-auth 和 /etc/pam.d/password-auth  
### 1. 配置文件：`/etc/pam.d/system-auth`
此文件用于定义系统认证策略，包括密码验证(**实际操作中修改密码只需要改这个配置文件里的内容就可以了**)

**使用方法**：
编辑 system-auth 配置文件
```bash
sudo gedit /etc/pam.d/system-auth
```

**普通密码配置示例**：
```bash
password requisite pam_pwquality.so try_first_pass local_users_only retry=3 authtok_type=
minlen=8 lcredit=-1 ucredit=-1 dcredit=-1 ocredit=-1 difok=5 enforce_for_root

```
- **参数说明**：
  - `minlen=8`：密码长度至少为8位。
  - `lcredit=-1`：至少包含一个小写字母。
  - `ucredit=-1`：至少包含一个大写字母。
  - `dcredit=-1`：至少包含一个数字。
  - `ocredit=-1`：至少包含一个特殊字符。
  - `difok=5`：新密码最多与旧密码重复5个字符。
  - `enforce_for_root`：对 root 用户也强制执行密码复杂度策略。

**弱密码配置示例**：
```bash
password requisite pam_pwquality.so retry=3 minlen=6 dcredit=-1 lcredit=0 ucredit=0 ocredit=0
```
- **参数说明**：
  - `retry=3`：用户有3次尝试输入密码的机会。
  - `minlen=6`：密码的最小长度为6个字符。
  - `dcredit=-1`：密码必须包含至少一个数字。
  - `lcredit=0`：不强制包含小写字母。
  - `ucredit=0`：不强制包含大写字母。
  - `ocredit=0`：不强制包含特殊字符。

### 2. 配置文件：`/etc/pam.d/password-auth`
此文件专门处理密码更改操作

**使用方法**：
编辑 password-auth 配置文件
```bash
sudo gedit /etc/pam.d/password-auth
```

**密码更改配置示例**：
```bash
password requisite pam_pwquality.so retry=3 minlen=6 dcredit=-1 lcredit=0 ucredit=0 ocredit=0
```
- **参数说明**：
  - 与 `/etc/pam.d/system-auth` 中的弱密码配置相同，这里也允许6位数字的弱密码。

### 注意事项

- **配置一致性**：确保 `/etc/pam.d/system-auth` 和 `/etc/pam.d/password-auth` 中的配置一致，以避免密码策略冲突。
- **服务重启**：更改这些配置文件后，可能需要重启相关服务（如 SSH）或整个系统以使更改生效。
- **安全性**：虽然可以配置弱密码策略，但出于安全考虑，建议使用强密码策略。


### 2. 密码有效期
密码有效期可以通过 `/etc/login.defs` 文件来管理。

- **配置文件**：`/etc/login.defs`

```bash
# 编辑登录定义文件
sudo vim /etc/login.defs

# 配置策略
PASS_MAX_DAYS 180
PASS_MIN_DAYS 0
PASS_MIN_LEN 8
PASS_WARN_AGE 15
```

- `PASS_MAX_DAYS`：密码的最大有效期。
- `PASS_MIN_DAYS`：密码的最小更改间隔。
- `PASS_MIN_LEN`：密码的最小长度。
- `PASS_WARN_AGE`：在密码过期前多少天开始警告用户。

### 3. 登录会话超时
设置会话超时，使会话在一定时间内无活动后自动退出。

- **配置文件**：`/etc/profile`

```bash
# 编辑全局配置文件
sudo gedit /etc/profile

# 设置会话超时时间为10分钟（600秒）
TMOUT=600
source /etc/profile
```

### 4. 登录失败锁定
设置登录失败策略，当用户连续输错密码达到一定次数后锁定账号。

- **配置文件**：`/etc/pam.d/system-auth`

```bash
# 编辑 system-auth 配置文件
sudo gedit /etc/pam.d/system-auth

# 添加或修改以下行
auth required pam_tally2.so onerr=fail deny=5 unlock_time=600 root_unlock_time=600
```

- `deny=5`：允许的失败登录尝试次数。
- `unlock_time=600`：账号锁定时间为600秒（10分钟）。

### 注意事项
- 以上设置只针对新用户生效，对于原有用户，可以使用 `chage -M 180 root` 命令设置密码有效期。
- 对于 SSH 远程登录的账号锁定，需要在 `/etc/pam.d/sshd` 文件中进行相同的 `pam_tally2.so` 配置。
- 配置文件的更改可能需要重新启动服务或系统才能生效。

当然，以下是针对 Ubuntu 系统的账号和密码安全策略配置的详细操作笔记：



## Ubuntu 账号和密码安全策略配置
Ubuntu 使用 `pam_pwquality` 模块来控制密码复杂度策略。

### 1. 密码复杂度
配置文件：`/etc/pam.d/common-password`

**使用方法**：
```bash
# 编辑 common-password 配置文件
sudo gedit /etc/pam.d/common-password
```

**普通密码配置示例**：
```bash
password requisite pam_pwquality.so retry=3 minlen=8 lcredit=-1 ucredit=-1 dcredit=-1 ocredit=-1 difok=5
```
- **参数说明**：
  - `minlen=8`：密码长度至少为8位。
  - `lcredit=-1`：至少包含一个小写字母。
  - `ucredit=-1`：至少包含一个大写字母。
  - `dcredit=-1`：至少包含一个数字。
  - `ocredit=-1`：至少包含一个特殊字符。
  - `difok=5`：新密码最多与旧密码重复5个字符。

**弱密码配置示例**：
```bash
password requisite pam_pwquality.so retry=3 minlen=6 dcredit=-1 lcredit=0 ucredit=0 ocredit=0
```
- **参数说明**：
  - `retry=3`：用户有3次尝试输入密码的机会。
  - `minlen=6`：密码的最小长度为6个字符。
  - `dcredit=-1`：密码必须包含至少一个数字。
  - `lcredit=0`：不强制包含小写字母。
  - `ucredit=0`：不强制包含大写字母。
  - `ocredit=0`：不强制包含特殊字符。

### 2. 密码有效期
密码有效期可以通过 `chage` 命令和 `/etc/login.defs` 文件来管理。

**配置文件**：`/etc/login.defs`

```bash
# 编辑登录定义文件
sudo gedit /etc/login.defs
```

**配置策略**：
```bash
PASS_MAX_DAYS   180
PASS_MIN_DAYS   0
PASS_MIN_LEN    8
PASS_WARN_AGE   15
```
- `PASS_MAX_DAYS`：密码的最大有效期。
- `PASS_MIN_DAYS`：密码的最小更改间隔。
- `PASS_MIN_LEN`：密码的最小长度。
- `PASS_WARN_AGE`：在密码过期前多少天开始警告用户。

### 3. 登录会话超时
设置会话超时，使会话在一定时间内无活动后自动退出。

**配置文件**：`/etc/profile`
编辑全局配置文件
```bash
sudo gedit /etc/profile
```

**设置会话超时时间为10分钟（600秒）**：
```bash
TMOUT=600
source /etc/profile
```

### 4. 登录失败锁定
设置登录失败策略，当用户连续输错密码达到一定次数后锁定账号。

**配置文件**：`/etc/pam.d/common-auth`
编辑 common-auth 配置文件
```bash
sudo gedit /etc/pam.d/common-auth
```

**添加或修改以下行**：
```bash
auth required pam_tally2.so onerr=fail deny=5 unlock_time=600
```
- `deny=5`：允许的失败登录尝试次数。
- `unlock_time=600`：账号锁定时间为600秒（10分钟）。

### 注意事项
- 以上设置只针对新用户生效，对于原有用户，可以使用 `chage -M 180 root` 命令设置密码有效期。
- 对于 SSH 远程登录的账号锁定，需要在 `/etc/pam.d/sshd` 文件中进行相同的 `pam_tally2.so` 配置。
- 配置文件的更改可能需要重新启动服务或系统才能生效。
