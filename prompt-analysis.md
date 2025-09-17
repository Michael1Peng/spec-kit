# Template Prompt Analysis

## spec-template.md
Spec template orchestrates a deterministic control flow for generating business-facing specifications. Lines 8-25 encode numbered steps with explicit ERROR and WARN branches so the agent must either surface clarifications or halt when inputs are missing. This keeps the spec requirement-focused and prevents implementation leakage.

Guidance blocks on lines 30-52 separate hard constraints (no implementation detail, stakeholder tone) from heuristics aimed at AI generation, priming the model to self-audit before writing. The mandatory scenario prompts on lines 55-67 guarantee scenario coverage even when the user prompt is sparse.

The functional requirements scaffold on lines 68-83 combines concrete wording patterns with NEEDS CLARIFICATION slots, nudging the author to surface unknowns instead of inventing details. Checklist and execution-status sections on lines 87-114 provide built-in QA hooks that mirror the initial flow to ensure completeness before handoff.

### ASCII Flow
```
+---------------------+
| Start: User Input   |
+---------------------+
       |
       v
+-------------------------------+
| Parse description             |
+-------------------------------+
       |
       v
+-------------------------------+    No →+-------------------------+
| Input empty?                  |-------->| ERROR: No description   |
+-------------------------------+        +-------------------------+
       |Yes
       v
+-------------------------------+
| Extract actors/actions/data   |
+-------------------------------+
       |
       v
+-------------------------------+
| Identify unclear aspects?     |
+-------------------------------+
       |Yes                            No
       v                                |
+-------------------------------+       |
| Add [NEEDS CLARIFICATION]    |<-------+
+-------------------------------+
       |
       v
+-------------------------------+
| Fill User Scenarios & Testing |
+-------------------------------+
       |
       v
+-------------------------------+
| Generate Functional Reqs      |
+-------------------------------+
       |
       v
+-------------------------------+
| Define Key Entities (if data) |
+-------------------------------+
       |
       v
+-------------------------------+
| Run Review Checklist          |
+-------------------------------+
       |
       v
+-------------------------------+   Fail →+------------------------+
| Checklist passed?             |-------->| WARN/ERROR, fix issues  |
+-------------------------------+        +------------------------+
       |Pass
       v
+-------------------------------+
| Update Execution Status flags |
+-------------------------------+
       |
       v
+-------------------------------+
| OUTPUT: Draft feature spec    |
+-------------------------------+
```

## templates/commands/specify.md
The specify command prompt encapsulates the bootstrap flow for new feature specs. The YAML header on lines 1-6 defines cross-platform scripts so the same instructions work for bash or PowerShell. Steps on lines 10-13 modularize the workflow: invoke the helper script to create the branch and spec file, load the spec template, then populate it using the prompt context. The closing note on line 15 makes the branch side effect explicit to keep automation predictable.

### ASCII Flow
```
+-----------------------------+
| Start: Feature description  |
+-----------------------------+
       |
       v
+---------------------------------+
| Run create-new-feature script   |
| -> parse JSON (branch, spec)    |
+---------------------------------+
       |
       v
+---------------------------------+
| Load templates/spec-template.md |
+---------------------------------+
       |
       v
+---------------------------------+
| Populate spec file from template|
| using prompt context            |
+---------------------------------+
       |
       v
+---------------------------------+
| Report branch & spec readiness  |
+---------------------------------+
```

## plan-template.md
The plan template turns the planning phase into an executable control program. Lines 13-33 prescribe nine ordered steps with constitutional gates before and after design. The technical context matrix on lines 42-51 normalizes metadata gathering to feed downstream automation, while the project structure prompts on lines 58-108 require an explicit structure decision.

Phase sections on lines 110-188 define precise outputs: research.md, data-model.md, contracts/, quickstart.md, and agent context updates. Complexity and progress tracking (lines 190-214) institutionalize governance by demanding justification for deviations and a checklist for phase completion.

### ASCII Flow
```
+----------------------------+
| Start: Feature spec path   |
+----------------------------+
       |
       v
+-------------------------------+
| Step1: Load spec              |
| -> missing? ERROR             |
+-------------------------------+
       |
       v
+-------------------------------+
| Step2: Fill Technical Context |
| -> detect project type        |
+-------------------------------+
       |
       v
+-------------------------------+
| Step3: Populate Constitution  |
| Check from /memory document   |
+-------------------------------+
       |
       v
+-------------------------------+
| Step4: Evaluate gates         |
| Violations? -> Complexity tbl |
| -> can justify? else ERROR    |
| -> mark Initial PASS          |
+-------------------------------+
       |
       v
+-------------------------------+
| Step5: Phase 0 Research       |
| - Extract unknowns            |
| - Dispatch research tasks     |
| - Write research.md           |
| Unresolved? ERROR             |
+-------------------------------+
       |
       v
+-------------------------------+
| Step6: Phase 1 Design         |
| - data-model.md               |
| - contracts/ + failing tests  |
| - quickstart.md               |
| - Update agent file           |
+-------------------------------+
       |
       v
+-------------------------------+
| Step7: Re-evaluate gates      |
| Violations? -> refine Phase1  |
| -> mark Post-Design PASS      |
+-------------------------------+
       |
       v
+-------------------------------+
| Step8: Describe Phase2 tasks  |
| (strategy only)               |
+-------------------------------+
       |
       v
+-------------------------------+
| Step9: STOP (handoff to tasks)|
+-------------------------------+
       |
       v
+-------------------------------+
| Update Progress Tracking      |
+-------------------------------+
```

