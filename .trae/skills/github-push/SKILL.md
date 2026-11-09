---
name: github-push
description: 将当前项目提交commit并push到GitHub远端仓库. Use when the user asks to commit and push, 提交到github, 推送代码, 或同步到远端. Do not use for local-only commit operations without push intent.
---

# GitHub Push

将当前工作目录的变更提交到 GitHub 远端仓库 `git@github.com:15641546212/-myq1.git`。

## 前置检查

1. 确认当前目录是否已是 git 仓库（`git rev-parse --is-inside-work-tree`）。若不是，执行 `git init`。
2. 确认远端是否已配置（`git remote -v`）。若无 origin，执行：
   ```
   git remote add origin git@ssh.github.com:15641546212/-myq1.git
   ```
3. 检查本地 user.name 和 user.email 是否已设置。

## SSH 配置（关键）

本环境默认 22 端口被防火墙拦截，SSH 连接 GitHub 必须走 443 端口。

已配置的全局设置：
```
git config --global url."git@ssh.github.com:".insteadOf "git@github.com:"
git config --global core.sshCommand "ssh -p 443"
```

验证 SSH 是否可用：
```
ssh -T git@ssh.github.com -p 443
```
应返回 `Hi 15641546212! You've successfully authenticated`。

## 提交流程

```
git branch -M main
git fetch origin
git add -A
git commit -m "描述性提交信息"
git pull --rebase origin main
git push -u origin main
```

## 冲突处理

当 `git pull --rebase` 出现冲突（常见于远端同名文件已存在）：
```
git checkout --theirs <文件路径>   # 用本地版本
git checkout --ours <文件路径>     # 用远端版本
git add <文件路径>
git rebase --continue
```

注意：当前环境无交互式编辑器，若 rebase --continue 报 "EDITOR unset"，设置临时编辑器：
```
$env:GIT_EDITOR="true"
git rebase --continue
```

## 完成态输出

Push 成功后必须输出：
- 远端 commit 哈希（`git rev-parse origin/main`）
- 推送范围（如 `48ae154..6b9b38d`）
- 远端仓库地址
