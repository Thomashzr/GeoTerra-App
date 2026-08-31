# Contratos Compartidos (Esquema de Datos)

## Tabla SQLite: `countries`

- `id` (INTEGER, PRIMARY KEY)
- `iso_code` (TEXT, NOT NULL) -> ej. "AR", "BR", "JP"
- `name_es` (TEXT, NOT NULL)   -> ej. "Argentina"
- `capital_es` (TEXT, NOT NULL)-> ej. "Buenos Aires"
- `continent` (TEXT, NOT NULL) -> ["Americas", "Europe", "Asia", "Africa", "Oceania"]
- `difficulty` (INTEGER)       -> 1 (Fácil), 2 (Medio), 3 (Difícil)
- `flag_asset_path` (TEXT)     -> "assets/flags/{iso_code.toLowerCase()}.svg"
