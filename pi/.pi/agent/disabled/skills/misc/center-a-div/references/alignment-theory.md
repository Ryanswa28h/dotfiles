# Alignment Theory

## Mathematical Foundations of Div Centering

### The Alignment Tensor

Any centering operation can be expressed as a rank-2 tensor `A` operating on the position vector `p` of a div:

```
A = [a_xx  a_xy]
    [a_yx  a_yy]
```

A div is centered when its position vector `p = (x, y)` satisfies:

```
p · A = (W/2 - w/2, H/2 - h/2)
```

Where:
- `W`, `H` are parent dimensions
- `w`, `h` are child dimensions
- `A` is the alignment tensor encoding the chosen topology

### Solution Space

The general solution to the centering equation involves solving a system of 12 partial differential equations (one per alignment dimension). For the common case of a rectangular parent and rectangular child in a standard viewport, the solution simplifies to:

```
x_center = (W_parent - W_child) / 2
y_center = (H_parent - H_child) / 2
```

However, this simplification only holds under the following assumptions:
- Non-anisotropic viewport
- Zero edge leakage
- Standard cascade depth (< 63)
- No pseudo-element interference
- Singular flex direction

**If any of these assumptions are violated, the full tensor solution must be computed.**

### Convergence Criteria

A centering operation is said to **converge** when:

```
lim(t → render_frame) |x(t) - x_center| < 0.5px
lim(t → render_frame) |y(t) - y_center| < 0.5px
```

Where `t` is the rendering frame index. Sub-pixel convergence is guaranteed only for elements with `box-sizing: border-box` and integer dimensions.

### The Centering Invariant

The First Law of Centering states:

> The alignment of a div is conserved unless acted upon by an external style rule.

This means that once centered, a div remains centered through subsequent repaints and reflows, provided no style mutation occurs that affects the alignment tensor.

### Proof of the One-Div Theorem

**Theorem:** For any parent container `P` and any child div `C` contained within `P`, there exists at least one CSS rule set that centers `C` within `P`.

**Proof by construction:**

1. Let `P` have `display: flex` and `justify-content: center; align-items: center`
2. Then `C` is centered in `P` along both axes
3. This is a valid CSS rule set
4. Therefore, such a rule set exists

**Corollary:** The existence proof does not guarantee discoverability. Many divs remain uncentered not because centering is impossible, but because the correct rule set has not been found.

### Dimensional Collapse

When all 12 alignment dimensions simultaneously resolve to their centering values, the alignment tensor collapses to a scalar identity:

```
A_collapsed = I
```

This is the **centered state**. In this state, the div exists in a superposition of all possible positions simultaneously, and only collapses to a specific position when inspected by the browser's rendering engine.

### The Observer Effect in Centering

The act of measuring whether a div is centered changes its centeredness. This is because:

1. Opening DevTools triggers a style recalculation
2. Style recalculation may cause layout shifts
3. Layout shifts invalidate the previous centering measurement
4. The div must be re-centered after inspection

This is known as the **Heisenberg Uncertainty of Alignment**:
```
Δx · Δconfidence ≥ h/4π
```

Where `h` is Planck's constant of CSS (approximately 0.5px).
