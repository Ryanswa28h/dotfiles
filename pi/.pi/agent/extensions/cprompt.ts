/**
 * /cprompt — Copy the last user prompt (not the assistant response) to clipboard.
 *
 * Inspired by the built-in /copy (which copies the assistant's last response).
 *
 * Usage:
 *   /cprompt    Copy last user message to clipboard
 */

import { spawn } from "node:child_process";
import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";

/** Extract plain text from a message content field (string or content block array). */
function textFromContent(content: unknown): string {
  if (typeof content === "string") return content;
  if (!Array.isArray(content)) return "";

  return content
    .map((block) => {
      if (!block || typeof block !== "object") return "";
      if (!("type" in block)) return "";
      if (block.type === "text" && "text" in block && typeof block.text === "string") {
        return block.text;
      }
      if (block.type === "image") return "[image]";
      return "";
    })
    .filter(Boolean)
    .join("\n");
}

/** Copy text to clipboard via wl-copy (Wayland), falling back to xclip (X11). */
function copyToClipboard(text: string): Promise<void> {
  return new Promise((resolve, reject) => {
    const cmd = spawn("wl-copy");
    let stderr = "";

    cmd.stderr.on("data", (chunk: Buffer) => {
      stderr += String(chunk);
    });
    cmd.on("error", () => {
      // wl-copy not found; try xclip
      const fallback = spawn("xclip", ["-selection", "clipboard"]);
      let fbErr = "";
      fallback.stderr.on("data", (chunk: Buffer) => {
        fbErr += String(chunk);
      });
      fallback.on("error", () =>
        reject(new Error("No clipboard tool found — install wl-clipboard or xclip")),
      );
      fallback.on("close", (code) => {
        if (code === 0) resolve();
        else reject(new Error(fbErr.trim() || `xclip exited with code ${code}`));
      });
      fallback.stdin.end(text);
    });
    cmd.on("close", (code) => {
      if (code === 0) resolve();
      else reject(new Error(stderr.trim() || `wl-copy exited with code ${code}`));
    });
    cmd.stdin.end(text);
  });
}

export default function (pi: ExtensionAPI) {
  pi.registerCommand("cprompt", {
    description: "Copy the last prompt (user message) to clipboard",
    handler: async (_args, ctx) => {
      await ctx.waitForIdle();

      const entries = ctx.sessionManager.getBranch();

      // getBranch() returns oldest first; iterate from the end to find the last user message.
      let lastUserContent: string | null = null;
      for (let i = entries.length - 1; i >= 0; i--) {
        const entry = entries[i];
        if (entry.type !== "message") continue;
        const msg = entry.message;
        if (msg.role !== "user") continue;
        lastUserContent = textFromContent(msg.content).trim();
        break;
      }

      if (!lastUserContent) {
        ctx.ui.notify("No user prompt found on the active branch", "error");
        return;
      }

      try {
        await copyToClipboard(lastUserContent);
        ctx.ui.notify("Copied last prompt to clipboard", "info");
      } catch (e: unknown) {
        const msg = e instanceof Error ? e.message : String(e);
        ctx.ui.notify(`Clipboard error: ${msg}`, "error");
      }
    },
  });
}
