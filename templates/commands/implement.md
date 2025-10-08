---
description: Execute the implementation plan by processing and executing all tasks defined in tasks.md
scripts:
  sh: scripts/bash/check-prerequisites.sh --json --require-tasks --include-tasks
  ps: scripts/powershell/check-prerequisites.ps1 -Json -RequireTasks -IncludeTasks
---

The user input can be provided directly by the agent or as a command argument - you **MUST** consider it before proceeding with the prompt (if not empty).

User input:

$ARGUMENTS

1. Run `{SCRIPT}` from repo root and parse FEATURE_DIR and AVAILABLE_DOCS list. All paths must be absolute.

2. Load and analyze the implementation context:
   - **REQUIRED**: Read tasks.md for the complete task list and execution plan
   - **REQUIRED**: Read plan.md for tech stack, architecture, and file structure
   - **IF EXISTS**: Read idea.md for implementation roadmap and stage breakdown
   - **IF EXISTS**: Read data-model.md for entities and relationships
   - **IF EXISTS**: Read contracts/ for API specifications and test requirements
   - **IF EXISTS**: Read research.md for technical decisions and constraints
   - **IF EXISTS**: Read quickstart.md for integration scenarios

3. Parse tasks.md structure and extract:
   - **Task organization**: Phase-based (X.1→X.2→X.3→X.4) or Category-based (Setup→Tests→Core→Integration→Polish)
   - **Task dependencies**: Sequential vs parallel execution rules
   - **Task details**: ID, description, file paths, parallel markers [P]
   - **Execution flow**: Order and dependency requirements

4. Execute implementation following the task plan:
   - **Phase-by-phase execution**: Complete each phase before moving to next
   - **Sub-phase ordering**: For phase-based, execute X.1→X.2→X.3→X.4 sequentially
   - **Respect dependencies**: Run sequential tasks in order, parallel tasks [P] together
   - **Follow TDD approach**: X.1 tests must fail before X.2 implementation
   - **File-based coordination**: Same file tasks run sequentially
   - **Validation checkpoints**: Verify sub-phase completion before proceeding

5. Implementation execution rules:
   - **Phase-based** (when idea.md stages exist):
     * X.1 - TDD: Write failing tests (contracts, integration)
     * X.2 - Implementation: Core logic (models, services, endpoints)
     * X.3 - Verification: Run tests, ensure pass, fix failures
     * X.4 - Polish: Refactor, optimize, docs
   - **Category-based** (fallback):
     * Setup → Tests → Core → Integration → Polish

6. Progress tracking and error handling:
   - Report progress after each completed task
   - Halt execution if any non-parallel task fails
   - For parallel tasks [P], continue with successful tasks, report failed ones
   - Provide clear error messages with context for debugging
   - Suggest next steps if implementation cannot proceed
   - **IMPORTANT** For completed tasks, make sure to mark the task off as [X] in the tasks file.

7. Completion validation:
   - Verify all required tasks are completed
   - Check that implemented features match the original specification
   - Validate that tests pass and coverage meets requirements
   - Confirm the implementation follows the technical plan
   - Report final status with summary of completed work

Note: This command assumes a complete task breakdown exists in tasks.md. If tasks are incomplete or missing, suggest running `/tasks` first to regenerate the task list.