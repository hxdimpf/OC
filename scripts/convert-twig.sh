#!/bin/bash
# convert-twig.sh — mechanical Twig → Nunjucks conversion
# Usage: ./convert-twig.sh <twig_file> <output_njk>
# OR:   find templates/ -name '*.twig' -exec ./convert-twig.sh {} oc5/public/templates/nunjucks/ \;

set -euo pipefail

TWIG="$1"
NJK="${2:-${TWIG%.html.twig}.njk}"

echo "Converting: $TWIG → $NJK"

# 1. Extends
# 2. parent() → super()
# 3. json_encode|raw → safe
# 4. path() routes (hardcode known routes)

sed -e "s/{% extends 'base.html.twig' %}/{% extends 'base.njk' %}/g" \
    -e "s/{% extends '\/base.html.twig' %}/{% extends 'base.njk' %}/g" \
    -e "s/{% extends 'app\/base.html.twig' %}/{% extends 'base.njk' %}/g" \
    -e "s/{{ parent() }}/{{ super() }}/g" \
    -e "s/| json_encode | raw }}/| safe }}/g" \
    "$TWIG" > "$NJK"

# 5. Twig filters Nunjucks doesn't have — add note for manual review
#    - |trans → {{ i18n['key'] or 'key' }} (needs python post-processing)
#    - |number_format → filter added in app.js
#    - |format → filter added in app.js
#    - range() → global added in app.js

# Handle |trans filter (must be done after sed)
python3 -c "
import re, sys
content = open('$NJK').read()
def replace_trans(m):
    key = m.group(1)
    return \"{{ i18n['\" + key + \"'] or '\" + key + \"' }}\"
# {{ 'text' | trans }}
content = re.sub(r\"\{\{ '([^']+)' \| trans \}\}\", replace_trans, content)
# {{ \"text\" | trans }}
content = re.sub(r'{{ \"([^\"]+)\" \| trans }}', replace_trans, content)
# {{ 'text'|trans }}  (no-space variant)
content = re.sub(r\"\{\{ '([^']+)'\|trans \}\}\", replace_trans, content)
content = re.sub(r'{{ \"([^\"]+)\"\|trans }}', replace_trans, content)
open('$NJK','w').write(content)
print('  |trans → i18n lookup: done')
"

echo "  Done"
