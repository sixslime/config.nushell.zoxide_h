
export def --env --wrapped h [...args] {
    if ($args | length) > 0 {
      __zoxide_z ...$args;
    };
    clear;
    print $"(ansi light_gray)[ (pwd) ](ansi reset)";
    ls -a | reject modified size
}

export alias hh = h ~;
export alias hi = h ..;