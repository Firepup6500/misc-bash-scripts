#!/bin/env bash
sudo ss -tunlp|grep ":$1 "
