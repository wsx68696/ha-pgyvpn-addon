# 蒲公英组网 Add-on

此 Add-on 使用贝锐官方 Docker 客户端 `bestoray/pgyvpn:2.4.0`，让运行 Home Assistant OS 的主机作为一个蒲公英软件成员加入虚拟网络。它不配置蒲公英路由器，也不自动把 HAOS 所在局域网发布成旁路网段。

## 安装

1. 将整个 `pgyvpn` 文件夹复制到 HAOS 的 `/addons/local/pgyvpn/`。
2. 在 Home Assistant 中打开 **设置 → 加载项 → 加载项商店**，从右上角菜单选择 **重新加载**。
3. 在本地加载项中打开“蒲公英组网”，安装后进入 **配置**，填写贝锐账号（或 UID）和密码。
4. 保存配置并启动 Add-on。在蒲公英管理端将新成员加入需要的网络。

在 HAOS 上访问 `/addons` 通常需要先安装并配置 Samba Share，或者使用其他能访问 HAOS `addons` 目录的方式。

## 网络和权限

客户端使用 HAOS 的宿主机网络命名空间，并需要 `/dev/net/tun` 与 `NET_ADMIN` 能力来创建蒲公英虚拟网卡和路由。为允许官方客户端修改网络接口和路由，此 Add-on 关闭了 AppArmor 限制。该设置会让 HAOS 主机加入蒲公英网络；Home Assistant Core 与共享主机网络的服务可以按路由访问组网成员。客户端拥有修改 HAOS 主机网络路由的能力。

这不会自动让家庭局域网内的其他设备经由 HAOS 转发流量。旁路网段、回程路由和 IP 转发需要按蒲公英网络及家庭路由器拓扑另行配置。若 HAOS 没有 `/dev/net/tun`，请确认所用 HAOS 内核提供 TUN 支持。

## 配置与日志

- `username`：贝锐账号或 UID。
- `password`：该账号的密码。
- 客户端配置和日志存放在 Add-on 的持久化 `/data` 目录中。
- 账号密码通过环境变量交给官方启动程序，不会由启动脚本写入日志。凭据仍会保存在 Home Assistant 的 Add-on 配置中，请妥善保护备份。

## 支持架构

`amd64`、`aarch64` 和 `armv7`，与贝锐官方 `bestoray/pgyvpn:2.4.0` 镜像提供的架构一致。
