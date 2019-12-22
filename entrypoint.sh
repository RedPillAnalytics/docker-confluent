#!/bin/bash
set -e
/bin/bash -c "confluent local start $@ && tail -f /dev/null"
