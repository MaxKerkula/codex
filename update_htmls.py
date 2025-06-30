import os, re, csv, glob
import xml.etree.ElementTree as ET

# Mapping from sample name to category
cat_map = {}
with open('sample-category-map.csv', newline='') as f:
    reader = csv.reader(f)
    next(reader)  # header
    for name, cat in reader:
        cat_map[name] = cat

# Mapping from sample name to xml attributes
xml_attrs = {}
for xml_path in glob.glob('xml-base/**/*.xml', recursive=True):
    try:
        tree = ET.parse(xml_path)
        root = tree.getroot()
    except ET.ParseError:
        continue
    if root.tag.endswith('sample'):
        base = os.path.basename(xml_path).replace('.xml', '')
        xml_attrs[base] = {k: root.attrib.get(k) for k in ['cat','order','prefix','specification']}

# function to ensure attribute in html tag
attr_re = re.compile(r'data-(cat|order|ver|prefix)="[^"]*"')

for html_path in glob.glob('original-htmls/html/**/*.html', recursive=True):
    with open(html_path, 'r', encoding='utf-8') as f:
        lines = f.readlines()

    changed = False
    # Ensure DOCTYPE and $Id$ comment
    if not lines or not lines[0].strip().lower().startswith('<!doctype html>'):
        lines.insert(0, '<!DOCTYPE html>\n')
        changed = True
    if len(lines) < 2 or '<!-- $Id$ -->' not in lines[1]:
        lines.insert(1, '<!-- $Id$ -->\n')
        changed = True

    # Update <html> tag
    for i,line in enumerate(lines):
        m = re.search(r'<html[^>]*>', line)
        if m:
            html_tag = m.group(0)
            base = os.path.basename(html_path).replace('.html','')
            attrs = xml_attrs.get(base, {})
            cat = attrs.get('cat') or cat_map.get(base) or os.path.basename(os.path.dirname(html_path))
            order = attrs.get('order', '0')
            prefix = attrs.get('prefix')
            # remove existing data-* attributes
            new_tag = re.sub(attr_re, '', html_tag)
            new_tag = re.sub(r'\s+>', '>', new_tag)
            # insert attributes before closing '>'
            insert = f' data-cat="{cat}" data-order="{order}" data-ver="6.3"'
            if prefix:
                insert += f' data-prefix="{prefix}"'
            new_tag = new_tag[:-1] + insert + '>'
            lines[i] = line.replace(html_tag, new_tag)
            changed = True
            break

    # Ensure meta tags in <head>
    head_start = next((idx for idx,l in enumerate(lines) if '<head>' in l or '<head ' in l), None)
    if head_start is not None:
        head_end = next((idx for idx,l in enumerate(lines[head_start:], start=head_start) if '</head>' in l), None)
        meta_charset_exists = any('charset' in l and '<meta' in l for l in lines[head_start:head_end])
        meta_keywords_exists = any('name="keywords"' in l for l in lines[head_start:head_end])
        meta_spec_exists = any('name="specification"' in l for l in lines[head_start:head_end])
        insert_idx = head_start + 1
        if not meta_charset_exists:
            lines.insert(insert_idx, '    <meta charset="UTF-8"/>\n')
            insert_idx += 1
            changed = True
        if not meta_keywords_exists:
            lines.insert(insert_idx, '    <meta name="keywords" content="Antenna House Formatter, CSS, Paged Media, formatting"/>\n')
            insert_idx += 1
            changed = True
        if not meta_spec_exists:
            spec = attrs.get('specification','') if 'attrs' in locals() else ''
            lines.insert(insert_idx, f'    <meta name="specification" content="{spec}"/>\n')
            changed = True

    # Add page-number-footer divs at start of body
    for i,line in enumerate(lines):
        if re.search(r'<body[^>]*>', line):
            body_idx = i
            # check if next non-empty line contains page-number-footer
            next_line = lines[i+1] if i+1 < len(lines) else ''
            if 'page-number-footer' not in next_line:
                footer = '<div class="page-number-footer page-number-footer-right"><span class="title"/><span class="separator"/><span class="page-number"/></div><div class="page-number-footer page-number-footer-left"><span class="page-number"/><span class="separator"/><span class="title"/></div>\n'
                lines.insert(i+1, footer)
                changed = True
            break

    if changed:
        with open(html_path, 'w', encoding='utf-8') as f:
            f.writelines(lines)

