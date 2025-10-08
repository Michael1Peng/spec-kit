---
description: "Implementation plan template for feature development"
scripts:
  sh: scripts/bash/update-agent-context.sh __AGENT__
  ps: scripts/powershell/update-agent-context.ps1 -AgentType __AGENT__
---

# Implementation Plan: [FEATURE]

**Branch**: `[###-feature-name]` | **Date**: [DATE] | **Spec**: [link]
**Input**: Feature specification from `/specs/[###-feature-name]/spec.md`

## Execution Flow (/plan command scope)
```
1. Load feature spec from Input path
   → If not found: ERROR "No feature spec at {path}"
2. Fill Technical Context (scan for NEEDS CLARIFICATION)
   → Detect Project Type from file system structure or context (web=frontend+backend, mobile=app+api)
   → Set Structure Decision based on project type
3. Fill the Constitution Check section based on the content of the constitution document.
4. Evaluate Constitution Check section below
   → If violations exist: Document in Complexity Tracking
   → If no justification possible: ERROR "Simplify approach first"
   → Update Progress Tracking: Initial Constitution Check
5. Execute Phase 0 → research.md
   → If NEEDS CLARIFICATION remain: ERROR "Resolve unknowns"
6. Execute Phase 1 → contracts, data-model.md, quickstart.md, agent-specific template file (e.g., `CLAUDE.md` for Claude Code, `.github/copilot-instructions.md` for GitHub Copilot, `GEMINI.md` for Gemini CLI, `QWEN.md` for Qwen Code, or `AGENTS.md` for all other agents).
7. Re-evaluate Constitution Check section
   → If new violations: Refactor design, return to Phase 1
   → Update Progress Tracking: Post-Design Constitution Check
8. Plan Phase 2 → Describe task generation approach (DO NOT create tasks.md)
9. STOP - Ready for /tasks command
```

**IMPORTANT**: The /plan command STOPS at step 7. Phases 2-4 are executed by other commands:
- Phase 2: /tasks command creates tasks.md
- Phase 3-4: Implementation execution (manual or via tools)

## Summary
[Extract from feature spec: primary requirement + technical approach from research]

## Technical Context
**Language/Version**: [e.g., Python 3.11, Swift 5.9, Rust 1.75 or NEEDS CLARIFICATION]  
**Primary Dependencies**: [e.g., FastAPI, UIKit, LLVM or NEEDS CLARIFICATION]  
**Storage**: [if applicable, e.g., PostgreSQL, CoreData, files or N/A]  
**Testing**: [e.g., pytest, XCTest, cargo test or NEEDS CLARIFICATION]  
**Target Platform**: [e.g., Linux server, iOS 15+, WASM or NEEDS CLARIFICATION]
**Project Type**: [single/web/mobile - determines source structure]  
**Performance Goals**: [domain-specific, e.g., 1000 req/s, 10k lines/sec, 60 fps or NEEDS CLARIFICATION]  
**Constraints**: [domain-specific, e.g., <200ms p95, <100MB memory, offline-capable or NEEDS CLARIFICATION]  
**Scale/Scope**: [domain-specific, e.g., 10k users, 1M LOC, 50 screens or NEEDS CLARIFICATION]

## Constitution Check
*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

[Gates determined based on constitution file]

## Project Structure

### Documentation (this feature)
```
specs/[###-feature]/
├── plan.md              # This file (/plan command output)
├── research.md          # Phase 0 output (/plan command)
├── data-model.md        # Phase 1 output (/plan command)
├── quickstart.md        # Phase 1 output (/plan command)
├── contracts/           # Phase 1 output (/plan command)
└── tasks.md             # Phase 2 output (/tasks command - NOT created by /plan)
```

### Source Code (repository root)
<!--
  ACTION REQUIRED: Replace the placeholder tree below with the concrete layout
  for this feature. Delete unused options and expand the chosen structure with
  real paths (e.g., apps/admin, packages/something). The delivered plan must
  not include Option labels.
-->
```
# [REMOVE IF UNUSED] Option 1: Single project (DEFAULT)
src/
├── models/
├── services/
├── cli/
└── lib/

tests/
├── contract/
├── integration/
└── unit/

# [REMOVE IF UNUSED] Option 2: Web application (when "frontend" + "backend" detected)
backend/
├── src/
│   ├── models/
│   ├── services/
│   └── api/
└── tests/

frontend/
├── src/
│   ├── components/
│   ├── pages/
│   └── services/
└── tests/

# [REMOVE IF UNUSED] Option 3: Mobile + API (when "iOS/Android" detected)
api/
└── [same as backend above]

ios/ or android/
└── [platform-specific structure: feature modules, UI flows, platform tests]
```

**Structure Decision**: [Document the selected structure and reference the real
directories captured above]

## Phase 0: Outline & Research
1. **Extract unknowns from Technical Context** above:
   - For each NEEDS CLARIFICATION → research task
   - For each dependency → best practices task
   - For each integration → patterns task

2. **Generate research task list**:
   ```
   For each unknown in Technical Context:
     Task: "Research {unknown} for {feature context}"
   For each technology choice:
     Task: "Find best practices for {tech} in {domain}"
   ```

3. **逐项交互决策并写入**（每次只处理1个任务，即问即写）:
   ```
   For EACH research task (one at a time):
     a. Research THIS task only (WebSearch/Task tools)
     b. Present 2-3 options to user with:
        - 推理依据: Why suitable for this context
        - 优势/劣势: Pros and cons
        - 替代方案: Other options considered
     c. WAIT for user selection
     d. User selects → Immediately Write/Edit research.md (append this decision)
     e. Continue to NEXT task

   IMPORTANT: Process ONE task at a time, write immediately after each decision
   ```

