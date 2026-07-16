/**
 * Double Escape Guard — prevents accidental Escape from aborting LLM output.
 *
 * While streaming:
 *   - First Escape shows red warning
 *   - Second Escape within one second aborts
 *   - Timeout or another key resets state
 *
 * While idle:
 *   - Escape behaves normally
 */

import {
  CustomEditor,
  type ExtensionAPI,
  Theme,
} from "@earendil-works/pi-coding-agent";
import {
  matchesKey,
  truncateToWidth,
  visibleWidth,
  type EditorTheme,
  type TUI,
} from "@earendil-works/pi-tui";

interface DoubleEscapeState {
  hintActive: boolean;
  escapeCount: number;
}

interface DoubleEscapeResult {
  state: DoubleEscapeState;
  action: "show_hint" | "abort" | "nothing";
}

const DOUBLE_ESCAPE_INTERVAL_MS = 1000;

function createInitialState(): DoubleEscapeState {
  return {
    hintActive: false,
    escapeCount: 0,
  };
}

function handleEscape(
  currentState: DoubleEscapeState,
  isIdle: boolean,
): DoubleEscapeResult {
  if (isIdle && !currentState.hintActive) {
    return {
      state: currentState,
      action: "nothing",
    };
  }

  const escapeCount = currentState.escapeCount + 1;

  if (escapeCount === 1) {
    return {
      state: {
        hintActive: true,
        escapeCount: 1,
      },
      action: "show_hint",
    };
  }

  return {
    state: createInitialState(),
    action: "abort",
  };
}

function resetState(currentState: DoubleEscapeState): DoubleEscapeResult {
  if (!currentState.hintActive) {
    return {
      state: currentState,
      action: "nothing",
    };
  }

  return {
    state: createInitialState(),
    action: "nothing",
  };
}

class DoubleEscapeEditor extends CustomEditor {
  private escState = createInitialState();
  private debounceTimer: ReturnType<typeof setTimeout> | null = null;

  constructor(
    tui: TUI,
    editorTheme: EditorTheme,
    keybindings: any,
    private readonly appTheme: Theme,
    private readonly isIdle: () => boolean,
    options?: any,
  ) {
    super(tui, editorTheme, keybindings, options);
  }

  private clearDebounce() {
    if (this.debounceTimer === null) {
      return;
    }

    clearTimeout(this.debounceTimer);
    this.debounceTimer = null;
  }

  private startDebounce() {
    this.clearDebounce();

    this.debounceTimer = setTimeout(() => {
      this.escState = resetState(this.escState).state;
      this.debounceTimer = null;
      this.tui.requestRender();
    }, DOUBLE_ESCAPE_INTERVAL_MS);
  }

  handleInput(data: string) {
    if (matchesKey(data, "escape")) {
      const result = handleEscape(this.escState, this.isIdle());
      this.escState = result.state;

      if (result.action === "show_hint") {
        this.startDebounce();
        this.tui.requestRender();
        return;
      }

      if (result.action === "abort") {
        this.clearDebounce();
      }

      super.handleInput(data);
      return;
    }

    if (this.escState.hintActive) {
      this.escState = resetState(this.escState).state;
      this.clearDebounce();
      this.tui.requestRender();
    }

    super.handleInput(data);
  }

  render(width: number) {
    const lines = super.render(width);

    if (lines.length === 0 || !this.escState.hintActive) {
      return lines;
    }

    const label = " press esc again to abort ";
    const styledLabel = this.appTheme.fg("error", label);
    const lastLineIndex = lines.length - 1;
    const line = lines[lastLineIndex]!;
    const lineWidth = visibleWidth(line);
    const trailingWidth = 2;

    if (lineWidth < label.length + trailingWidth) {
      return lines;
    }

    lines[lastLineIndex] =
      truncateToWidth(line, lineWidth - label.length - trailingWidth, "") +
      styledLabel +
      truncateToWidth(line, trailingWidth, "");

    return lines;
  }
}

export default function abortGuard(pi: ExtensionAPI) {
  pi.on("session_start", (_event, ctx) => {
    ctx.ui.setEditorComponent(
      (tui, editorTheme, keybindings) =>
        new DoubleEscapeEditor(
          tui,
          editorTheme,
          keybindings,
          ctx.ui.theme,
          () => ctx.isIdle(),
        ),
    );
  });
}
