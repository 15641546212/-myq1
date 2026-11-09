# push-github-mayuqian.ps1 — 提交到 GitHub（mayuqian 仓库）skill 的确定性执行脚本
# 作者：马宇乾 | 建立时间：2026-11-02 14:59 | 使用模型：GLM-5.3-Flash
# 功能：将本项目 commit 并 push 到 15641546212/mayuqian，走 ssh.github.com:443 绕过 hosts 屏蔽
# 用法:
#   预检:        .\push-github-mayuqian.ps1 -Check
#   提交并推送:  .\push-github-mayuqian.ps1 -Message "改动说明"
param(
    [string]$Message = "",
    [switch]$Check
)

$ErrorActionPreference = "Stop"

# ---------- 关键配置 ----------
# 仓库地址：必须走 ssh.github.com:443，本机 hosts 把 github.com 屏蔽到 127.0.0.1
$RepoUrl    = "ssh://git@ssh.github.com:443/15641546212/mayuqian.git"
$RemoteName = "github-mayuqian"   # 与 origin(Gitee)、github(ninini929)、github-myq(wangyao) 并存
$DefaultKey = "$HOME\.ssh\id_ed25519"  # 刚生成的 myq-24001010607 公钥
$Branch     = "main"

# SSH 非交互化：指定 IdentityFile + 自动接受主机指纹 + 禁止输密码 + 15s 超时
$env:GIT_SSH_COMMAND = "ssh -i `"$DefaultKey`" -o StrictHostKeyChecking=accept-new -o BatchMode=yes -o ConnectTimeout=15"
$env:GIT_TERMINAL_PROMPT = "0"

# 仓库根 = scripts 的上四级（scripts -> git-push-github-mayuqian -> skills -> .trae -> workspace）
$RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..\..\..')).Path

function Write-Step($msg) { Write-Host "[git-push-github-mayuqian] $msg" }
function Fail($msg)      { Write-Host "[git-push-github-mayuqian] 错误: $msg" -ForegroundColor Red; exit 1 }

# ---------- 预检：git 可用性、SSH 密钥、仓库可达性 ----------
if ($Check) {
    Write-Step "[1/3] git 版本: $(git --version)"

    if (-not (Test-Path $DefaultKey)) {
        Fail "未找到 SSH 私钥 $DefaultKey，请先执行 ssh-keygen 生成密钥对"
    }
    Write-Step "[2/3] SSH 私钥存在: $DefaultKey"

    Write-Step "[3/3] 测试仓库可达性..."
    git ls-remote $RepoUrl HEAD 2>&1 | Out-Null
    if ($LASTEXITCODE -ne 0) {
        Fail "无法访问 $RepoUrl（请确认公钥已加入 GitHub 账号 15641546212）"
    }
    Write-Host "[git-push-github-mayuqian] 预检通过：SSH 认证有效，仓库可达" -ForegroundColor Green
    exit 0
}

# ---------- 切换到项目根 ----------
Set-Location -LiteralPath $RepoRoot

# ---------- 1. 初始化仓库（若无 .git） ----------
if (-not (Test-Path ".git")) {
    Write-Step "初始化 git 仓库..."
    git init | Out-Null
    git symbolic-ref HEAD refs/heads/main 2>$null | Out-Null
}

# ---------- 2. 跟随当前分支 ----------
$cur = git rev-parse --abbrev-ref HEAD 2>$null
if ($cur -and $cur -ne "HEAD") { $Branch = $cur }
Write-Step "当前分支: $Branch"

# ---------- 3. 配置远程 github-mayuqian ----------
$remotes = @(git remote)
if ($remotes -notcontains $RemoteName) {
    Write-Step "添加远程 $RemoteName → $RepoUrl"
    git remote add $RemoteName $RepoUrl
} else {
    git remote set-url $RemoteName $RepoUrl
    Write-Step "更新远程 $RemoteName"
}

# ---------- 4. 暂存 + 提交 ----------
git add -A
git diff --cached --quiet
$hasStaged = ($LASTEXITCODE -ne 0)

if (-not $hasStaged) {
    Write-Step "工作区无变更，跳过 commit"
} else {
    if ([string]::IsNullOrWhiteSpace($Message)) {
        $Message = "项目更新 $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
    }
    Write-Step "提交变更（$Message）..."
    git commit -m $Message
    if ($LASTEXITCODE -ne 0) { Fail "git commit 失败" }
}

# ---------- 5. 推送（被拒则 pull --rebase 重试一次；禁止 force push） ----------
Write-Step "推送到 $RemoteName/$Branch ..."
git push -u $RemoteName $Branch
if ($LASTEXITCODE -ne 0) {
    Write-Step "推送被拒，尝试 pull --rebase 后重试..."
    git pull --rebase $RemoteName $Branch
    if ($LASTEXITCODE -ne 0) { Fail "pull --rebase 失败，请手动处理冲突" }
    git push -u $RemoteName $Branch
    if ($LASTEXITCODE -ne 0) { Fail "重试推送仍失败" }
}

Write-Host "[git-push-github-mayuqian] 完成：已推送到 15641546212/mayuqian ($Branch)" -ForegroundColor Green
