# Dwellly Implementation Guide: Planning + Opencode

This guide explains how to develop features for Dwellly using the **Hybrid AI Workflow**. This workflow splits the process into **Thinking (Planning)** and **Doing (Implementation)**.

## 🔄 The 4-Step Workflow

### 1. Request & Research
Tell the AI Assistant what you want to build (e.g., "Add a 'Reviews' feature to rooms").
- The Assistant will research the codebase.
- The Assistant will identify models, endpoints, and UI components needed.

### 2. Planning (The "Brain")
The Assistant will create or update an **Implementation Plan** in your session's brain directory.
- Review the `implementation_plan.md`.
- **Action**: Provide feedback or say "Approve" if the plan looks good.

### 3. Implementation (The "Hands")
Once approved, the Assistant will generate an **Enhanced Opencode Command** and write it to **[.ai/shared_promp.md](file:///Volumes/YCPSSD/Projects/flutter_dev/project/dwellly/.ai/shared_promp.md)**.
- **Action**: Open `.ai/shared_promp.md`, copy the command, and run it in your terminal.
- This triggers the Opencode agent to execute the code changes automatically.

### 4. Verification
After Opencode finishes:
- The Assistant will verify the changes.
- You can run the app to see the results.

---

## 🛠️ Why use this workflow?

- **Safety**: You approve the plan *before* any code is written.
- **Speed**: Opencode can perform complex, multi-file edits and Serverpod generation much faster than manual editing.
- **Consistency**: All code follows the project's strict architecture (UI ⇨ Controller ⇨ Repository ⇨ Client).

---

## 📄 Reference Files
- **Rules**: `.opencode/rule.md` (What Opencode must follow)
- **Workflow**: `.agent/workflows/dwellly_workflow2.md` (The high-level logic)
- **Prompt Template**: `.ai/shared_promp.md` (How the command is built)
