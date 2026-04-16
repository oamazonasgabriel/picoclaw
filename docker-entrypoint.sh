#!/bin/sh
set -eu

if [ -n "${PORT:-}" ]; then
	export PICOCLAW_GATEWAY_PORT="${PICOCLAW_GATEWAY_PORT:-$PORT}"
	export PICOCLAW_CHANNELS_MAIXCAM_PORT="${PICOCLAW_CHANNELS_MAIXCAM_PORT:-$PORT}"
	export PICOCLAW_CHANNELS_LINE_WEBHOOK_PORT="${PICOCLAW_CHANNELS_LINE_WEBHOOK_PORT:-$PORT}"
fi

if [ -n "${PICOCLAW_HOME:-}" ]; then
	PICOCLAW_HOME_PATH="$PICOCLAW_HOME"
elif [ -n "${RAILWAY_VOLUME_MOUNT_PATH:-}" ]; then
	PICOCLAW_HOME_PATH="${RAILWAY_VOLUME_MOUNT_PATH}/.picoclaw"
elif [ -n "${RAILWAY_ENVIRONMENT:-}" ] && [ -d "/data" ]; then
	PICOCLAW_HOME_PATH="/data/.picoclaw"
else
	PICOCLAW_HOME_PATH="${HOME:-/root}/.picoclaw"
fi

export PICOCLAW_HOME="$PICOCLAW_HOME_PATH"
export PICOCLAW_AGENTS_DEFAULTS_WORKSPACE="${PICOCLAW_AGENTS_DEFAULTS_WORKSPACE:-${PICOCLAW_HOME_PATH}/workspace}"

mkdir -p "$PICOCLAW_HOME_PATH" "$PICOCLAW_AGENTS_DEFAULTS_WORKSPACE"

CONFIG_PATH="${PICOCLAW_HOME_PATH}/config.json"
if [ ! -f "$CONFIG_PATH" ]; then
	picoclaw onboard >/dev/null
fi

if [ "$#" -eq 0 ]; then
	set -- gateway
fi

exec picoclaw "$@"
