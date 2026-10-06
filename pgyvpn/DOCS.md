# 蒲公英组网 Add-on

> ## ⚠️ 非官方项目
>
> 本加载项是**第三方社区项目**，由个人维护，**与上海贝锐信息科技股份有限公司无任何
> 隶属关系**，**未获贝锐授权、认可或背书**。它不是贝锐官方发布的 Home Assistant
> 加载项；遇到问题请到本项目仓库提 issue，**请不要联系贝锐官方客服**。
>
> 「蒲公英」「贝锐蒲公英」「PgyVPN」「Oray」等名称与标志为贝锐的商标，此处仅作
> 描述性使用。加载项内的客户端二进制版权归贝锐所有。使用风险自负。

此 Add-on 让运行 Home Assistant OS 的主机作为一个蒲公英软件成员加入贝锐蒲公英虚拟网络。

它使用贝锐官方客户端二进制（`pgyvisitor`、`pgyvpn_svr`），但**运行在 Home Assistant 官方
加载项基础镜像上**（`ghcr.io/hassio-addons/base`），并用 `s6-overlay` 管理服务。

它不配置蒲公英路由器，也不自动把 HAOS 所在局域网发布成旁路网段。

## 安装

1. 在加载项商店右上角菜单 → **仓库**，添加本仓库地址。
2. 从商店安装「蒲公英组网」。
3. 进入加载项的 **配置**，填写贝锐账号（或 UID）和密码。
4. 保存后启动加载项，然后在蒲公英管理端把新成员加入需要的网络。

也可以把整个 `pgyvpn` 文件夹复制到 HAOS 的 `/addons/` 下，再从商店右上角菜单
选择 **重新加载**。在 HAOS 上访问 `/addons` 通常需要先安装并配置 Samba Share，
或使用其他能访问 HAOS `addons` 目录的方式。

## 管理入口

在加载项页面点击 **打开 Web UI**，进入受 Home Assistant Ingress 保护的入口页面，
再点击按钮打开[蒲公英控制台](https://console.sdwan.oray.com/)。控制台在新标签页打开，
由贝锐蒲公英账号单独登录；Home Assistant 登录不会替代蒲公英登录。

## 网络和权限

客户端使用 HAOS 的宿主机网络命名空间（`host_network: true`），并需要 `/dev/net/tun`
与 `NET_ADMIN`、`NET_RAW` 能力来创建蒲公英虚拟网卡和路由。

该设置会让 HAOS 主机加入蒲公英网络；Home Assistant Core 与共享主机网络的服务可以按
路由访问组网成员。客户端仍拥有修改 HAOS 主机网络路由的能力。

这不会自动让家庭局域网内的其他设备经由 HAOS 转发流量。旁路网段、回程路由和 IP 转发
需要按蒲公英网络及家庭路由器拓扑另行配置。若 HAOS 没有 `/dev/net/tun`，请确认所用
HAOS 内核提供 TUN 支持。

## 配置与日志

- `username`：贝锐账号或 UID。
- `password`：该账号的密码。
- 客户端配置和日志存放在加载项的持久化 `/data` 目录中
  （`/etc/oray/pgyvpn` 与 `/var/log/oray` 均软链接到 `/data`），
  重新构建或更新加载项后登录状态保留。
- 账号密码通过 `/data/options.json` 读取，启动脚本不会把密码写入日志。
- 凭据仍会保存在 Home Assistant 的加载项配置中，请妥善保护备份。

## 服务管理

服务由 `s6-overlay` 守护，共三个单元：

| 单元 | 作用 |
|---|---|
| `pgyvpn` | 启动 `pgyvpn_svr` 守护进程，并守候其存活；退出后由 s6 重启 |
| `pgyvpn-monitor` | 登录账号，并在 `oray_vnc` 网卡消失时触发重连 |
| `nginx` | 提供 Ingress 管理页（仅监听 8099，仅允许 Supervisor 代理访问） |

日志直接进入加载项日志页面。

## 支持架构

`amd64`、`aarch64`，与官方基础镜像 `ghcr.io/hassio-addons/base` 提供的架构一致。

> 1.0.x 曾声明 `armv7`。`armv7` 已被 Supervisor 标记为废弃架构，且官方基础镜像不提供
> 32 位 ARM 变体，因此 2.0.0 起不再支持。
