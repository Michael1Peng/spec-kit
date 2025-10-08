---
description: Generate an actionable, dependency-ordered tasks.md for the feature based on available design artifacts.
scripts:
  sh: scripts/bash/check-prerequisites.sh --json
  ps: scripts/powershell/check-prerequisites.ps1 -Json
---

The user input to you can be provided directly by the agent or as a command argument - you **MUST** consider it before proceeding with the prompt (if not empty).

User input:

$ARGUMENTS

1. Run `{SCRIPT}` from repo root and parse FEATURE_DIR and AVAILABLE_DOCS list. All paths must be absolute.
2. Load and analyze available design documents:
   - Always read plan.md for tech stack and libraries
   - IF EXISTS: Read idea.md for implementation strategy and flow diagrams
   - IF EXISTS: Read data-model.md for entities
   - IF EXISTS: Read contracts/ for API endpoints
   - IF EXISTS: Read research.md for technical decisions
   - IF EXISTS: Read quickstart.md for test scenarios

   Note: Not all projects have all documents. For example:
   - CLI tools might not have contracts/
   - Simple libraries might not need data-model.md
   - idea.md provides the high-level implementation roadmap
   - Generate tasks based on what's available

3. **Determine task structure strategy**:
   - IF idea.md exists AND contains stages/phases:
     * Use PHASE-BASED TDD structure
     * Map each stage to phase with 4 sub-phases: X.1 (TDD) → X.2 (Impl) → X.3 (Verify) → X.4 (Polish)
   - ELSE:
     * Use CATEGORY-BASED structure (Setup → Tests → Core → Integration → Polish)

4. Generate tasks following the template:
   - Copy `.specify/templates/tasks-template.md` to FEATURE_DIR/tasks.md
   - **IMPORTANT**: Only replace content between `<!-- Replace Content below only -->` and `<!-- Replace Content above only -->` markers
   - Keep all other sections unchanged (Execution Flow, Format, Path Conventions, Notes, Task Generation Rules, Validation Checklist)
   - Replace example phases with actual phases based on:
     * **Phase-based** (when idea.md has stages):
       - Phase X.1: TDD tests (must fail) - contracts, integration tests [P]
       - Phase X.2: Core implementation - entities, services, endpoints
       - Phase X.3: Verify tests pass - run test suite, fix failures
       - Phase X.4: Polish - refactor, optimize, docs [P]
     * **Category-based** (fallback):
       - Setup, Tests, Core, Integration, Polish

5. Task generation rules:
   - Each contract → test in X.1 [P]
   - Each entity → model in X.2 [P]
   - Each endpoint → impl in X.2
   - Each user story → test in X.1 [P]
   - Different files = [P]
   - Same file = sequential

6. Order tasks by dependencies:
   - Each phase: X.1 → X.2 → X.3 → X.4
   - Tests before implementation
   - Implementation before verification
   - Verification before polish

7. Include parallel execution examples:
   - Group [P] tasks that can run together
   - Show actual Task agent commands

8. Create FEATURE_DIR/tasks.md with:
   - Correct feature name from implementation plan
   - Numbered tasks (T001, T002, etc.)
   - Clear file paths for each task
   - Dependency notes
   - Parallel execution guidance

Context for task generation: {ARGS}

The tasks.md should be immediately executable - each task must be specific enough that an LLM can complete it without additional context.
