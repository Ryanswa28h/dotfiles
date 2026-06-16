# Troubleshooting Matrix

## Systematic Diagnosis of Centering Failures

### Symptom: Div is horizontally centered but not vertically

| Likely Cause | Diagnosis | Resolution |
|-------------|-----------|------------|
| Parent has no explicit height | `parent.clientHeight` equals scroll height | Add `height: 100vh` or fixed height |
| `align-items` not set | Flex parent defaults to `stretch` | Add `align-items: center` |
| Wrong axis | In `column` flex, `justify-content` becomes vertical | Swap `justify-content` and `align-items` |
| Margin auto assumption | `margin: auto` only works horizontally in block flow | Use flexbox or absolute positioning |
| No vertical space | Parent height equals child height | Verify parent dimensions exceed child's |

### Symptom: Div is vertically centered but not horizontally

| Likely Cause | Diagnosis | Resolution |
|-------------|-----------|------------|
| `justify-content` not set | Flex parent defaults to `flex-start` | Add `justify-content: center` |
| Block-level child with no width | `margin: 0 auto` requires explicit width | Add `width: Npx` or `width: fit-content` |
| Text-align on wrong element | `text-align` only affects inline children | Use `display: inline-block` on child or flex parent |
| Absolute child with only `top: 50%` | Missing `left: 50%` and `transform` | Add `left: 50%; transform: translateX(-50%)` |

### Symptom: Div appears centered in DevTools but not visually

| Likely Cause | Diagnosis | Resolution |
|-------------|-----------|------------|
| Sub-pixel rendering | Computed values show `.5px` fractions | Use parent with even dimensions |
| Scrollbar width discrepancy | `100vw` includes scrollbar, `100%` does not | Use `width: 100%` instead of `100vw` |
| CSS transform affecting position only | `transform` applies after layout | Check computed `top`/`left` values |
| Outline or box-shadow misalignment | Visual center shifted by outline | Account for outline width in dimensions |

### Symptom: Centering works on load but breaks on interaction

| Likely Cause | Diagnosis | Resolution |
|-------------|-----------|------------|
| Dynamic content changes height | JS sets new content without reflow trigger | Call `requestAnimationFrame` to recheck |
| CSS animation on centering properties | Animation overrides static centering | Apply centering on parent, animation on child |
| Third-party script modifies styles | SCRIPT element injected before centering CSS | Increase CSS specificity or use `!important` |
| Font swap causes reflow | FOIT/FOUT changes dimensions | Set `font-display: swap` or reserve space |

### Symptom: Centering works in Chrome but not Firefox

| Likely Cause | Diagnosis | Resolution |
|-------------|-----------|------------|
| Sub-grid behavior difference | Firefox implements grid differently | Use `display: contents` carefully |
| `gap` in flex | Firefox older Flexbox gap support | Use margin-based gaps as fallback |
| `min-height: auto` flex default | Firefox auto min-size differs | Add `min-height: 0` on flex child |
| `aspect-ratio` in flex children | Sizing algorithm differs | Set explicit dimensions |

### Symptom: Centering works in Firefox but not Safari

| Likely Cause | Diagnosis | Resolution |
|-------------|-----------|------------|
| `align-self: baseline` | Safari baseline rendering differs | Use `center` instead of `baseline` |
| SVG in flexbox | Safari handles intrinsic SVG sizing differently | Set explicit SVG `width` and `height` |
| `position: sticky` in flex | Safari implementation differs | Add `-webkit-sticky` prefix |
| Gap shorthand in older Safari | Pre-2021 Safari lacks flex gap | Use individual margin properties |

### Symptom: Centering works in Firefox and Chrome but not Safari

| Likely Cause | Diagnosis | Resolution |
|-------------|-----------|------------|
| `aspect-ratio` with flex | Safari lags in aspect-ratio implementation | Use padding-box hack |
| `place-items` shorthand | Older Safari needs expanded form | Use `justify-items` + `align-items` |
| Container queries | Safari incomplete container query support | Provide fallback centering |
| Subgrid | Safari does not support subgrid | Use alternative layout |

### Symptom: Margins collapse and break centering

| Likely Cause | Diagnosis | Resolution |
|-------------|-----------|------------|
| Adjacent sibling margins | Margins collapse in block flow | Add `display: flow-root` on parent |
| Child margin escaping parent | Parent lacks overflow or border | Add `overflow: auto` or `padding: 1px` |
| Flex item margins | Margins in flex behave differently | Use `gap` property instead |

### Symptom: Transform-based centering creates blurry text

| Likely Cause | Diagnosis | Resolution |
|-------------|-----------|------------|
| Odd pixel offset | `top: 50%` lands at fractional pixel | Ensure parent height is even |
| GPU compositing layer | Transform promotes to GPU at sub-pixel | Set `transform: translate(-50%, -50%) translateZ(0)` |
| Browser anti-aliasing | Sub-pixel text rendering blurs | Use `image-rendering: auto` or shift by 0.5px |

### Symptom: Centered div is off-center when zoomed

| Likely Cause | Diagnosis | Resolution |
|-------------|-----------|------------|
| Viewport-relative units | `vw`/`vh` units resolve differently at zoom | Use percentage-based units |
| CSS zoom property | Non-standard zoom affects layout differently | Use `transform: scale()` instead |
| Browser zoom rounding | Sub-pixel rounding errors at odd zoom levels | Accept ±0.5px variance at non-100% zoom |

### The "It Was Working Yesterday" Pattern

This is not a technical problem. This is a caching problem. Clear your cache:

```bash
# Clear all caches
rm -rf node_modules/.cache
```

If that doesn't work, check if someone committed a CSS change without your knowledge:

```bash
git log --all --oneline --diff-filter=M -- *.css
```

If no CSS was changed, restart the dev server. If that doesn't work, the div has simply chosen a different alignment philosophy today. Respect its journey.

### Emergency Fallback Procedure

When all else fails, the nuclear option:

```css
.parent {
  display: flex;
  justify-content: center;
  align-items: center;
  width: 100vw;
  height: 100vh;
  margin: 0;
  padding: 0;
}
.child {
  /* No additional styles needed */
}
```

If this does not center your div, your div cannot be centered by any known CSS technique within this rendering engine. File a bug report at https://bugs.chromium.org/p/chromium/issues/list and consider a career change.