4. **Output format** in `research.md` for each decision:
   - Decision: [what was chosen]
   - Rationale: [why chosen, include reasoning process]
   - Alternatives considered: [what else evaluated and why rejected]
   - Supporting Evidence: [research sources, docs, best practices]

**Output**: research.md with all NEEDS CLARIFICATION resolved

## Phase 1: Design & Contracts
*Prerequisites: research.md complete*

1. **双源提取实体模型** → `data-model.md`:
   - **源A (spec.md)**: 功能需求 → 实体/字段/关系、验收标准 → 验证规则、状态描述 → 状态机
   - **源B (代码库)**: Glob `src/**/*.{js,ts}` → Grep `class|interface|type` → Read 模型文件分析现有设计模式
   - **合并策略**: 优先复用现有实体/命名/验证模式，新增字段遵循仓库惯例
   - **推理标注**: 说明设计决策依据（如: 选择 `isActive` 字段因现有代码已使用此模式，见 `workspace.js:12`）
   - **来源标注**: 每个实体注明出处（格式: `spec.md L15-23 + src/models/workspace.js:9-30`）

2. **双源生成接口契约** → `/contracts/`:
   - **源A (spec.md)**: 用户操作 → 端点/命令、参数 → 请求体、场景 → 响应/错误码
   - **源B (代码库)**: Glob `src/**/api/**/*.{js,ts}` 或 `src/commands/**/*.js` → Grep 路由/命令定义 → Read 分析请求/响应结构
   - **合并策略**: 沿用现有 URL/命名模式、错误码定义、响应格式
   - **推理标注**: 说明接口设计理由（如: 使用 POST `/api/workspace/update` 因需修改资源且符合现有 RESTful 约定）
   - **输出格式**: OpenAPI 3.0 (Web) 或 Commander schema (CLI)，含请求/响应示例
   - **来源标注**: 每个端点注明出处（格式: `# 来源: spec.md L45 + src/api/workspace.js:20`）

3. **Generate contract tests** from contracts:
   - One test file per endpoint
   - Assert request/response schemas
   - Tests must fail (no implementation yet)

4. **生成实现思路** → `idea.md`:
   - **源A (spec.md)**: 核心需求 → 功能点列表、用户故事 → 操作流程
   - **源B (代码库)**: Search 相似功能关键词 → Read 已有实现分析技术路线
   - **源C (data-model.md + contracts/)**: 数据结构 + API 定义
   - **交互生成思路和实现路线内容**:  待澄清的点逐个决策点提供 2-3 个选项，已澄清的内容决策点跳过 → 说明推理依据和优劣 → WAIT 用户选择 → 立即写入 → 下一个决策点
   - **推理标注**: 每个决策标注依据来源和推理过程（如: 选择方案B因 spec.md:L45 要求 X 且 src/service.ts:L30 已有类似模式）
   - **输出极简的描述**: 实现需求的思路 + 实现路线 + 改动前后的 ASCII 流程图对比。只输出到 `idea.md` 文件，不修改其他文件。
   - **来源标注**: 每个决策注明出处（格式: `spec.md L45 + src/service.ts:30 + research.md 技术选型`）

5. **Extract test scenarios** from user stories:
   - Each story → integration test scenario
   - Quickstart test = story validation steps

6. **Update agent file incrementally** (O(1) operation):
   - Run `{SCRIPT}`
     **IMPORTANT**: Execute it exactly as specified above. Do not add or remove any arguments.
   - If exists: Add only NEW tech from current plan
   - Preserve manual additions between markers
   - Update recent changes (keep last 3)
   - Keep under 150 lines for token efficiency
   - Output to repository root

**Output**: data-model.md, /contracts/*, failing tests, quickstart.md, agent-specific file

## Phase 2: Task Planning Approach
*This section describes what the /tasks command will do - DO NOT execute during /plan*

**Task Generation Strategy**:
- Load `.specify/templates/tasks-template.md` as base
- Generate tasks from Phase 1 design docs (contracts, data model, quickstart)
- Each contract → contract test task [P]
- Each entity → model creation task [P] 
- Each user story → integration test task
- Implementation tasks to make tests pass

**Ordering Strategy**:
- TDD order: Tests before implementation 
- Dependency order: Models before services before UI
- Mark [P] for parallel execution (independent files)

**Estimated Output**: 25-30 numbered, ordered tasks in tasks.md

**IMPORTANT**: This phase is executed by the /tasks command, NOT by /plan

## Phase 3+: Future Implementation
*These phases are beyond the scope of the /plan command*

**Phase 3**: Task execution (/tasks command creates tasks.md)  
**Phase 4**: Implementation (execute tasks.md following constitutional principles)  
**Phase 5**: Validation (run tests, execute quickstart.md, performance validation)

## Complexity Tracking
*Fill ONLY if Constitution Check has violations that must be justified*

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| [e.g., 4th project] | [current need] | [why 3 projects insufficient] |
| [e.g., Repository pattern] | [specific problem] | [why direct DB access insufficient] |


## Progress Tracking
*This checklist is updated during execution flow*

**Phase Status**:
- [ ] Phase 0: Research complete (/plan command)
- [ ] Phase 1: Design complete (/plan command)
- [ ] Phase 2: Task planning complete (/plan command - describe approach only)
- [ ] Phase 3: Tasks generated (/tasks command)
- [ ] Phase 4: Implementation complete
- [ ] Phase 5: Validation passed

**Gate Status**:
- [ ] Initial Constitution Check: PASS
- [ ] Post-Design Constitution Check: PASS
- [ ] All NEEDS CLARIFICATION resolved
- [ ] Complexity deviations documented

---
*Based on Constitution v2.1.1 - See `/memory/constitution.md`*
