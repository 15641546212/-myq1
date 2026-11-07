# push-github.ps1 — 提交到 GitHub skill 的确定性执行脚本（PowerShell 5 兼容，SSH 公钥认证）
# 用法:
#   预检:        .\push-github.ps1 -Check
#   提交并推送:  .\push-github.ps1 -Message "改动说明"
param(
    [string]$Message = "",
    [switch]$Check
)

$ErrorActionPreference = "Stop"
# 走 443 端口的 SSH 官方通道：本机 hosts 将 github.com:22 屏蔽到 127.0.0.1，
# 而 ssh.github.com 未被屏蔽，GitHub 官方支持经 ssh.github.com:443 的 SSH 认证
$RepoUrl    = "ssh://git@ssh.github.com:443/ninini929/niminghao.git"
$RemoteName = "github"   # origin 已被 Gitee 占用，GitHub 使用独立远程名
$Branch     = "main"

# SSH 非交互化：自动接受新主机指纹、禁止交互输密码（认证失败快速报错，避免挂起）
$env:GIT_SSH_COMMAND = "ssh -o StrictHostKeyChecking=accept-new -o BatchMode=yes -o ConnectTimeout=15"

function Write-Step($msg) { Write-Host "[git-push-github] $msg" }
function Fail($msg) { Write-Host "[git-push-github] 错误: $msg" -ForegroundColor Red; exit 1 }

# 1) git 可用性
try { $null = git --version } catch { Fail "未找到 git，请先安装" }
Write-Step ("git: " + (git --version))

# 2) 初始化仓库（若无 .git）
if (-not (Test-Path ".git")) {
    if ($Check) {
        Write-Step "预检: 当前目录尚未 git init（提交时会自动初始化，分支 $Branch）"
    } else {
        Write-Step "初始化 git 仓库..."
        git init | Out-Null
        git checkout -b $Branch 2>$null | Out-Null
    }
}

# 3) 已有仓库时跟随当前分支
if (Test-Path ".git") {
    $cur = git rev-parse --abbrev-ref HEAD 2>$null
    if ($cur -and $cur -ne "HEAD") { $Branch = $cur }
    Write-Step "当前分支: $Branch"
}

# ---------- 预检模式 ----------
if ($Check) {
    Write-Step "预检: 测试 SSH 公钥认证与远端连通性..."
    git ls-remote $RepoUrl HEAD
    if ($LASTEXITCODE -eq 0) {
        Write-Host "[git-push-github] 预检通过：SSH 认证有效，仓库可达" -ForegroundColor Green
    } else {
        Fail "无法访问远端仓库（请确认公钥已加入 GitHub 账号 ninini929）"
    }
    exit 0
}

# ---------- 提交推送 ----------
# 4) 确认远程（远程名 github，不占用 origin）
$remotes = git remote
if ($remotes -notcontains $RemoteName) {
    Write-Step "配置远程 $RemoteName → $RepoUrl"
    git remote add $RemoteName $RepoUrl
}

# 5) 提交
git add -A
$staged = git diff --cached --name-only
if (-not $staged) {
    Write-Step "工作区无变更，跳过 commit"
} else {
    if (-not $Message) { $Message = "项目更新 " + (Get-Date -Format "yyyy-MM-dd HH:mm") }
    Write-Step "提交 $($staged.Count) 个文件变更..."
    git commit -m $Message
    if ($LASTEXITCODE -ne 0) { Fail "commit 失败" }
}

# 6) 推送（被拒则 pull --rebase 重试一次；禁止 force push）
Write-Step "推送到 $RemoteName/$Branch ..."
git push -u $RemoteName $Branch
if ($LASTEXITCODE -ne 0) {
    Write-Step "推送被拒，尝试 pull --rebase 后重试..."
    git pull --rebase $RemoteName $Branch
    if ($LASTEXITCODE -ne 0) { Fail "pull --rebase 失败，请手动处理冲突后重试" }
    git push -u $RemoteName $Branch
    if ($LASTEXITCODE -ne 0) { Fail "推送失败" }
}

Write-Host "[git-push-github] 完成：已推送到 $RepoUrl ($Branch)" -ForegroundColor Green
