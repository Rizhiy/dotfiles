import {
	type ExtensionAPI,
	type ExtensionUIContext,
	UserMessageComponent,
} from "@earendil-works/pi-coding-agent";

const PATCH_OWNER = Symbol("compact-user-message");
const OSC133_ZONE_PATTERN = /^(?:\x1b\]133;[ABC]\x07)+/;

type UserMessageRender = (this: object, width: number) => string[];
type UserMessageRebuild = (this: PatchableUserMessage) => void;

interface PatchableUserMessage {
	addChild(child: unknown): void;
}

interface PatchableBox {
	paddingY: number;
	setBgFn(background?: (text: string) => string): void;
}

interface PatchablePrototype {
	render: UserMessageRender;
	rebuild?: UserMessageRebuild;
	__compactUserMessageOwner?: symbol;
	__compactUserMessageOriginalRender?: UserMessageRender;
	__compactUserMessageOriginalRebuild?: UserMessageRebuild;
}

let activeTheme: ExtensionUIContext["theme"] | undefined;

function isPatchableBox(value: unknown): value is PatchableBox {
	return typeof value === "object" && value !== null && "paddingY" in value && "setBgFn" in value &&
		typeof (value as { paddingY?: unknown }).paddingY === "number" &&
		typeof (value as { setBgFn?: unknown }).setBgFn === "function";
}

function prefixLine(line: string, prefix: string): string {
	const zonePrefix = line.match(OSC133_ZONE_PATTERN)?.[0] ?? "";
	return `${zonePrefix}${prefix}${line.slice(zonePrefix.length)}`;
}

function patchUserMessages(): void {
	const prototype = UserMessageComponent.prototype as unknown as PatchablePrototype;
	if (prototype.__compactUserMessageOwner === PATCH_OWNER) return;
	if (typeof prototype.rebuild !== "function" || typeof prototype.render !== "function") return;

	const originalRebuild = prototype.rebuild;
	const originalRender = prototype.render;
	prototype.__compactUserMessageOriginalRebuild = originalRebuild;
	prototype.__compactUserMessageOriginalRender = originalRender;
	prototype.__compactUserMessageOwner = PATCH_OWNER;

	prototype.rebuild = function compactRebuild(this: PatchableUserMessage): void {
		const originalAddChild = this.addChild;
		this.addChild = function addCompactChild(child: unknown): void {
			if (isPatchableBox(child)) {
				child.paddingY = 0;
				child.setBgFn(undefined);
			}
			originalAddChild.call(this, child);
		};
		try {
			originalRebuild.call(this);
		} finally {
			this.addChild = originalAddChild;
		}
	};

	prototype.render = function compactRender(this: object, width: number): string[] {
		const safeWidth = Math.max(1, Math.floor(width));
		if (safeWidth < 3 || !activeTheme) return originalRender.call(this, safeWidth);

		const lines = originalRender.call(this, safeWidth - 2);
		if (lines.length === 0) return lines;

		const marker = `${activeTheme.fg("success", activeTheme.bold(">"))} `;
		const continuation = "  ";
		return lines.map((line, index) => prefixLine(line, index === 0 ? marker : continuation));
	};
}

function restoreUserMessages(): void {
	const prototype = UserMessageComponent.prototype as unknown as PatchablePrototype;
	if (prototype.__compactUserMessageOwner !== PATCH_OWNER) return;
	if (prototype.__compactUserMessageOriginalRebuild) {
		prototype.rebuild = prototype.__compactUserMessageOriginalRebuild;
	}
	if (prototype.__compactUserMessageOriginalRender) {
		prototype.render = prototype.__compactUserMessageOriginalRender;
	}
	delete prototype.__compactUserMessageOwner;
	delete prototype.__compactUserMessageOriginalRender;
	delete prototype.__compactUserMessageOriginalRebuild;
}

export default function compactUserMessage(pi: ExtensionAPI): void {
	pi.on("session_start", (_event, ctx) => {
		activeTheme = ctx.ui.theme;
		patchUserMessages();
	});
	pi.on("before_agent_start", (_event, ctx) => {
		activeTheme = ctx.ui.theme;
		patchUserMessages();
	});
	pi.on("session_shutdown", () => {
		restoreUserMessages();
		activeTheme = undefined;
	});
}
