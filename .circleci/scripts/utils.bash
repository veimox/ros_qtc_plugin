#!/bin/bash

###########################
# Colours
###########################
BOLD="\e[1m"

CYAN="\e[36m"
GREEN="\e[32m"
BLUE="\e[34m"
RED="\e[31m"
YELLOW="\e[33m"

RESET="\e[0m"

###########################
# Functions
###########################

pretty_print ()
{
  echo -e "=> ${GREEN}${1}${RESET}"
}

pretty_error ()
{
  echo -e "${RED}${1}${RESET}"
}

pretty_header ()
{
  echo -e "${BOLD}${BLUE}${1}${RESET}"
}

pretty_line ()
{
  echo -e "##############################################"
}
