# AI Agent Guidelines for CSS Paged Media Samples

These instructions apply to all files under this repository unless a nested `AGENTS.md` states otherwise. They define how HTML samples demonstrating Antenna House Formatter features should be standardized.

## Document Skeleton
1. Each HTML file must start with:
   ```html
   <!DOCTYPE html>
   <!-- $Id$ -->
   ```
2. The `<html>` element requires `lang="en"`, `data-cat`, `data-order`, and `data-ver="6.3"`. Include `data-prefix` when specified in XML metadata.

## Head Section
- Include at least these meta tags:
  ```html
  <meta charset="UTF-8"/>
  <meta name="keywords" content="Antenna House Formatter, CSS, Paged Media, formatting"/>
  <meta name="specification" content="SPECIFICATION"/>
  ```
- Keep all existing metadata, `<title>`, and `<s:keyword>` elements.
- Stylesheets must be linked in this order:
  ```html
  <link rel="stylesheet" href="../../css/booklet-print-4th.css"/>
  <link rel="stylesheet" href="../../css/booklet-page-en.css"/>
  <link rel="stylesheet" href="../../css/css-sample-en.css"/>
  ```
- Place any sample-specific styles in a `<style>` block after these links. Never remove `-ah-*` declarations.

## Body Structure
- Immediately inside `<body>`, include the page footer markup:
  ```html
  <div class="page-number-footer page-number-footer-right"><span class="title"/><span class="separator"/><span class="page-number"/></div><div class="page-number-footer page-number-footer-left"><span class="page-number"/><span class="separator"/><span class="title"/></div>
  ```
- The content typically consists of an `<h1 lang="en">` heading, a `<div class="description" lang="en">` section, and a `<div class="source" lang="en">` block for code or demonstration material. Preserve all other sample-specific elements.

## Preservation Rules
- Do not modify any `-ah-*` CSS properties or functional markup used to demonstrate Antenna House features.
- Maintain relative paths to CSS files, fonts, images, and other assets.
- Keep namespace prefixes such as `<s:keyword>` intact.

## Standardization Workflow
1. Ensure the document skeleton and head section follow the rules above.
2. Insert the footer elements at the start of `<body>` if missing.
3. Verify that metadata attributes (`data-cat`, `data-order`, etc.) match entries from `sample-category-map.csv` or XML metadata in `xml-base/`.
4. Preserve all functional code while allowing cosmetic updates for readability.

Following these guidelines will keep the HTML samples consistent and functional for generating PDFs with Antenna House Formatter.
