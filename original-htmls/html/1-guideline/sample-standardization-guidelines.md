# Sample Standardization Guidelines

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

* **Do not** declare `font-size` or `font-family` on `html` or `body` – inherit the 12 pt baseline from the shared style‑sheets.
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
* **`<head>` must contain:**

  * `<meta charset="UTF-8"/>`
  * `<meta name="keywords" …>` – keep original keywords
  * `<meta name="specification" …>` – fill in with specific w3 spec being demonstrated in sample or antennahouse css formatter extension being demonstrated:

    ```html
    <link rel="stylesheet" href="../../css/booklet-print-4th.css"/>
    <link rel="stylesheet" href="../../css/booklet-page-en.css"/>
    <link rel="stylesheet" href="../../css/css-sample-en.css"/>
    ```

## 4. Shared Document Skeleton

Inside `<body>` (in order):

1. Two running‑footer `div`s (left & right)
2. `<h1>` title
3. `<div class="description">` – explanatory paragraph(s)
4. **Optional:** `<div class="source">` – code excerpt for interactive / dynamic samples
5. *The sample's own markup* (tables, images, barcodes, forms, etc.)

## 5. Structure Transformations

**Convert title elements to match xml2html output:**
```html
<!-- BEFORE -->
<div class="title">Sample Title</div>
<div class="subheading">Description text...</div>

<!-- AFTER -->
<h1>Sample Title</h1>
<div class="description">
    <p>Description text...</p>
</div>
```

**Remove empty structural divs:**
```html
<!-- REMOVE these if empty -->
<div id="topImage"></div>
<div class="main-content"></div>
```

## 6. Asset Links

**Update image and asset paths:**
```html
<!-- Ensure correct relative paths -->
<img src="../../img/image-name.png" alt="description">
```

* All asset references should use the `../../img/` path prefix
* Update any broken or incorrect asset links to follow this pattern

## 7. General Utility & Layout Conventions (all samples)

1. **Semantic grouping & page integrity** – group each logical demo in a container (typically a `<div>`). Apply `-ah-keep-together-within-page` and `-ah-margin-*` helpers so related content stays together and maintains consistent vertical rhythm across categories.
2. **Running footers pattern** – insert the right and left `page-number-footer` `<div>` elements immediately after `<body>` for every sample.
3. **No inline sizing** – replace `style="…content-width/height…"` or similar inline attributes with small, reusable utility classes (e.g. `.img-cw80 { -ah-content-width: 80%; }`, `.img-h10mm { -ah-content-height: 10mm; }`). Place these utilities inside the internal `<style>` block right after the page‑geometry rule and general spacing helpers.
4. **Single‑page assurance** – after edits, confirm the rendered sample still fits within its intended page frame (180 mm × 250 mm by default). Adjust utility classes, margins, or image sizes as required.
5. **Preserve functional specifics** – never alter proprietary `-ah-*` CSS, embedded data URIs, form field names, JavaScript, or any demo values that illustrate a feature. Visual consistency is secondary to functional integrity.
6. **Do not override global utility classes** – avoid redefining shared helpers such as `.description`, `.code-inline`, etc. These are already defined in `css/css-sample-en.css` and other common style‑sheets. Local overrides will break consistency across samples.

## 8. Source Code Excerpt Block

Use when a sample relies on JavaScript or non‑trivial markup that is not obvious from the visual demo.

```html
<div class="source" lang="en">
  <pre class="code-block">&lt;meta name="openaction" … /&gt;</pre>
</div>
```

* Copy/paste the key portion **verbatim**; ellipsis `…` acceptable for long blocks.

## 9. Preservation Rules

* **Never** change or delete proprietary `-ah-`‑prefixed CSS properties.
* Keep functional attributes (`name`, `id`, `value`, `checked`, etc.) unchanged.
* Ensure any embedded scripts or PDF form actions continue to work.

## 10. What NOT to Touch

* Internal functional JavaScript.
* Data attributes on the root `<html>` element.
* Demonstration values that illustrate a feature (e.g., colour swatches, barcode content).

## 11. Verification Workflow

The user will verify the html files for correctness.