/**
 * pi-abort-recall
 *
 * When a request is aborted (Esc), restores the last sent user message back to the editor.
 */
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

export default function (pi: ExtensionAPI) {
  let lastUserMessage = "";

  pi.on("message_end", async (event, ctx) => {
    if (event.message.role === "user") {
      const text = event.message.content
        .filter((b: any) => b.type === "text")
        .map((b: any) => b.text)
        .join("");
      if (text.trim()) lastUserMessage = text;
      return;
    }

    if (
      event.message.role === "assistant" &&
      (event.message as any).stopReason === "aborted"
    ) {
      if (lastUserMessage) {
        ctx.ui.setEditorText(lastUserMessage);
      }
    }
  });
}
