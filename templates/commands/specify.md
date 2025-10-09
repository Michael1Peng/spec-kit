---
description: Create or update the feature specification from a natural language feature description.
scripts:
  sh: scripts/bash/create-new-feature.sh --json "{ARGS}"
  ps: scripts/powershell/create-new-feature.ps1 -Json "{ARGS}"
---

The user input to you can be provided directly by the agent or as a command argument - you **MUST** consider it before proceeding with the prompt (if not empty).

User input:

$ARGUMENTS

The text the user typed after `/specify` in the triggering message **is** the feature description. Assume you always have it available in this conversation even if `{ARGS}` appears literally below. Do not ask the user to repeat it unless they provided an empty command.

Given that feature description, do this:

1. Run the script `{SCRIPT}` from repo root and parse its JSON output for BRANCH_NAME and SPEC_FILE. All file paths must be absolute.
  **IMPORTANT** You must only ever run this script once. The JSON is provided in the terminal as output - always refer to it to get the actual content you're looking for.
2. Load `templates/spec-template.md` to understand required sections.
  **IMPORTANT** 在创建和修改 SPEC_FILE 时，必须保留模板中 "## Execution Flow (main)" 和 "## ⚡ Quick Guidelines" 部分的完整内容。这个执行流程是规范文件的核心指导框架，不能删除、省略或修改。
3. 以互动式的方式跟我反复沟通多轮，来明确这个思路的各个细节，尽可能清晰的来了解我的想法。这个互动式的过程应该是你给我提供选项、讲解每个选项的原因，让我来选择。
4. 分析的时候应该输出推理的过程。推导的依据都是什么？相关的文档内容都是哪些？
5. 分阶段填写 SPEC_FILE，**即问即写**循环模式：
   - 阶段1: Write 创建文件框架 → 提供选项确认
   - 阶段2: 提问用户场景（2-3个问题）→ 确认 → **立即 Edit 追加** → 提供选项
   - 阶段3: 提问功能需求（2-3条）→ 确认 → **立即 Edit 追加** → 循环继续下一批 → 直到所有需求完成
   - 阶段4: 提问实体（2-3个）→ 确认 → **立即 Edit 追加** → 提供选项
   - 阶段5: 展示流程图 → 确认 → Edit 插入 → 提供选项
   - 阶段6: 展示审核清单 → Edit 更新 → 完成
   - **关键**：每问完2-3个就立即写入文件，不要等到问完所有问题
   - 选项：确认写入/修改/跳过/查看文件/继续下批
6. Report completion with branch name, spec file path, and readiness for the next phase.

Note: The script creates and checks out the new branch and initializes the spec file before writing.
