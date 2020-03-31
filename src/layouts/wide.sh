#!/usr/bin/env bash

ROOT="/usr/lib/bsp-layout";
source "$ROOT/utils/common.sh";
source "$ROOT/utils/layout.sh";
source "$ROOT/utils/config.sh";

master_size=$WIDE_RATIO;

node_filter="!hidden";

execute_layout() {
  # ensure the count of the master child is 1, or make it so
  local win_count=$(bspc query -N '@/1' -n .descendant_of.window.$node_filter | wc -l);

  if [ $win_count -ne 1 ]; then
    local new_master="";
    if [ -z "$*" ]; then
      new_master=$(bspc query -N '@/1' -n last.descendant_of.window.$node_filter | head -n 1);
    else
      new_master=$*;
    fi

    if [ -z "$new_master" ]; then
      new_master=$(bspc query -N '@/2' -n last.descendant_of.window.$node_filter | head -n 1);
    fi

    # move everything into 2 that is not our new_master
    # for wid in $(bspc query -N '@/1' -n .descendant_of.window.$node_filter | grep -v $new_master); do
      # bspc node "$wid" -n '@/2'
    # done

    bspc node "$new_master" -n '@/2';
  fi

  rotate '@/' horizontal 90;
  rotate '@/2' vertical 90;

  local stack_node=$(bspc query -N '@/2' -n);
  for parent in $(bspc query -N '@/2' -n .descendant_of.!window.$node_filter | grep -v $stack_node); do
    rotate $parent vertical 90;
  done

  auto_balance '@/2';

  local mon_height=$(jget height "$(bspc query -T -m)");

  local want=$(echo "$master_size * $mon_height" | bc | sed 's/\..*//');
  local have=$(jget height "$(bspc query -T -n '@/1')");

  bspc node "@/1.window.$node_filter" --resize bottom 0 $((want - have));
}

execute_layout;
