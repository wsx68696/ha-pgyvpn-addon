# Home Assistant 蒲公英组网 Add-on

让 Home Assistant OS 主机加入贝锐蒲公英（PgyVPN）虚拟网络的加载项仓库。

Add-on 位于 [`pgyvpn/`](pgyvpn/)。它使用贝锐官方客户端二进制，但运行在
**Home Assistant 官方加载项基础镜像** `ghcr.io/hassio-addons/base` 上，
服务由 `s6-overlay` 管理。

## 添加到 Home Assistant

在 Home Assistant 打开 **设置 → 加载项 → 加载项商店 → 右上角菜单 → 仓库**，添加：

```text
https://github.com/wsx68696/ha-pgyvpn-addon
```

安装「蒲公英组网」，填写贝锐账号或 UID 及密码，然后启动加载项。
完整说明见 [`pgyvpn/DOCS.md`](pgyvpn/DOCS.md)。

## 本地安装（无法访问 GitHub 时）

把 `pgyvpn/` 整个目录复制到 HAOS 的 `/addons/` 下，然后在加载项商店右上角菜单
选择 **重新加载**，即可在「本地加载项」中看到它。这种方式不需要访问 GitHub。

## 架构

`amd64`、`aarch64`。

## 技术要点

- 客户端二进制 `pgyvisitor` / `pgyvpn_svr` 由多阶段构建
  `COPY --from=bestoray/pgyvpn:2.4.0` 提取。已确认它们面向 musl 构建
  （解释器 `/lib/ld-musl-x86_64.so.1`），因此可以在官方 Alpine 基础镜像上运行。
- 不使用第三方镜像的 `/etc`、OpenRC 或 dpkg 状态，只取客户端文件本身。
- 不覆盖 `/etc/apk/repositories`：使用基础镜像自带、与其 ABI 匹配的软件源。

## 许可

本仓库的加载项封装代码以 MIT 许可发布。贝锐蒲公英客户端二进制版权归
上海贝锐信息科技股份有限公司所有，本项目仅做分发与集成，不修改其二进制。
