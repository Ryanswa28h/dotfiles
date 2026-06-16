# Supported Topologies

## Comprehensive Catalog of Centering Layout Models

### 1. Flexbox Topology

**Specification:** CSS Flexible Box Layout Module Level 1

**Discovered:** 2009 (as draft), 2012 (as candidate recommendation)

**Energy Required:** Moderate

```css
.parent {
  display: flex;
  justify-content: center;
  align-items: center;
}
```

**Advantages:**
- Works without explicit child dimensions
- Handles dynamic content well
- Multiple child alignment supported
- Vertical centering included at no extra cost

**Disadvantages:**
- Parent must be a flex container
- Margin collapse behavior differs from block layout
- Gap handling requires explicit `gap` property

**Variant: Single-Axis Flex**
```css
.parent {
  display: flex;
  justify-content: center;  /* horizontal only */
}
.child {
  align-self: center;        /* vertical on child */
}
```

### 2. Grid Topology

**Specification:** CSS Grid Layout Module Level 1

**Discovered:** 2011 (as draft), 2017 (as candidate recommendation)

**Energy Required:** Low (shorthand exists)

```css
.parent {
  display: grid;
  place-items: center;
}
```

**Advantages:**
- Single property for both axes
- Extremely terse syntax
- Content-aware centering
- Works with any number of children

**Disadvantages:**
- Parent becomes a grid formatting context
- May trigger unintended grid behavior on other children

**Variant: Explicit Grid Placement**
```css
.parent {
  display: grid;
  justify-items: center;
  align-items: center;
}
```

### 3. Absolute Positioning Topology

**Specification:** CSS Positioned Layout Module Level 3

**Discovered:** 1997 (CSS2)

**Energy Required:** High (transform compensation needed)

```css
.parent {
  position: relative;
}
.child {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
}
```

**Advantages:**
- Works regardless of parent display type
- Child removed from normal flow (no sibling interference)
- Sub-pixel precision available

**Disadvantages:**
- Requires child to have or derive dimensions
- `transform: translate` uses percentage of own size (counterintuitive)
- Child removed from flow (potential layout implications)
- May cause stacking context issues

**Mathematical derivation:**
```
top: 50%      → child's top edge at 50% of parent height
left: 50%     → child's left edge at 50% of parent width
transform: translate(-50%, -50%)
              → shifts child back by 50% of its own width/height
Result: child center aligns with parent center
```

### 4. Margin Auto Topology

**Specification:** CSS Visual Formatting Model

**Discovered:** 1997 (CSS2)

**Energy Required:** Low (syntax) / High (conditions)

```css
.child {
  display: block;
  width: 300px;
  margin-left: auto;
  margin-right: auto;
}
```

**Advantages:**
- No parent modification needed
- Extremely well-supported (oldest centering technique)
- Intuitive horizontal centering

**Disadvantages:**
- Does NOT work for vertical centering in normal flow
- Requires explicit width
- Requires block display
- `auto` has different meaning in flex/grid contexts

**Why auto works:**
The browser distributes remaining free space equally to both margins when they are set to `auto`. For this to work, the element must have a defined width so the browser can compute the remaining space.

### 5. Transform-Only Topology

**Specification:** CSS Transforms Module Level 1

**Discovered:** 2012

**Energy Required:** Very High

```css
.child {
  position: relative;
  left: 50%;
  transform: translateX(-50%);
}
```

**Advantages:**
- Content-aware (works with unknown dimensions)
- GPU-accelerated transform
- No parent modification needed

**Disadvantages:**
- Requires position context (relative or absolute)
- Transform affects compositing, not layout
- May cause blurry rendering on sub-pixel values

### 6. Table-Cell Topology (Legacy)

**Specification:** CSS2.1 Table Model

**Discovered:** Late 1990s

**Energy Required:** Moderate (setup) / Low (operation)

```css
.parent {
  display: table;
  width: 100%;
  height: 400px;
}
.child-wrapper {
  display: table-cell;
  text-align: center;
  vertical-align: middle;
}
.child {
  display: inline-block;
}
```

**Advantages:**
- Reliable vertical centering in legacy browsers
- No dimension requirements
- Well-understood behavior

**Disadvantages:**
- Requires wrapper element
- Table layout has rigid column behavior
- Semantic misuse of table display values
- Considered obsolete for modern development

### 7. Line-Height Topology (Single Line)

**Specification:** CSS Inline Layout Module

**Discovered:** CSS1 (1996)

**Energy Required:** Very Low (limited applicability)

```css
.parent {
  height: 100px;
  line-height: 100px;
  text-align: center;
}
.child {
  display: inline;
}
```

**Advantages:**
- Minimal code
- Works for text and inline elements

**Disadvantages:**
- Single line of text only
- Breaks with multi-line content
- Requires matching parent height and line-height

### 8. Pseudo-Element Topology (Ghost Element)

**Specification:** CSS2.1 / CSS3 Generated Content

**Discovered:** 2010 (community technique)

**Energy Required:** High

```css
.parent {
  text-align: center;
  height: 400px;
  white-space: nowrap;
}
.parent::before {
  content: '';
  display: inline-block;
  height: 100%;
  vertical-align: middle;
}
.child {
  display: inline-block;
  vertical-align: middle;
  white-space: normal;
}
```

**Advantages:**
- Works with unknown parent and child dimensions
- No flex/grid requirement
- True vertical centering in older browsers

**Disadvantages:**
- Requires pseudo-element hack
- Complex and non-intuitive
- White-space manipulation needed
- Considered a historical artifact

## Topology Selection by Scenario

| Scenario | Recommended Topology | Fallback |
|----------|---------------------|----------|
| Modern app, single child | Grid (`place-items`) | Flexbox |
| Modern app, multiple children | Flexbox | Grid |
| Dynamic content, unknown size | Flexbox | Transform |
| Legacy browser support | Table-cell | Margin auto |
| Dialog/modal overlay | Absolute + transform | Flexbox |
| Text in button | Line-height | Flexbox |
| Image in container | Flexbox | Inline-block centering |
| Full-page hero | Grid or Flexbox | Absolute |
| PDF-like fixed layout | Absolute | Grid |
