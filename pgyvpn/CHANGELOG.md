# 更新日志

## 2.0.0

向官方加载项规范重构，构建不再依赖第三方镜像的 Alpine 环境。

- **换用官方基础镜像** `ghcr.io/hassio-addons/base`（在 `build_from` 中声明，
  按架构区分 aarch64 / amd64）。不再把第三方镜像当作运行环境。
- **修复构建失败的根因**：旧版 Dockerfile 把基础镜像自带的软件源覆盖成
  `latest-stable`，而基础镜像是 Alpine 3.16.3，`latest-stable` 当时已是
  Alpine 3.24，musl/OpenSSL ABI 不兼容导致 `apk add` 无法解析依赖。
  现在使用官方基础镜像自带的、与其自身 ABI 匹配的软件源。
- **客户端二进制迁移方式变更**：不再 `dpkg -i` 安装 Debian 包，改为从
  官方客户端镜像多阶段 `COPY --from` 提取 `/usr/sbin/pgyvisitor`、
  `/usr/sbin/pgyvpn_svr` 和 `/usr/share/pgyvpn`。
  已验证这两个二进制是为 musl/Alpine 构建的
  （解释器 `/lib/ld-musl-x86_64.so.1`），因此可以脱离原镜像运行。
- **服务管理改用 s6-overlay**，移除 `run.sh` 与对 OpenRC `service` 命令的依赖。
  客户端进程异常退出会由 s6 自动重启。
- **移除 armv7**：官方基础镜像不提供 32 位 ARM 变体。
- **新增** `icon.png`、`logo.png`、`translations/`、`CHANGELOG.md`，
  并补齐 `io.hass.name` / `io.hass.description` 镜像标签。
- **Ingress 端口保持 8099**，并仅允许 Supervisor 代理 `172.30.32.2` 访问。
- **换用贝锐官方图标**：`icon.png` 取自官方 Windows 客户端
  `PgyVisitorEnt_6.15.8.33010_x64.exe` 的 `RT_ICON` 资源（id 6，128×128 32bpp，
  原生尺寸未缩放）；`logo.png` 使用贝锐官网横版组合标。来源与权利说明见
  [`BRAND-ASSETS.md`](BRAND-ASSETS.md)。

### 开发过程中修掉的问题

- **s6 服务未启动**：服务单元定义在 `s6-rc.d/` 下，但没有注册进
  `s6-overlay/user-bundles.d/user/contents.d/`，s6-rc 不会拉起它们。
  已补上 `pgyvpn`、`pgyvpn-monitor`、`nginx` 三个注册条目。
- **`bashio::log.*` 报 command not found**：s6 的 `run` 脚本不会自动 `source`
  bashio 库。已全部改用普通 `echo`，去掉对 bashio 的依赖。
- **缺少运行时共享库**：`pgyvpn_svr` / `pgyvisitor` 的完整 `DT_NEEDED` 为
  `libstdc++.so.6`、`libuuid.so.1`、`libgcc_s.so.1`、`libc.musl-x86_64.so.1`。
  早期只装了 `libstdc++`，导致容器启动时报
  `Error loading shared library libuuid.so.1`。已补装 `libuuid` 与 `libgcc`。
- **`pgyvpn` 服务改为前台运行** `pgyvpn_svr`（不再传 `-d` 守护化参数），
  使 s6 监管客户端进程本身，而不是一个立刻退出的父进程。

### 升级提示

本版本把配置与日志的持久化位置统一到 `/data`（`/etc/oray/pgyvpn`
与 `/var/log/oray` 软链接到 `/data`）。若从 1.0.x 升级且已有登录状态，
重新填写账号密码即可。

## 1.0.3

- 修复构建失败：不再把基础镜像自带的 Alpine v3.16 软件源覆盖成 `latest-stable`。
  基础镜像 `bestoray/pgyvpn:2.4.0` 基于 Alpine 3.16.3，而 `latest-stable` 当前已是
  Alpine 3.24，两者的 musl/OpenSSL ABI 不兼容，会导致 `apk add jq nginx` 无法解析依赖。

## 1.0.2

- 增加 Home Assistant Ingress 管理入口，并提供蒲公英控制台链接。
- 扩展 AppArmor 规则以限制 Nginx 管理页面，并让 Nginx 使用不含 NET_ADMIN 的子配置。
- 说明官方客户端输出的命令行密码警告。

## 1.0.1

- 启用蒲公英客户端专用 AppArmor 配置。
- 修正首次迁移配置或日志失败时仍删除原目录的问题。

## 1.0.0

- 首个版本：基于贝锐官方 `bestoray/pgyvpn` 镜像，让 HAOS 主机加入蒲公英虚拟网络。
