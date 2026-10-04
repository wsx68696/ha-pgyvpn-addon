# Home Assistant OS 蒲公英组网 Add-on

这是一个可作为 GitHub 自定义仓库发布的 Home Assistant Add-on 仓库。Add-on 位于 [`pgyvpn/`](pgyvpn/)，基于贝锐官方 `bestoray/pgyvpn:2.4.0` 镜像。

## 上传到 GitHub

1. 在 GitHub 创建一个空仓库，例如 `ha-pgyvpn-addon`。
2. 在此目录打开终端，添加 GitHub 远端并推送：

   ```sh
   git remote add origin https://github.com/wsx68696/ha-pgyvpn-addon.git
   git push -u origin main
   ```

## 添加到 Home Assistant

在 Home Assistant 打开 **设置 → 加载项 → 加载项商店 → 右上角菜单 → 仓库**，添加：

```text
https://github.com/wsx68696/ha-pgyvpn-addon
```

安装“蒲公英组网”，填写贝锐账号或 UID 及密码，然后启动 Add-on。完整使用说明见 [`pgyvpn/DOCS.md`](pgyvpn/DOCS.md)。

## 支持架构

`amd64`、`aarch64`、`armv7`。
