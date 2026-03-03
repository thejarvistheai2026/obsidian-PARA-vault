# Standard Operating Procedure - AI-Assisted Changes

**Created:** 2026-02-15  
**Updated:** 2026-02-15  
**Pattern:** Explain → Research → Test → Confirm → Implement → Validate

---

## The 6-Phase Workflow

### Phase 1: 📋 Explainer
**Before touching anything:**
- [ ] Explain what we're doing
- [ ] Explain why we're doing it
- [ ] Identify risks and failure modes
- [ ] Have rollback plan ready
- [ ] Confirm user understands and agrees

**Trigger phrase:** *"Here's what we're about to do..."*

---

### Phase 2: 🔍 Research
**Never assume, always verify with official sources:**
- [ ] Check official documentation first
- [ ] Look for recent/proven examples (GitHub, docs, community)
- [ ] Identify the "blessed path" vs workarounds
- [ ] Note version compatibility issues
- [ ] Document sources consulted

**Key principle:** *If it's in the official docs, we use that approach. If not, we document why we're going off-script.*

**Sources to check:**
- Official documentation (openclaw.ai, ollama.com, provider docs)
- GitHub issues/PRs for known bugs
- Community patterns that are well-established
- Our own lessons.md for similar past attempts

**Trigger phrase:** *"Let me check the official docs first..."*

---

### Phase 3: 🧪 Test
**Verify BEFORE committing:**
- [ ] Test that resources exist (models, files, connections)
- [ ] Test that things work in isolation
- [ ] Confirm expected behavior
- [ ] Document any anomalies

**Trigger phrase:** *"Let me test this first..."*

---

### Phase 4: ✅ Checkpoint
**User confirms before proceeding:**

I say: *"Ready to proceed? Type 'go' to continue, or ask questions."*

User must explicitly confirm. No assumptions.

---

### Phase 5: 🔧 Implement
**Methodical execution:**
- [ ] Create backup FIRST
- [ ] Apply change
- [ ] Verify change took
- [ ] Document what was done

**One step at a time.** Pause for confirmation between risky operations.

---

### Phase 6: 🎯 Validate
**Confirm it works end-to-end:**
- [ ] Quick smoke test
- [ ] User confirms satisfaction
- [ ] Document success or issues
- [ ] Update lessons learned if applicable

---

## Examples

### ✅ Good (Ollama Model Switch - Final Attempt)
1. **Explain:** Laid out the approach, why manual patching failed twice
2. **Research:** Found official Ollama docs at `docs.ollama.com/integrations/openclaw` showing `ollama launch` command
3. **Test:** Tested the model exists with `ollama list` and `ollama run kimi` - worked
4. **Checkpoint:** User said "apply" before changes
5. **Implement:** Created clean alias → Backup config → Ran integration command
6. **Validate:** `/status` shows Kimi, user asks test question

### ❌ Bad (First Two Attempts)
- Skipped research - didn't check if official Ollama integration docs existed
- Assumed manual `config.patch` was the right approach
- Didn't test if model format was valid
- No checkpoint before restart
- Rollback not ready

---

## Emergency Override

If something is **obviously broken right now**, skip to fix. Document after.

Otherwise: **Slow is smooth, smooth is fast.**

---

**Adopted:** 2026-02-15  
**Last used:** Ollama Kimi model switch
