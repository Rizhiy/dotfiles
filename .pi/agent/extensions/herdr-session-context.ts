import { spawn } from "node:child_process";
import { homedir } from "node:os";
import { join } from "node:path";
import type { ExtensionAPI, ExtensionContext } from "@earendil-works/pi-coding-agent";

const updater = join(homedir(), ".config", "herdr", "update-agent-session.py");

function updateMetadata(payload: Record<string, unknown>): Promise<string | undefined> {
  return new Promise((resolve) => {
    const child = spawn("/usr/bin/python3", [updater], {
      env: process.env,
      stdio: ["pipe", "pipe", "ignore"],
    });
    let output = "";
    let finished = false;
    const finish = () => {
      if (finished) return;
      finished = true;
      clearTimeout(timeout);
      resolve(output.trim() || undefined);
    };
    const timeout = setTimeout(() => {
      child.kill();
      finish();
    }, 12_000);
    timeout.unref?.();
    child.on("error", finish);
    child.on("exit", finish);
    child.stdout.on("data", (chunk) => {
      if (output.length < 1024) output += String(chunk);
    });
    child.stdin.on("error", () => {});
    child.stdin.end(JSON.stringify(payload));
  });
}

function latestAssistantResponse(ctx: ExtensionContext): string {
  const branch = ctx.sessionManager.getBranch();
  for (let index = branch.length - 1; index >= 0; index -= 1) {
    const entry = branch[index];
    if (entry.type !== "message" || entry.message.role !== "assistant") continue;
    const text = entry.message.content
      .map((block) => (block.type === "text" ? block.text : ""))
      .filter(Boolean)
      .join("\n")
      .trim();
    if (text) return text.slice(0, 8_000);
  }
  return "";
}

export default function (pi: ExtensionAPI) {
  if (process.env.HERDR_ENV !== "1" || !process.env.HERDR_PANE_ID) return;

  pi.on("input", async (event, ctx) => {
    // Extension-injected prompts are agent control flow, not user messages.
    if (event.source === "extension") return { action: "continue" as const };

    const title = await updateMetadata({
      hook_event_name: "UserPromptSubmit",
      prompt: event.text,
      assistant_response: latestAssistantResponse(ctx),
      current_title: pi.getSessionName(),
      return_title: true,
      cwd: ctx.cwd,
      session_id: ctx.sessionManager.getSessionId(),
    });
    if (title) pi.setSessionName(title);
    return { action: "continue" as const };
  });
}
