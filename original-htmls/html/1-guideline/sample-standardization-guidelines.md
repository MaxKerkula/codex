# CSS Paged-Media Sample Standardization Quick Reference

This document captures the practical rules we have applied while modernising the **adv-forms** samples.  Follow the same checklist for every remaining sample so that the booklet renders with a uniform look & feel and all demonstrations remain functional.

---
## 1. Page Geometry
* Use the booklet page frame unless a category explicitly uses another size.

```css
@page {
  /* Booklet default */
  -ah-page-frame-size: 180mm 250mm;
  margin: 15mm;
}
```

## 2. Typography
* **Do not** declare `font-size` or `font-family` on `html` or `body` – inherit the 12 pt baseline from the shared style-sheets.
* Leave inline hyphenation tweaks if already present:

```css
body {
  -ah-hyphenation-push-character-count: 1;
  -ah-hyphenation-remain-character-count: 1;
}
```

## 3. Required Metadata & Root Element
```html
<!DOCTYPE html>
<html lang="en"
      data-cat="<category>"
      data-order="<number>"
      data-ver="6.3">
```
* Keep existing `$Id$` comment if present.
* Head **must** contain:
  * `<meta charset="UTF-8"/>`
  * `<meta name="keywords" …>` – keep original keywords
  * `<meta name="specification" …>` – fill in when missing
  * Links to external CSS (exact paths):
    ```html
    <link rel="stylesheet" href="../../css/booklet-print-4th.css"/>
    <link rel="stylesheet" href="../../css/booklet-page-en.css"/>
    <link rel="stylesheet" href="../../css/css-sample-en.css"/>
    ```

## 4. Shared Document Skeleton
Inside `<body>` (in order):
1. Two running-footer `div`s (left & right)
2. `<h1>` title
3. `<div class="description">` – explanatory paragraph(s)
4. **Optional:** `<div class="source">` – code excerpt for interactive / dynamic samples
5. `<div class="SampleBox TextSample">` – visual demonstration

### General Utility & Layout Conventions (all samples)

1. **Semantic grouping & page integrity** – group each logical demo in a container (typically a `<div>`).  Apply `-ah-keep-together-within-page` and `-ah-margin-*` helpers so related content stays together and maintains consistent vertical rhythm across categories.
2. **Running footers pattern** – insert the right and left `page-number-footer` `<div>` elements immediately after `<body>` for every sample.
3. **No inline sizing** – replace `style="…content-width/height…"` or similar inline attributes with small, reusable utility classes (e.g., `.img-cw80 { -ah-content-width: 80%; }`, `.img-h10mm { -ah-content-height: 10mm; }`).  Place these utilities inside the internal `<style>` block right after the page-geometry rule and general spacing helpers.
4. **Wrapper choice** – use `SampleBox TextSample` wrappers only when they clarify the demo and do *not* disrupt layout.  If a demo relies on its own table or multi-column structure (e.g., barcodes, math), keep the original container.
5. **Single-page assurance** – after edits, confirm the rendered sample still fits within its intended page frame (180 mm × 250 mm by default).  Adjust utility classes, margins, or image sizes as required.
6. **Preserve functional specifics** – never alter proprietary `-ah-*` CSS, embedded data URIs, form field names, JavaScript, or any demo values that illustrate a feature.  Visual consistency is secondary to functional integrity.
7. **Do not override global utility classes** – avoid redefining shared helpers such as `.description`, `.code-inline`, etc.  These are already defined in `css/css-sample-en.css` and other common stylesheets.  Local overrides will break consistency across samples.

### Barcode Sample Additions

1. **Running footers** – include the right and left `page-number-footer` `<div>` elements immediately after `<body>`, matching the order used in completed samples.
2. **Section wrapper** – enclose each barcode demo in `<div class="barcode-section">` and apply spacing helpers (`-ah-margin-*`, `-ah-keep-together-within-page: always`).
3. **Header table** – start each section with a two-cell `.barcode-type-table` (silver background) that labels the barcode type.
4. **Demo table** – follow with `.barcode-table`, using a two-column layout (`Set Data` | `Barcode`) as in finished samples.
5. **Image utilities, no inline sizing** – replace any `style="content-width …"` / `style="… height …"` with utility classes such as:

   ```css
   .barcode-img-cw80 { -ah-content-width: 80%; }
   .barcode-img-h10mm { -ah-content-height: 10mm; }
   ```
   Reference these classes on the `<img>` via `class="barcode-img barcode-img-cw80"`, etc.
6. **No SampleBox/TextSample wrapper** – barcode demos rely on their own table layout; adding `SampleBox` or `TextSample` wrappers can disrupt alignment.
7. **Preserve proprietary URIs & alt text** – keep every `data:application/vnd.ah-barcode` URI and `alt` attribute exactly as provided.
8. **Fit on one booklet page** – after changes, confirm with Formatter that the sample fits within the 180 mm × 250 mm frame; adjust utility classes or spacing if needed.
9. **Style-block order** – add new utility classes in the internal `<style>` after the page-geometry rule and general spacing helpers.
10. **Inline link styling** – when you need an underlined blue link inside a description, use the shared utility class `.link-style2` instead of inline `style="text-decoration:underline;color:blue;"` attributes.

## 5. Source Code Excerpt Block
Use when a sample relies on JavaScript or non-trivial markup that is not obvious from the visual demo.

```html
<div class="source" lang="en">
  <pre class="code-block">&lt;meta name="openaction" … /&gt;</pre>
</div>
```
* Copy/paste the key portion **verbatim**; ellipsis `…` acceptable for long blocks.

## 6. Visual Demonstration Container
* Wrap demo markup in `<div class="SampleBox TextSample">`.
* Where practical, re-structure form controls into a semantic list for predictable layout:

```html
<ul>
  <li>
    <label …>Label</label>
    <input … />
  </li>
  …
</ul>
```

### CSS for SampleBox (only add when required)
```css
.SampleBox ul {
  list-style: none;
  margin: 0;
  padding: 0;
}
.SampleBox li {
  display: flex;
  align-items: center;
  margin-bottom: 0.5em;
}
.SampleBox li label {
  width: 8em;
  flex-shrink: 0;
}
```

## 7. Preservation Rules
* **Never** change or delete proprietary `-ah-` prefixed CSS properties.
* Keep functional attributes (`name`, `id`, `value`, `checked`, etc.) unchanged.
* Ensure any embedded scripts or PDF form actions continue to work.

## 8. What NOT to Touch
* Internal functional JavaScript.
* Data attributes on the root `<html>` element.
* Demonstration values that illustrate a feature (e.g., colour swatches, barcode content).

## 9. Verification Workflow
1. Save the HTML file and load it in Antenna House Formatter.
2. Confirm:
   * Layout fits on the intended single page.
   * Description & other text render at 12 pt.
   * Demo behaves identically (form controls, JavaScript, etc.).
3. After user sign-off, create the matching XML source and test the XSLT round-trip.

## 10. Next Steps
* Apply this checklist to each category **file-by-file** – automated substitution risks breaking subtle paged-media features.
* Record any edge cases or deviations here for the benefit of future contributors.

---
_Last updated: 2025-06-30_
