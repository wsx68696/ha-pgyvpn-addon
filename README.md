# Home Assistant 蒲公英组网 Add-on

> ## ⚠️ 非官方项目声明
>
> 本项目是**第三方社区项目**，由个人维护，**与上海贝锐信息科技股份有限公司没有任何
> 隶属关系**，也**未获得贝锐的授权、认可或背书**。
>
> - 本项目**不是**贝锐官方发布的 Home Assistant 加载项。遇到问题请在本仓库提 issue，
>   **不要**向贝锐官方客服寻求支持。
> - 「蒲公英」「贝锐蒲公英」「PgyVPN」「Oray」等名称与图形标志是贝锐的商标，
>   本项目仅以描述性方式使用，以说明所集成的客户端来源。
> - 加载项内分发的贝锐蒲公英客户端二进制**版权归贝锐所有**，本项目仅作集成与
>   分发，未修改其二进制。若权利人提出异议，将立即移除相关资源。
> - 使用风险自负。本项目不对因加入虚拟网络导致的网络暴露、路由变更或数据可访问性
>   承担责任。

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

## 许可与权利

- 本仓库的加载项**封装代码**（Dockerfile、s6 服务脚本、仓库元数据等）以 MIT 许可发布。
- 贝锐蒲公英客户端二进制（`pgyvisitor`、`pgyvpn_svr`）版权归上海贝锐信息科技股份
  有限公司所有，本项目仅作集成与分发，不修改其二进制。
- `icon.png`、`logo.png` 取自贝锐官方客户端与官网，来源与权利说明见
  [`pgyvpn/BRAND-ASSETS.md`](pgyvpn/BRAND-ASSETS.md)。
- 本项目与贝锐无隶属关系，详见上方**非官方项目声明**。
