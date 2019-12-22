#!/bin/bash
set -e
/bin/bash -c "confluent local start $@ && cat"
