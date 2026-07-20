import { existsSync, readdirSync } from "node:fs";
import path from "node:path";
import type {
  ExtensionAPI,
  ExtensionContext,
} from "@earendil-works/pi-coding-agent";

type Inventory = {
  extensions: number;
  prompts: number;
  skills: number;
  themes: number;
};

type WelcomeState = {
  inventory: Inventory;
  model: string;
  project: string;
  quote: string;
  startupSeconds: number;
  tip: string;
};

type Rgb = [number, number, number];
type HeaderColor = "accent" | "dim" | "mdQuote" | "muted" | "success" | "text";

const RESET = "\x1b[0m";
const RAINBOW_PALETTE: Rgb[] = [
  [220, 50, 50],
  [50, 200, 80],
  [48, 129, 247],
  [220, 50, 50],
  [50, 200, 80],
  [48, 129, 247],
];
const BORDER_RED: Rgb = [220, 50, 50];
const BORDER_BLUE: Rgb = [48, 129, 247];
const TIP_YELLOW: Rgb = [255, 215, 70];

const PI_LOGO = [
  "████████████╗    ",
  "████████████║    ",
  "████╔═══████║    ",
  "████║   ████║    ",
  "████████╔═══████╗",
  "████████║   ████║",
  "████╔═══╝   ████║",
  "████║       ████║",
  "╚═══╝       ╚═══╝",
];

// Stored locally: no network calls, APIs, or external data sources.
const QUOTES = [
  "Small steps compound into shipped work.",
  "Clarity is a feature you build twice.",
  "Good tools disappear into momentum.",
  "Leave the next reader a better path.",
  "The fastest loop is understand, change, verify.",
  "Make the useful path the easy path.",
  "A clean handoff begins with a clear next step.",
  "Momentum prefers a small verified change.",
  "Useful beats impressive when the clock is running.",
  "Every good shortcut begins as a repeated frustration.",
  "The right detail arrives at the right moment.",
  "Make the path visible before making it fast.",
  "A quiet tool is often a well-designed tool.",
  "Progress is a trail someone else can follow.",
  "Ship the smallest thing that proves the larger thing.",
  "Strong systems make the safe action the easy action.",
  "A good question saves a long wrong answer.",
  "Work becomes lighter when feedback arrives early.",
  "The next edit should reduce uncertainty.",
  "Precision is kindness to future you.",
  "A finished loop teaches more than a perfect plan.",
  "Keep the signal; discard the ceremony.",
  "Simple interfaces make difficult work feel possible.",
  "Verification turns intention into confidence.",
];

const TIPS = [
  "Use @ to reference files without leaving the editor.",
  "Use /tree to jump to any point in a session branch.",
  "Use Shift+Tab to cycle model thinking levels.",
  "Use /reload after changing extensions, skills, prompts, or themes.",
  "Use !!command to run shell output without sending it to the model.",
  "Use Ctrl+O to collapse or expand tool output.",
  "Use /compact when a long session needs fresh context headroom.",
  "Use /hotkeys for every built-in shortcut in this terminal.",
  "Use Ctrl+L to open the model selector.",
  "Use Ctrl+P or Shift+Ctrl+P to cycle scoped models.",
  "Use /settings to switch themes or adjust thinking and delivery modes.",
  "Use /session to inspect current session file, tokens, and cost.",
  "Use /name to give a session a readable label.",
  "Use /resume to browse and continue an earlier session.",
  "Use /new to begin a fresh session without leaving Pi.",
  "Use /copy to copy the last assistant response.",
  "Use /export to save a session as HTML or JSONL.",
  "Use /trust to save a project trust decision for future sessions.",
  "Use Ctrl+T to collapse or expand model thinking blocks.",
  "Use Ctrl+G to open the editor in your external editor.",
  "Use Escape twice to open the session tree quickly.",
  "Use !command to run shell output and send it to the model.",
  "Use /skill:name to invoke an installed skill directly.",
  "Use /model to select a provider model from the command palette.",
  "Use /fork to branch before a previous user message.",
  "Use /clone to duplicate the active session branch at its current point.",
  "Use Shift+L in /tree to label a useful checkpoint.",
  "Use /changelog to see what changed in Pi.",
  "Use /quit when you are done; Ctrl+C twice does the same.",
  "Use --no-session when you want an ephemeral Pi run.",
  "Use /login to manage provider authentication from Pi.",
  "Use /scoped-models to control models available through Ctrl+P cycling.",
];

function mix(a: number, b: number, amount: number) {
  return Math.round(a + (b - a) * amount);
}

function gradientColor(position: number) {
  const wrapped = ((position % 1) + 1) % 1;
  const scaled = wrapped * RAINBOW_PALETTE.length;
  const index = Math.floor(scaled);
  const amount = scaled - index;
  const start = RAINBOW_PALETTE[index]!;
  const end = RAINBOW_PALETTE[(index + 1) % RAINBOW_PALETTE.length]!;
  return [
    mix(start[0], end[0], amount),
    mix(start[1], end[1], amount),
    mix(start[2], end[2], amount),
  ] as Rgb;
}

