# CONFIG-CHANGE-PROTOCOL.md

**Purpose:** Prevent unauthorized config changes that break systems

**Applies to:** Any edits to `openclaw.json`, LaunchAgent plists, system configs, or service restarts

---

## The Rule (Non-Negotiable)

**NEVER** edit configs or restart services without explicit approval.

**ALWAYS** follow this 4-step protocol:

### Step 1: IDENTIFY
When you realize a config change is needed, **STOP** and recognize:
- Is this `openclaw.json`? → **Requires approval**
- Is this a LaunchAgent plist? → **Requires approval**
- Is this a system service restart? → **Requires approval**
- Is this a model/provider change? → **Requires approval**

### Step 2: STOP
Do not proceed. Do not "just do it quickly." Do not assume.

**Say exactly this:**
> "I need to change `[specific thing]`. Here's what will happen: `[consequence]`. Approve?"

### Step 3: WAIT
Wait for explicit confirmation. Valid responses:
- "Yes, do it"
- "Approved"
- "Go ahead"
- "Do it"

**Not valid:**
- Silence
- "Okay" (without context)
- "I guess"
- "Whatever"

If unsure, ask: "Is that a yes?"

### Step 4: CONFIRM
After making the change:
1. Summarize what changed
2. Verify it works
3. Document if needed

---

## Examples

### ✅ CORRECT

**User:** "The model is timing out."

**Ava:** "I need to change the default model from `kimi-k2.5:cloud` to `qwen2.5:7b` in `openclaw.json` and restart the gateway. This will switch which model responds to you. Approve?"

**User:** "Yes, do it."

**Ava:** *[makes change]* "Done. Config updated, gateway restarted. You're now on `qwen2.5:7b`."

### ❌ INCORRECT

**User:** "The model is timing out."

**Ava:** *[immediately edits config]* "I fixed it by switching to qwen2.5:7b."

---

## Consequences of Breaking This Rule

If I violate this protocol:
1. **Stop immediately** when called out
2. **Revert** the change if possible
3. **Document** what happened
4. **Review** why the protocol was ignored

---

## User Override

**If I ever start making config changes without asking:**

Say: **"STOP — you didn't ask"**

I will immediately halt and we can discuss.

---

## Why This Matters

- Config changes can break the entire system
- Model switches change how I respond
- Service restarts interrupt workflows
- **Trust is built by asking, not by assuming**

---

**Last updated:** 2026-03-15
**Created after:** Config change incident that broke system trust
