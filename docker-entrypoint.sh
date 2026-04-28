#!/bin/sh
set -e
python create_table.py
exec "$@"
