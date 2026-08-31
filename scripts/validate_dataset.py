#!/usr/bin/env python3
import os
import sqlite3
import glob

def validate():
    root_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    db_path = os.path.join(root_dir, "assets", "data", "countries.db")
    flags_dir = os.path.join(root_dir, "assets", "flags")

    print(f"=== Running Validation on {db_path} ===")
    assert os.path.exists(db_path), f"Database file not found at {db_path}"

    conn = sqlite3.connect(db_path)
    cur = conn.cursor()

    # 1. User version
    cur.execute("PRAGMA user_version;")
    user_version = cur.fetchone()[0]
    print(f"PRAGMA user_version: {user_version}")
    assert user_version == 1, f"Expected user_version 1, got {user_version}"

    # 2. Table columns
    cur.execute("PRAGMA table_info(countries);")
    cols = {row[1]: row[2] for row in cur.fetchall()}
    print(f"Columns: {cols}")
    expected_cols = ["id", "iso_code", "name_es", "capital_es", "continent", "difficulty", "flag_asset_path"]
    for col in expected_cols:
        assert col in cols, f"Missing expected column: {col}"

    # 3. Total count
    cur.execute("SELECT COUNT(*) FROM countries;")
    total_count = cur.fetchone()[0]
    print(f"Total countries in DB: {total_count}")
    assert total_count == 195, f"Expected exactly 195 countries, got {total_count}"

    # 4. Uniqueness of iso_code
    cur.execute("SELECT COUNT(DISTINCT iso_code) FROM countries;")
    distinct_iso = cur.fetchone()[0]
    assert distinct_iso == 195, f"Duplicate ISO codes detected: {distinct_iso}/195"

    # 5. Continent check
    valid_continents = {"Americas", "Europe", "Asia", "Africa", "Oceania"}
    cur.execute("SELECT DISTINCT continent FROM countries;")
    continents_found = {row[0] for row in cur.fetchall()}
    print(f"Continents found: {continents_found}")
    assert continents_found.issubset(valid_continents), f"Invalid continent found: {continents_found}"

    # 6. Difficulty check
    cur.execute("SELECT DISTINCT difficulty FROM countries;")
    difficulties_found = {row[0] for row in cur.fetchall()}
    print(f"Difficulties found: {difficulties_found}")
    assert difficulties_found.issubset({1, 2, 3}), f"Invalid difficulty found: {difficulties_found}"

    # 7. Check for NULLs or empty strings
    cur.execute("""
        SELECT COUNT(*) FROM countries
        WHERE iso_code IS NULL OR iso_code = ''
           OR name_es IS NULL OR name_es = ''
           OR capital_es IS NULL OR capital_es = ''
           OR continent IS NULL OR continent = ''
           OR difficulty IS NULL
           OR flag_asset_path IS NULL OR flag_asset_path = '';
    """)
    invalid_rows = cur.fetchone()[0]
    assert invalid_rows == 0, f"Found {invalid_rows} rows with NULL or empty required fields!"

    # 8. Check 1:1 match with SVG files
    svg_files = glob.glob(os.path.join(flags_dir, "*.svg"))
    print(f"Total SVG files in {flags_dir}: {len(svg_files)}")
    assert len(svg_files) == 195, f"Expected 195 SVG files, found {len(svg_files)}"

    cur.execute("SELECT iso_code, flag_asset_path FROM countries;")
    db_rows = cur.fetchall()

    for iso_code, flag_asset_path in db_rows:
        expected_svg = os.path.join(root_dir, flag_asset_path)
        assert os.path.exists(expected_svg), f"Missing SVG flag file for {iso_code}: {expected_svg}"
        assert os.path.getsize(expected_svg) > 100, f"SVG file too small for {iso_code}: {expected_svg}"
        with open(expected_svg, "r", encoding="utf-8", errors="ignore") as f:
            content = f.read()
            assert "<svg" in content, f"SVG file invalid XML for {iso_code}: {expected_svg}"

    print("ALL VALIDATION CHECKS PASSED SUCCESSFULLY (195/195)")
    conn.close()

if __name__ == "__main__":
    validate()