## templates/commands/plan.md
This command prompt coordinates the plan workflow. The header on lines 1-6 supplies platform-specific setup scripts. Steps 10-37 prescribe running the setup script, reading the spec and constitution, executing the plan template, then validating that all artifacts exist and gates passed. Line 39 stresses absolute paths to avoid ambiguity in multi-agent environments.

### ASCII Flow
```
+-----------------------------+
| Start: Implementation args  |
+-----------------------------+
       |
       v
+-------------------------------------+
| Run setup-plan script --json        |
| -> FEATURE_SPEC, IMPL_PLAN, etc.    |
+-------------------------------------+
       |
       v
+-------------------------------------+
| Read feature spec for requirements  |
+-------------------------------------+
       |
       v
+-------------------------------------+
| Read /memory/constitution.md        |
+-------------------------------------+
       |
       v
+-------------------------------------+
| Execute plan-template at IMPL_PLAN  |
| (steps 1-9, artifact generation)    |
+-------------------------------------+
       |
       v
+-------------------------------------+
| Verify outputs & progress tracking  |
| -> missing artifact? ERROR          |
+-------------------------------------+
       |
       v
+-------------------------------------+
| Report branch + generated files     |
+-------------------------------------+
```

## tasks-template.md
The tasks template governs tasks.md generation as an algorithmic process. The flow on lines 6-33 directs the agent to load plan.md, optionally pull other design docs, and build task buckets. Rules on lines 35-118 enforce parallelism markings, TDD ordering, and mapping of contracts/entities/stories to concrete tasks. The validation checklist on lines 119-127 serves as the final gate before output.

### ASCII Flow
```
+----------------------------+
| Start: Feature directory   |
+----------------------------+
       |
       v
+-------------------------------+
| Step1: Load plan.md           |
| -> missing? ERROR             |
+-------------------------------+
       |
       v
+-------------------------------+
| Step2: Load optional docs     |
| data-model / contracts / etc. |
+-------------------------------+
       |
       v
+-------------------------------+
| Step3: Generate task buckets  |
| Setup / Tests / Core / ...    |
+-------------------------------+
       |
       v
+-------------------------------+
| Step4: Apply task rules       |
| - Mark [P] per independence   |
| - Tests before implementation |
+-------------------------------+
       |
       v
+-------------------------------+
| Step5: Number tasks T001...   |
+-------------------------------+
       |
       v
+-------------------------------+
| Step6: Build dependency graph |
+-------------------------------+
       |
       v
+-------------------------------+
| Step7: Parallel examples      |
+-------------------------------+
       |
       v
+-------------------------------+
| Step8: Validate completeness  |
| -> Missing coverage? fix      |
+-------------------------------+
       |
       v
+-------------------------------+
| Output tasks.md ready to run  |
+-------------------------------+
```

## templates/commands/tasks.md
This command prompt adapts task generation to available artifacts. Lines 1-6 define the prerequisite check script. Steps 10-58 describe parsing available documents, always reading plan.md, conditionally loading others, and then invoking the tasks template with contextual arguments. Line 59 injects runtime context, and the closing sentence emphasizes producing immediately executable tasks.

### ASCII Flow
```
+-----------------------------+
| Start: Tasks context args   |
+-----------------------------+
       |
       v
+-----------------------------------+
| Run check-task-prerequisites      |
| -> FEATURE_DIR, AVAILABLE_DOCS    |
+-----------------------------------+
       |
       v
+-----------------------------------+
| Load plan.md (always)             |
+-----------------------------------+
       |
       v
+-----------------------------------+
| Conditionally load other docs     |
| per AVAILABLE_DOCS                |
+-----------------------------------+
       |
       v
+-----------------------------------+
| Invoke tasks-template process     |
| with gathered context             |
+-----------------------------------+
       |
       v
+-----------------------------------+
| Write FEATURE_DIR/tasks.md        |
+-----------------------------------+
       |
       v
+-----------------------------------+
| Report success & readiness        |
+-----------------------------------+
```

## agent-file-template.md
The agent file template provides a consolidated living guidelines document. Lines 1-20 define sections for technologies, structure, commands, code style, and recent changes. Plan Phase 1 Step 5 calls this template so each new plan increments the shared context. Manual additions are preserved between markers on lines 22-23, allowing human notes without breaking automation.

### ASCII Flow
```
+------------------------------+
| Trigger: Plan Phase1 Step 5  |
+------------------------------+
       |
       v
+---------------------------------------+
| Read existing agent file (if any)     |
+---------------------------------------+
       |
       v
+---------------------------------------+
| Update sections:                      |
| - Active Technologies                 |
| - Project Structure                   |
| - Commands, Code Style                |
| - Recent Changes                      |
+---------------------------------------+
       |
       v
+---------------------------------------+
| Preserve manual additions block       |
+---------------------------------------+
       |
       v
+---------------------------------------+
| Write refreshed guidelines doc        |
+---------------------------------------+
```
