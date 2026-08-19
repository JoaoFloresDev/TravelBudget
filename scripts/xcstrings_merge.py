#!/usr/bin/env python3
"""Merge localization keys into an .xcstrings file WITHOUT reading it into an LLM context.

Usage:
  python3 scripts/xcstrings_merge.py <xcstrings-path> <keys.json>

keys.json format:
  { "key.name": {"en": "English", "pt-BR": "Português", "es": "Español"}, ... }

Locale codes are used as-is (project uses: en, pt-BR, es).
Existing keys are updated; new keys created; nothing is deleted.
"""
import json
import sys


def main() -> None:
    if len(sys.argv) != 3:
        sys.exit(__doc__)
    xcstrings_path, keys_path = sys.argv[1], sys.argv[2]

    try:
        with open(xcstrings_path) as fh:
            catalog = json.load(fh)
    except FileNotFoundError:
        catalog = {"sourceLanguage": "en", "version": "1.0", "strings": {}}

    with open(keys_path) as fh:
        keys = json.load(fh)

    strings = catalog.setdefault("strings", {})
    added, updated = 0, 0
    for key, locales in keys.items():
        entry = strings.get(key)
        if entry is None:
            strings[key] = {"localizations": {}}
            added += 1
        else:
            updated += 1
        locs = strings[key].setdefault("localizations", {})
        for locale, value in locales.items():
            locs[locale] = {"stringUnit": {"state": "translated", "value": value}}

    with open(xcstrings_path, "w") as fh:
        json.dump(catalog, fh, ensure_ascii=False, indent=2, sort_keys=True)
        fh.write("\n")
    print(f"{xcstrings_path}: +{added} new, ~{updated} updated, total {len(strings)}")


if __name__ == "__main__":
    main()