function color([red, green, blue]: Rgb, text: string) {
  return `\x1b[38;2;${red};${green};${blue}m${text}${RESET}`;
}

function gradient(text: string, phase = 0) {
  const chars = [...text];
  const span = Math.max(chars.length - 1, 1);
  return chars
    .map((char, index) => {
      if (char === " ") return char;
      return color(gradientColor(index / span + phase), char);
    })
    .join("");
}

function borderGradient(text: string) {
  const chars = [...text];
  const span = Math.max(chars.length - 1, 1);
  return chars
    .map((char, index) => char === " " ? char : color([
      mix(BORDER_RED[0], BORDER_BLUE[0], index / span),
      mix(BORDER_RED[1], BORDER_BLUE[1], index / span),
      mix(BORDER_RED[2], BORDER_BLUE[2], index / span),
    ], char))
    .join("");
}

function limit(text: string, width: number) {
  if (width <= 0) return "";
  const chars = [...text];
  if (chars.length <= width) return text;
  if (width === 1) return "…";
  return `${chars.slice(0, width - 1).join("")}…`;
}

function center(text: string, width: number) {
  const clipped = limit(text, width);
  const padding = Math.max(0, width - [...clipped].length);
  return `${" ".repeat(Math.floor(padding / 2))}${clipped}${" ".repeat(Math.ceil(padding / 2))}`;
}

function choose(values: readonly string[]) {
  return values[Math.floor(Math.random() * values.length)]!;
}

function countFiles(
  directory: string,
  matches: (name: string) => boolean,
): number {
  if (!existsSync(directory)) return 0;

  let count = 0;
  for (const entry of readdirSync(directory, { withFileTypes: true })) {
    const target = path.join(directory, entry.name);
    if (entry.isDirectory()) count += countFiles(target, matches);
    else if (matches(entry.name)) count += 1;
  }
  return count;
}

function getInventory() {
  const home = process.env.HOME ?? "";
  const agentDirectory =
    process.env.PI_CODING_AGENT_DIR ?? path.join(home, ".pi", "agent");
  const extensionsDirectory = path.join(agentDirectory, "extensions");
  const extensionEntries = existsSync(extensionsDirectory)
    ? readdirSync(extensionsDirectory, { withFileTypes: true })
    : [];

  return {
    extensions: extensionEntries.filter(
      (entry) =>
        (entry.isFile() && entry.name.endsWith(".ts")) ||
        (entry.isDirectory() &&
          existsSync(path.join(extensionsDirectory, entry.name, "index.ts"))),
    ).length,
    prompts: countFiles(path.join(agentDirectory, "prompts"), (name) =>
      name.endsWith(".md"),
    ),
    skills:
      countFiles(
        path.join(agentDirectory, "skills"),
        (name) => name === "SKILL.md",
      ) +
      countFiles(
        path.join(home, ".agents", "skills"),
        (name) => name === "SKILL.md",
      ),
    themes: countFiles(path.join(agentDirectory, "themes"), (name) =>
      name.endsWith(".json"),
    ),
  };
}

function projectName(cwd: string) {
  return path.basename(cwd) || "session";
}

function twoColumns(left: string, right: string, width: number) {
  const gap = "   ";
  const leftWidth = Math.floor((width - gap.length) / 2);
  const rightWidth = width - gap.length - leftWidth;
  return `${limit(left, leftWidth).padEnd(leftWidth)}${gap}${limit(right, rightWidth)}`;
}

function renderWideHeader(
  width: number,
  state: WelcomeState,
  theme: ExtensionContext["ui"]["theme"],
) {
  const frameWidth = Math.min(Math.max(76, width - 12), 98);
  const innerWidth = frameWidth - 2;
  const contentWidth = Math.max(1, innerWidth - 6);
  const margin = " ".repeat(Math.max(0, Math.floor((width - frameWidth) / 2)));
  const leftBorder = (value: string) => color(BORDER_RED, value);
  const rightBorder = (value: string) => color(BORDER_BLUE, value);
  const inset = (content: string) =>
    center(center(content, contentWidth), innerWidth);
  const line = (content: string, colorName: HeaderColor = "text") =>
    `${margin}${leftBorder("│")}${theme.fg(colorName, inset(content))}${rightBorder("│")}`;
  const yellowLine = (content: string) =>
    `${margin}${leftBorder("│")}${color(TIP_YELLOW, inset(content))}${rightBorder("│")}`;
  const rainbowLine = (content: string, phase = 0) =>
    `${margin}${leftBorder("│")}${gradient(inset(content), phase)}${rightBorder("│")}`;
  const section = (title: string) =>
    `─ ${title} ${"─".repeat(Math.max(0, contentWidth - [...title].length - 3))}`;
  const identity = `${state.model} · ${state.project}`;
  const modelLine = inset(identity);
  const inventory = state.inventory;

  return [
    "",
    `${margin}${borderGradient(`╭${"─".repeat(innerWidth)}╮`)}`,
    line(""),
    line(""),
    ...PI_LOGO.map((logoLine, row) => rainbowLine(logoLine, row * 0.045)),
    `${margin}${leftBorder("│")}${gradient(modelLine, PI_LOGO.length * 0.045)}${rightBorder("│")}`,
    line(""),
    line(""),
    line(`“${state.quote}”`, "mdQuote"),
    line(""),
    line(""),
    line(section("START UP"), "accent"),
    line(`Pi started in ${state.startupSeconds.toFixed(1)} seconds`, "success"),
    line(""),
    line(section("QUICK TIP"), "accent"),
    yellowLine(limit(state.tip, contentWidth)),
    line(""),
    line(section("LOADED"), "accent"),
    line(
      limit(
        `${inventory.extensions} extensions  ·  ${inventory.skills} skills  ·  ${inventory.prompts} prompts  ·  ${inventory.themes} themes`,
        contentWidth,
      ),
      "muted",
    ),
    line(""),
    `${margin}${borderGradient(`╰${"─".repeat(innerWidth)}╯`)}`,
    "",
  ];
}

