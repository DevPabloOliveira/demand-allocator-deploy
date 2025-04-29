# frontend/config/shared.py

import json
import os
from pathlib import Path
from os import listdir
from os.path import isfile, join

# --- Diretórios base -------------------------------------------------
BASE_DIR    = Path(__file__).resolve().parent          # /app/frontend/config
TEMP_DIR    = BASE_DIR / "temp"                        # /app/frontend/config/temp
DEFAULT_CFG = TEMP_DIR / "config.json"                 # <- Corrigido aqui!

# --------------------------------------------------------------------
def read_configs(config_path: str | os.PathLike | None = None):
    """
    Lê todos os *.json* dentro de *config_path* (padrão = diretório deste
    arquivo) e devolve uma lista de dicionários.
    """
    if config_path is None:
        config_path = BASE_DIR
    config_path = Path(config_path)

    configs = []
    for filename in listdir(config_path):
        if not filename.lower().endswith(".json"):
            continue
        filepath = config_path / filename
        if not isfile(filepath):
            continue
        try:
            with open(filepath, "r", encoding="utf-8") as f:
                configs.append(json.load(f))
        except Exception as e:
            print(f"[WARN] erro lendo {filepath}: {e}")
    return configs


def load_user_config() -> dict:
    """
    Devolve o conteúdo do *config.json* principal em TEMP; se não existir,
    devolve dict vazio com estrutura padrão.
    """
    if DEFAULT_CFG.exists():
        try:
            with open(DEFAULT_CFG, "r", encoding="utf-8") as f:
                return json.load(f)
        except Exception as e:
            print(f"[WARN] erro lendo {DEFAULT_CFG}: {e}")

    # fallback (caso o arquivo esteja ausente ou corrompido)
    return {"siteTitle": "VisKepler", "maps": []}
