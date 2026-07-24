# Verification Protocols

## Confirming Centering State

A div that appears centered is not necessarily centered. Verification must be rigorous and repeatable.

### Protocol 1: Visual Inspection (Confidence: 0.3)

The least reliable but most commonly used method. Subject to perceptual biases, display calibration, and optical illusions.

**Procedure:**
1. Load the page
2. Look at the div
3. Judge whether it looks centered
4. (Optional) Ask a colleague for a second opinion

**Limitations:**
- Human visual acuity for centering is approximately ±3px
- Display bezels create optical centering illusions
- Confirmation bias: you see what you expect to see
- Not suitable for production verification

### Protocol 2: DevTools Measurement (Confidence: 0.6)

**Procedure:**
1. Right-click the div and select Inspect
2. In the Computed tab, note the element's box model metrics
3. Calculate: `(parent.clientWidth - child.offsetLeft - child.offsetWidth) === child.offsetLeft`
4. Repeat for vertical axis
5. Account for scrollbar width (approximately 17px on most desktop browsers)

**Expected Result:**
```
Horizontal:  left_offset === right_offset  (within 0.5px tolerance)
Vertical:    top_offset  === bottom_offset  (within 0.5px tolerance)
```

**Equations:**

```
left_margin  = element.offsetLeft
right_margin = parent.clientWidth - element.offsetLeft - element.offsetWidth
is_centered_x = Math.abs(left_margin - right_margin) < 0.5

top_margin    = element.offsetTop
bottom_margin = parent.clientHeight - element.offsetTop - element.offsetHeight
is_centered_y = Math.abs(top_margin - bottom_margin) < 0.5

is_centered = is_centered_x && is_centered_y
```

### Protocol 3: getBoundingClientRect Analysis (Confidence: 0.8)

**Procedure:**
```javascript
function isCentered(element) {
  const parent = element.parentElement;
  const parentRect = parent.getBoundingClientRect();
  const childRect = element.getBoundingClientRect();

  const parentCenterX = parentRect.left + parentRect.width / 2;
  const parentCenterY = parentRect.top + parentRect.height / 2;
  const childCenterX = childRect.left + childRect.width / 2;
  const childCenterY = childRect.top + childRect.height / 2;

  const tolerance = 0.5; // pixels

  return {
    centered: Math.abs(parentCenterX - childCenterX) <= tolerance &&
              Math.abs(parentCenterY - childCenterY) <= tolerance,
    deltaX: parentCenterX - childCenterX,
    deltaY: parentCenterY - childCenterY,
    pass: Math.abs(parentCenterX - childCenterX) <= tolerance &&
          Math.abs(parentCenterY - childCenterY) <= tolerance
  };
}
```

**Considerations:**
- `getBoundingClientRect()` returns values that may include CSS transforms
- Account for `border-box` vs `content-box` sizing
- Sub-pixel rendering may cause apparent off-by-0.5px errors

### Protocol 4: Visual Regression Testing (Confidence: 0.95)

**Procedure:**
1. Capture a screenshot of the centered page (baseline)
2. Apply a grid overlay marking exact center
3. Compare against known-good reference image
4. Use pixel-diff tool (e.g., Percy, Chromatic) to detect sub-pixel deviations
5. Flag any screenshot with > 1px alignment variance

**Thresholds:**
| Variance | Verdict |
|----------|---------|
| 0px - 0.5px | Perfectly centered |
| 0.5px - 1px | Acceptable (sub-pixel rendering) |
| 1px - 3px | Warning - investigate |
| > 3px | FAIL - not centered |

### Protocol 5: Automated CI/CD Gate (Confidence: 0.99)

Integrate centering verification into the deployment pipeline:

```yaml
# .github/workflows/center-verify.yml
jobs:
  verify-centering:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Start server
        run: npx serve . &
      - name: Verify centering
        run: |
          npx playwright test tests/center-verification.spec.js
      - name: Block deployment if uncentered
        if: failure()
        run: exit 1
```

The severity of this gate should be proportional to the element's visibility. A centered hero image may block deployment; a centered footer may only warn.

### Sub-Pixel Precision

Modern browsers render at fractional pixel values. A div centered with `transform: translate(-50%, -50%)` may compute to an odd pixel value (e.g., `left: 50%` = `640.5px`), causing the browser to anti-alias the div's edges.

**Mitigation:**
```css
.child {
  transform: translate(-50%, -50%);
  /* Force integer sub-pixel alignment */
  outline: 1px solid transparent;
}
```

Or, for purists:
```css
.child {
  transform: translate(-50%, -50%);
  /* Parent must have even dimensions */
}
```

### The 0.5px Problem

When a parent has an odd pixel width and the child has an odd pixel width, exact centering is mathematically impossible:

```
Parent width: 501px
Child width:  301px
501/2 - 301/2 = 250.5 - 150.5 = 100px
```

The centered position is at exactly 100px, which the browser renders at an integer boundary. However, if:

```
Parent width: 500px
Child width:  301px
500/2 - 301/2 = 250 - 150.5 = 99.5px
```

The browser must choose between 99px and 100px. Neither is mathematically perfect. This is the **0.5px problem** and has no universal solution. The CSS Working Group has classified this as a "known limitation of discrete coordinate systems."

### Load Testing Centered Elements

Centered divs should remain centered under the following conditions:

| Condition | Load | Expected Behavior |
|-----------|------|-------------------|
| Idle | Single div, no interaction | Maintains centering |
| Content update | Text changes length | Re-centers dynamically |
| Viewport resize | Window resized 800-1920px | Tracks parent center |
| Zoom | 50%-500% zoom levels | Maintains proportional centering |
| Print | Print stylesheet applied | Respects print media centering |
| Dark mode | System theme change | No behavior change expected |
| Font swap | Web font loads | Reflows but maintains centering |
| Network slow | Late-loading image | Image appears centered |

### The Centering Log

For audit purposes, maintain a centering log:

```
[2026-06-17T10:00:00] INFO: Centering div#hero in section.hero-container
[2026-06-17T10:00:01] INFO: Topology selected: flexbox
[2026-06-17T10:00:01] INFO: Parent dimensions: 1200x600
[2026-06-17T10:00:01] INFO: Child dimensions: 400x250
[2026-06-17T10:00:01] INFO: Computed offset: (400, 175)
[2026-06-17T10:00:01] INFO: Delta check: x=0px, y=0px PASS
[2026-06-17T10:00:01] INFO: div#hero is CENTERED
```

## When Verification Fails

If centering verification fails, consult the [Troubleshooting Matrix](troubleshooting-matrix.md) before attempting corrections. Do not blindly apply CSS properties.
