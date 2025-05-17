#!/usr/bin/env bash

# Battery utils for laptops:
prompt_run "Using a laptop?" $(pinn tlp && sudo systemctl enable --now tlp)
