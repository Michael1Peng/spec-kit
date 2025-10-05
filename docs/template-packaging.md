# Template Packaging Process

本文档说明 spec-kit 模板的打包流程和最终 ZIP 包结构。

## 源目录结构

```
spec-kit/
├── memory/           # 宪法文件
├── scripts/
│   ├── bash/        # sh 脚本变体
│   └── powershell/  # ps 脚本变体
├── templates/
│   ├── commands/    # 命令模板源文件
│   └── *.md         # 其他模板文件
└── agent_templates/ # 特定 agent 的额外模板 (可选)
```

## 打包流程

打包由 `.github/workflows/scripts/create-release-packages.sh` 执行。

### 1. 创建构建目录

```bash
.genreleases/sdd-{agent}-package-{script}/
```

示例: `.genreleases/sdd-claude-package-sh/`

### 2. 拷贝并重命名内容

脚本会将源目录拷贝到构建目录，并重命名路径：

```bash
memory/     → .specify/memory/
scripts/    → .specify/scripts/bash/  (或 powershell/)
templates/  → .specify/templates/
```

**路径重写逻辑** (create-release-packages.sh:33-38):
```bash
rewrite_paths() {
  sed -E \
    -e 's@(/?)memory/@.specify/memory/@g' \
    -e 's@(/?)scripts/@.specify/scripts/@g' \
    -e 's@(/?)templates/@.specify/templates/@g'
}
```

### 3. 脚本变体处理

根据 `script` 参数只拷贝对应的脚本目录：

- `sh`: 拷贝 `scripts/bash/` → `.specify/scripts/bash/`
- `ps`: 拷贝 `scripts/powershell/` → `.specify/scripts/powershell/`

(create-release-packages.sh:98-113)

### 4. 生成 Agent 命令文件

从 `templates/commands/*.md` 生成各 agent 的命令文件：

| Agent | 输出目录 | 格式 | 参数占位符 |
|-------|---------|------|-----------|
| claude | `.claude/commands/` | `.md` | `$ARGUMENTS` |
| copilot | `.github/prompts/` | `.prompt.md` | `$ARGUMENTS` |
| gemini | `.gemini/commands/` | `.toml` | `{{args}}` |
| cursor | `.cursor/commands/` | `.md` | `$ARGUMENTS` |
| qwen | `.qwen/commands/` | `.toml` | `{{args}}` |
| opencode | `.opencode/command/` | `.md` | `$ARGUMENTS` |
| windsurf | `.windsurf/workflows/` | `.md` | `$ARGUMENTS` |
| codex | `.codex/prompts/` | `.md` | `$ARGUMENTS` |
| kilocode | `.kilocode/workflows/` | `.md` | `$ARGUMENTS` |
| auggie | `.augment/commands/` | `.md` | `$ARGUMENTS` |
| roo | `.roo/commands/` | `.md` | `$ARGUMENTS` |
| q | `.amazonq/prompts/` | `.md` | `$ARGUMENTS` |

**命令生成逻辑** (create-release-packages.sh:40-84):

1. 读取 YAML frontmatter 提取 `description` 和脚本命令
2. 替换占位符:
   - `{SCRIPT}` → 对应脚本命令
   - `{ARGS}` → 参数占位符 (`$ARGUMENTS` 或 `{{args}}`)
   - `__AGENT__` → agent 名称
3. 移除 `scripts:` frontmatter 部分
4. 应用路径重写

### 5. 打包成 ZIP

```bash
cd base_dir && zip -r "spec-kit-template-{agent}-{script}-{version}.zip" .
```

输出文件名格式: `spec-kit-template-{agent}-{script}-{version}.zip`

示例: `spec-kit-template-claude-sh-v0.2.0.zip`

## 最终 ZIP 包结构

以 `spec-kit-template-claude-sh-v0.2.0.zip` 为例：

```
spec-kit-template-claude-sh-v0.2.0.zip
├── .specify/
│   ├── memory/
│   │   └── constitution.md
│   ├── scripts/
│   │   └── bash/
│   │       ├── check-prerequisites.sh
│   │       ├── common.sh
│   │       ├── create-new-feature.sh
│   │       ├── setup-plan.sh
│   │       └── update-agent-context.sh
│   └── templates/
│       ├── plan-template.md
│       ├── spec-template.md
│       ├── agent-file-template.md
│       └── tasks-template.md
└── .claude/
    └── commands/
        ├── analyze.md
        ├── clarify.md
        ├── implement.md
        ├── plan.md
        ├── specify.md
        └── tasks.md
```

## CLI 下载和解压逻辑

### 下载流程 (specify_cli/__init__.py:437-539)

```python
def download_template_from_github(ai_assistant, download_dir, script_type, ...):
    # 1. 获取最新 release 信息
    api_url = "https://api.github.com/repos/github/spec-kit/releases/latest"

    # 2. 查找匹配的资源文件
    pattern = f"spec-kit-template-{ai_assistant}-{script_type}"
    matching_assets = [asset for asset in assets
                       if pattern in asset["name"] and asset["name"].endswith(".zip")]

    # 3. 下载 ZIP 文件
    download_url = asset["browser_download_url"]
    # 下载到临时目录
```

### 解压流程 (specify_cli/__init__.py:549-698)

```python
def download_and_extract_template(project_path, ai_assistant, script_type, ...):
    # 1. 下载 ZIP
    zip_path, meta = download_template_from_github(...)

    # 2. 解压到项目目录
    with zipfile.ZipFile(zip_path, 'r') as zip_ref:
        zip_ref.extractall(project_path)

    # 3. 处理 GitHub-style 嵌套目录结构
    # 如果只有一个顶层目录，将其内容上移一层

    # 4. 清理下载的 ZIP 文件
    zip_path.unlink()
```

## 本地测试打包

手动运行打包脚本：

```bash
cd /home/michael/ubuntu-repos/Michael1Peng/spec-kit

# 打包特定 agent 和脚本类型
AGENTS=claude SCRIPTS=sh .github/workflows/scripts/create-release-packages.sh v0.0.0-test

# 查看生成的文件
ls -lh .genreleases/

# 查看 ZIP 包内容
unzip -l .genreleases/spec-kit-template-claude-sh-v0.0.0-test.zip
```

## 本地模板调试方案

当前 CLI 只能从 GitHub releases 下载模板，无法使用本地模板调试。

### 临时方案：手动打包测试

```bash
# 1. 本地打包
cd /home/michael/ubuntu-repos/Michael1Peng/spec-kit
AGENTS=claude SCRIPTS=sh .github/workflows/scripts/create-release-packages.sh v0.0.0-local

# 2. 拷贝到系统临时目录
cp .genreleases/spec-kit-template-claude-sh-v0.0.0-local.zip /tmp/

# 3. 修改 CLI 代码临时使用本地 ZIP (调试用)
# 在 download_template_from_github() 开头添加:
if os.getenv("SPEC_KIT_DEBUG_LOCAL"):
    local_zip = Path("/tmp/spec-kit-template-claude-sh-v0.0.0-local.zip")
    return local_zip, {
        "release": "local-debug",
        "size": local_zip.stat().st_size,
        "filename": local_zip.name
    }

# 4. 运行 CLI
export SPEC_KIT_DEBUG_LOCAL=1
python -m src.specify_cli init test-project --ai claude --script sh
```

### 长期方案：添加 --local-template 参数

需要修改 `init` 命令添加支持本地模板路径的参数。详见 `docs/local-development.md`。
