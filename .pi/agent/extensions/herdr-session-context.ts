import { spawn } from "node:child_process";
import { homedir } from "node:os";
import { join } from "node:path";
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

const updater = join(homedir(), ".config", "herdr", "update-agent-session.py");

function updateMetadata(payload: Record<string, unknown>): Promise<void> {
  return new Promise((resolve) => {
    const child = spawn("/usr/bin/python3", [updater], {
      env: process.env,
      stdio: ["pipe", "ignore", "ignore"],
    });
    let finished = false;
    const finish = () => {
      if (finished) return;
      finished = true;
      clearTimeout(timeout);
      resolve();
    };
    const timeout = setTimeout(() => {
      child.kill();
      finish();
    }, 2500);
    timeout.unref?.();
    child.on("error", finish);
    child.on("exit", finish);
    child.stdin.on("error", () => {});
    child.stdin.end(JSON.stringify(payload));
  });
}

export default function (pi: ExtensionAPI) {
  if (process.env.HERDR_ENV !== "1" || !process.env.HERDR_PANE_ID) return;

  pi.on("input", async (event, ctx) => {
    // Extension-injected prompts are agent control flow, not user messages.
    if (event.source === "extension") return { action: "continue" as const };

    await updateMetadata({
      hook_event_name: "UserPromptSubmit",
      prompt: event.text,
      cwd: ctx.cwd,
      session_id: ctx.sessionManager.getSessionId(),
    });
    return { action: "continue" as const };
  });
}
