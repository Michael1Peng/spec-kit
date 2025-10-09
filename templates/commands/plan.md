---
description: Execute the implementation planning workflow using the plan template to generate design artifacts.
scripts:
  sh: scripts/bash/setup-plan.sh --json
  ps: scripts/powershell/setup-plan.ps1 -Json
---

The user input to you can be provided directly by the agent or as a command argument - you **MUST** consider it before proceeding with the prompt (if not empty).

User input:

$ARGUMENTS

Given the implementation details provided as an argument, do this:

1. Run `{SCRIPT}` from the repo root and parse JSON for FEATURE_SPEC, IMPL_PLAN, SPECS_DIR, BRANCH. All future file paths must be absolute.
   - BEFORE proceeding, inspect FEATURE_SPEC for a `## Clarifications` section with at least one `Session` subheading. If missing or clearly ambiguous areas remain (vague adjectives, unresolved critical choices), PAUSE and instruct the user to run `/clarify` first to reduce rework. Only continue if: (a) Clarifications exist OR (b) an explicit user override is provided (e.g., "proceed without clarification"). Do not attempt to fabricate clarifications yourself.
2. Read and analyze the feature specification to understand:
   - The feature requirements and user stories
   - Functional and non-functional requirements
   - Success criteria and acceptance criteria
   - Any technical constraints or dependencies mentioned

3. Read the constitution at `/memory/constitution.md` to understand constitutional requirements.

4. Execute the implementation plan template，**即问即写**分阶段交互模式:
   - Load `/templates/plan-template.md` (already copied to IMPL_PLAN path)
   - **IMPORTANT** 在创建和修改 IMPL_PLAN 文件时，必须保留模板中 "## Execution Flow (/plan command scope)" 部分的完整内容。这个执行流程是计划文件的核心指导框架，不能删除、省略或修改。
   - Set Input path to FEATURE_SPEC
   - 分7个阶段执行，每阶段即问即写:
     * 阶段1: 提问Technical Context（2-3项）→ 确认 → Write创建plan.md框架并填充 → 提供选项
     * 阶段2: 提问Constitution Check项 → 确认 → Edit追加 → 提供选项
     * 阶段3: 展示Project Structure选项 → 确认 → Edit追加 → 提供选项
     * 阶段4: 提问Phase 0研究任务（2-3个）→ 确认 → Write创建research.md → 循环直到完成 → 提供选项
     * 阶段5: 提问Phase 1设计（entities/contracts/quickstart分批）→ 确认 → Write对应md文件 → 循环 → 提供选项
     * 阶段6: 展示Phase 2任务规划方法 → 确认 → Edit追加到plan.md → 提供选项
     * 阶段7: 展示Progress Tracking → Edit更新 → 完成
   - Incorporate user-provided details: {ARGS}
   - **关键**: 每2-3个问题就立即写入，不要等所有问题问完
   - 选项: 确认写入/修改/跳过/查看文件/继续下批

5. Verify execution completed:
   - Check Progress Tracking shows all phases complete
   - Ensure all required artifacts were generated
   - Confirm no ERROR states in execution

6. Report results with branch name, file paths, and generated artifacts.

Use absolute paths with the repository root for all file operations to avoid path issues.
