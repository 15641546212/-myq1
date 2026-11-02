---
name: git-push-github-myq
description: Commit all changes and push this project to the GitHub repo wangyaojsj/wangyao over SSH. Use when the user says 提交到github(马宇乾), 提交到我的github, 推送到myq仓库, push to wangyao. Do not use for Gitee or the other GitHub repo ninini929/niminghao.
---

# 提交到 GitHub（马宇乾仓库）

将本项目全部改动 commit 并 push 到 GitHub 仓库 `wangyaojsj/wangyao`，使用本机已配置的 ed25519 SSH 公钥（myq-24001010607）认证。

## 执行步骤

1. 预检（不改动任何文件，验证 SSH 认证与仓库可达性）：
   ```powershell
   powershell -ExecutionPolicy Bypass -File .trae\skills\git-push-github-myq\scripts\push-github-myq.ps1 -Check
   ```

2. 提交并推送：
   ```powershell
   powershell -ExecutionPolicy Bypass -File .trae\skills\git-push-github-myq\scripts\push-github-myq.ps1 -Message "本次改动说明"
   ```

`-Message` 可省略，省略时自动生成 `项目更新 yyyy-MM-dd HH:mm`。

## 脚本行为（push-github-myq.ps1 已固化，勿在会话里手工复刻）

- 仓库不存在 `.git` 时自动 `git init` 并把分支指向 `main`
- 远程名是 **`github-myq`**（与已有的 `origin` Gitee、`github` ninini929 并存互不干扰）
- 远程 URL 走 `ssh://git@ssh.github.com:443/wangyaojsj/wangyao.git`——**必须走 443 端口的 SSH 官方通道**：本机 hosts 把 `github.com` 屏蔽到 127.0.0.1，直连 22 端口会挂起；`ssh.github.com:443` 未被屏蔽，是 GitHub 官方支持的 SSH 备用入口
- SSH 命令显式指定 `IdentityFile=~/.ssh/id_ed25519`（刚生成的 myq-24001010607 公钥），避免多密钥场景下选错
- `git add -A` 后若无暂存变更则跳过 commit
- 推送被拒（non-fast-forward）时执行 `git pull --rebase` 后重试一次；**禁止 force push**
- SSH 非交互化：`StrictHostKeyChecking=accept-new` + `BatchMode=yes` + `ConnectTimeout=15`，认证失败快速报错不挂起

## 前置条件

- 本机 `~/.ssh/id_ed25519.pub` 的公钥已粘贴到 GitHub 账号 `wangyaojsj` → Settings → SSH and GPG keys
- 公钥内容：`ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPcl81xVtPyko213QYDdRp7XosgXMmJRMGK3nKgri9Sk myq-24001010607`

## 安全约束

- 本 skill 目录不包含任何令牌，纯 SSH 公钥认证
- 禁止在提示词日志 `myq_prompt.md` 中写入私钥