function renderCompactHeader(
  width: number,
  state: WelcomeState,
  theme: ExtensionContext["ui"]["theme"],
) {
  // Keep one physical cell free on each side: prevents mobile-terminal auto-wrap and balances margins.
  const frameWidth = Math.max(1, width - 2);
  const innerWidth = Math.max(0, frameWidth - 2);
  const margin = " ".repeat(Math.max(0, Math.floor((width - frameWidth) / 2)));
  const leftBorder = (value: string) => color(BORDER_RED, value);
  const rightBorder = (value: string) => color(BORDER_BLUE, value);
  const line = (content: string, colorName: HeaderColor = "text") =>
    `${margin}${leftBorder("│")}${theme.fg(colorName, center(content, innerWidth))}${rightBorder("│")}`;
  const yellowLine = (content: string) =>
    `${margin}${leftBorder("│")}${color(TIP_YELLOW, center(content, innerWidth))}${rightBorder("│")}`;

  return [
    "",
    `${margin}${borderGradient(`╭${"─".repeat(innerWidth)}╮`)}`,
    line(""),
    ...PI_LOGO.map(
      (logoLine, row) =>
        `${margin}${leftBorder("│")}${gradient(center(logoLine, innerWidth), row * 0.045)}${rightBorder("│")}`,
    ),
    `${margin}${leftBorder("│")}${gradient(center(`${state.model} · ${state.project}`, innerWidth), PI_LOGO.length * 0.045)}${rightBorder("│")}`,
    line(""),
    line(`“${state.quote}”`, "mdQuote"),
    line(""),
    line(`Pi started in ${state.startupSeconds.toFixed(1)} seconds`, "success"),
    line(""),
    line("QUICK TIP", "accent"),
    yellowLine(limit(state.tip, innerWidth)),
    `${margin}${borderGradient(`╰${"─".repeat(innerWidth)}╯`)}`,
    "",
  ];
}

export default function (pi: ExtensionAPI) {
  const state: WelcomeState = {
    inventory: { extensions: 0, prompts: 0, skills: 0, themes: 0 },
    model: "no model selected",
    project: "session",
    quote: QUOTES[0]!,
    startupSeconds: 0,
    tip: TIPS[0]!,
  };
  let requestRender: (() => void) | undefined;

  function installHeader(ctx: ExtensionContext) {
    ctx.ui.setHeader((tui, theme) => {
      requestRender = () => tui.requestRender();
      return {
        render(width: number) {
          return width >= 76
            ? renderWideHeader(width, state, theme)
            : renderCompactHeader(width, state, theme);
        },
        invalidate() {
          tui.requestRender();
        },
      };
    });
  }

  pi.on("session_start", (_event, ctx) => {
    if (!ctx.hasUI) return;
    state.inventory = getInventory();
    state.model = ctx.model?.id ?? "no model selected";
    state.project = projectName(ctx.cwd);
    state.startupSeconds = process.uptime();
    state.quote = choose(QUOTES);
    state.tip = choose(TIPS);
    installHeader(ctx);
  });

  pi.on("model_select", (event) => {
    state.model = event.model.id;
    requestRender?.();
  });

  pi.on("session_shutdown", (_event, ctx) => {
    requestRender = undefined;
    if (ctx.hasUI) ctx.ui.setHeader(undefined);
  });

  pi.registerCommand("flow-title", {
    description: "Enable the Pi welcome header",
    handler: async (_args, ctx) => {
      installHeader(ctx);
      ctx.ui.notify("Pi welcome header enabled", "info");
    },
  });

  pi.registerCommand("flow-title-builtin", {
    description: "Restore pi's built-in startup header for this session",
    handler: async (_args, ctx) => {
      ctx.ui.setHeader(undefined);
      ctx.ui.notify("Built-in header restored", "info");
    },
  });
}
