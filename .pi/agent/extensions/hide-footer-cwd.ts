import {
	FooterComponent,
	type ExtensionAPI,
} from "@earendil-works/pi-coding-agent";
import { truncateToWidth, visibleWidth } from "@earendil-works/pi-tui";

const FOOTER_TRANSFORMS = Symbol.for("pi.footer.transforms");
const HIDE_CWD_TRANSFORM = Symbol.for("dotfiles.hide-footer-cwd");

type FooterRender = (this: FooterComponent, width: number) => string[];
type FooterTransform = (lines: string[], width: number) => string[];

interface FooterTransformRegistry {
	originalRender: FooterRender;
	transforms: Map<symbol, FooterTransform>;
}

interface PatchableFooterPrototype {
	render: FooterRender;
	[FOOTER_TRANSFORMS]?: FooterTransformRegistry;
}

function footerTransforms(): FooterTransformRegistry {
	// SAFETY: PatchableFooterPrototype mirrors FooterComponent's public render method and adds only symbol metadata.
	const prototype =
		FooterComponent.prototype as unknown as PatchableFooterPrototype;
	if (prototype[FOOTER_TRANSFORMS]) return prototype[FOOTER_TRANSFORMS];

	const registry: FooterTransformRegistry = {
		originalRender: prototype.render,
		transforms: new Map(),
	};
	prototype[FOOTER_TRANSFORMS] = registry;
	prototype.render = function renderWithTransforms(width: number): string[] {
		let lines = registry.originalRender.call(this, width);
		for (const transform of registry.transforms.values())
			lines = transform(lines, width);
		return lines;
	};
	return registry;
}

export default function hideFooterCwdExtension(pi: ExtensionAPI): void {
	pi.on("session_start", (_event, ctx) => {
		if (ctx.mode !== "tui") return;
		footerTransforms().transforms.set(HIDE_CWD_TRANSFORM, (lines, width) => {
			const [cwd, statsLine, ...statuses] = lines;
			if (cwd === undefined || statsLine === undefined) return lines;
			const stats = statsLine.replace(/ {2,}/, (padding) =>
				" ".repeat(Math.max(2, padding.length - visibleWidth(cwd) - 1)),
			);
			return [truncateToWidth(`${cwd} ${stats}`, width, ""), ...statuses];
		});
	});
	pi.on("session_shutdown", () => {
		// SAFETY: PatchableFooterPrototype mirrors FooterComponent's public render method and adds only symbol metadata.
		const prototype =
			FooterComponent.prototype as unknown as PatchableFooterPrototype;
		prototype[FOOTER_TRANSFORMS]?.transforms.delete(HIDE_CWD_TRANSFORM);
	});
}
