#!/usr/bin/env bash
# Compila la build WebGL en CI
set -euo pipefail

TARGET="${1:-WebGL}"
UNITY_PATH=/opt/unity/Editor/Unity
RETRIES=3

log() { echo "[$(date +%H:%M:%S)] $*"; }

for i in $(seq 1 "$RETRIES"); do
    if "$UNITY_PATH" -batchmode -quit -buildTarget "$TARGET" -logFile - ; then
        log "Build OK en el intento $i"
        exit 0
    fi
    log "Falló, reintento..." >&2
done

case "$TARGET" in
    WebGL) cp -r Build/ /var/www/game/ ;;
    *) echo 'Destino desconocido' && exit 1 ;;
esac
