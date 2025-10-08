# Tasks: [FEATURE NAME]

**Input**: Design documents from `/specs/[###-feature-name]/`
**Prerequisites**: plan.md (required), idea.md, research.md, data-model.md, contracts/

## Execution Flow (main)
```
1. Load plan.md from feature directory
   → If not found: ERROR "No implementation plan found"
   → Extract: tech stack, libraries, structure
2. Load optional design documents:
   → idea.md: Extract implementation stages/phases → primary task grouping
   → data-model.md: Extract entities → model tasks
   → contracts/: Each file → contract test task
   → research.md: Extract decisions → setup tasks
3. **Determine task organization strategy**:
   IF idea.md exists AND contains stages/phases:
     → Use PHASE-BASED TDD structure (each phase: TDD → Impl → Verify → Polish)
   ELSE:
     → Use CATEGORY-BASED structure (Setup → Tests → Core → Integration → Polish)
4. Generate tasks by chosen strategy:
   **Phase-based (preferred)**:
     → Phase N.1: TDD tests (must fail)
     → Phase N.2: Core implementation
     → Phase N.3: Verify tests pass
     → Phase N.4: Polish & docs
   **Category-based (fallback)**:
     → Setup, Tests, Core, Integration, Polish
5. Apply task rules:
   → Different files = mark [P] for parallel
   → Same file = sequential (no [P])
   → Tests before implementation (TDD)
6. Number tasks sequentially (T001, T002...)
7. Generate dependency graph
8. Create parallel execution examples
9. Validate task completeness:
   → All contracts have tests?
   → All entities have models?
   → All endpoints implemented?
10. Return: SUCCESS (tasks ready for execution)
```

## Format: `[ID] [P?] Description`
- **[P]**: Can run in parallel (different files, no dependencies)
- Include exact file paths in descriptions

## Path Conventions
- **Single project**: `src/`, `tests/` at repository root
- **Web app**: `backend/src/`, `frontend/src/`
- **Mobile**: `api/src/`, `ios/src/` or `android/src/`
- Paths shown below assume single project - adjust based on plan.md structure

<!-- Replace Content below only -->

## 阶段0: 环境准备
### 0.1 TDD 测试编写
- [ ] T001 [P] Setup tests in tests/setup/

### 0.2 核心实现
- [ ] T002 Create project structure
- [ ] T003 Initialize dependencies
- [ ] T004 [P] Configure tooling

### 0.3 验证测试通过
- [ ] T005 Verify setup complete

### 0.4 优化与文档
- [ ] T006 [P] Document setup

---

## 阶段1: [阶段名称]
### 1.1 TDD 测试编写 ⚠️ 必须失败
- [ ] T007 [P] Contract test POST /api/users in tests/contract/test_users_post.py
- [ ] T008 [P] Contract test GET /api/users/{id} in tests/contract/test_users_get.py
- [ ] T009 [P] Integration test registration in tests/integration/test_registration.py

### 1.2 核心实现
- [ ] T010 [P] User model in src/models/user.py
- [ ] T011 [P] UserService CRUD in src/services/user_service.py
- [ ] T012 POST /api/users endpoint
- [ ] T013 GET /api/users/{id} endpoint
- [ ] T014 Input validation

### 1.3 验证测试通过
- [ ] T015 Run tests T007-T009, verify pass
- [ ] T016 Fix failing tests if any

### 1.4 优化与文档
- [ ] T017 [P] Refactor duplicates
- [ ] T018 [P] Update docs/api.md

---

## 阶段2: [阶段名称]
### 2.1 TDD 测试编写
- [ ] T019 [P] Auth tests in tests/integration/test_auth.py

### 2.2 核心实现
- [ ] T020 Auth middleware
- [ ] T021 Error handling and logging

### 2.3 验证测试通过
- [ ] T022 Verify T019 passes

### 2.4 优化与文档
- [ ] T023 Performance tests (<200ms)
- [ ] T024 [P] Update docs

## Dependencies
- Each phase: X.1 → X.2 → X.3 → X.4
- Tests before implementation
- Implementation before verification
- Verification before polish

## Parallel Example
```
# Phase 1.1 - Launch T007-T009 together:
Task: "Contract test POST /api/users in tests/contract/test_users_post.py"
Task: "Contract test GET /api/users/{id} in tests/contract/test_users_get.py"
Task: "Integration test registration in tests/integration/test_registration.py"

# Phase 1.2 - Launch T010-T011 together:
Task: "User model in src/models/user.py"
Task: "UserService CRUD in src/services/user_service.py"
```

<!-- Replace Content above only -->

## Notes
- [P] tasks = different files, no dependencies
- Verify tests fail before implementing
- Commit after each task
- Avoid: vague tasks, same file conflicts

## Task Generation Rules

0. **From idea.md stages**:
   - Extract stages → map to phases
   - Each stage → 4 sub-phases (TDD/Impl/Verify/Polish)
   - Use stage goals → define phase tasks

1. **From Contracts**:
   - Each contract → test task in X.1 [P]
   - Each endpoint → impl task in X.2

2. **From Data Model**:
   - Each entity → model task in X.2 [P]
   - Relationships → service tasks

3. **From User Stories**:
   - Each story → integration test in X.1 [P]
   - Quickstart → validation in X.3

4. **Phase ordering**:
   - Each phase: X.1 → X.2 → X.3 → X.4
   - Dependencies block parallel execution

## Validation Checklist
*GATE: Checked by main() before returning*

- [ ] All contracts have corresponding tests
- [ ] All entities have model tasks
- [ ] All tests come before implementation
- [ ] Parallel tasks truly independent
- [ ] Each task specifies exact file path
- [ ] No task modifies same file as another [P] task