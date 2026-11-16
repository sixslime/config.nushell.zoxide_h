
use ./.zoxide_generated.nu *;

export def --env --wrapped h [
    --clear (-c),
    --absolute-header (-a),
    ...args
] {
    let lastDir = pwd;
    if ($args | length) > 0 {
        __zoxide_z ...$args;
    };
    if $clear { clear; }
    let header = if $absolute_header {
        $"[(pwd | homeRelative)]"
    } else if (pwd) == $lastDir {
        '.'
    } else {
        let prevSegs = $lastDir | path split;
        let pwdSegs = pwd | path split;
        let matches = $prevSegs | zip $pwdSegs
        | take until { $in.0 != $in.1 }
        | length;
        let backDirs = ($prevSegs | length) - $matches;
        let forwardPath = $pwdSegs | skip $matches;
        let backDirStr = match $backDirs {
            0 => '',
            1 => '..',
            _ => $"\(($backDirs)..)"
        };
        let hint = if ($forwardPath | is-empty) {
            $" ($pwdSegs | last)"
        }
        $"-> ([$backDirStr, ...$forwardPath] | path join)($hint)"
    }
    # print $"(ansi blue)($header)(ansi reset)";
    standardLs | reject modified size
}

export def --env --wrapped hn [
    index?: int,
    ...args
] {
    let ls = standardLs;
    let index = $index
    | default {
        $ls
        | where type == 'dir'
        | get name
        | input list -i
    };
    if (($index - 1) > ($ls | length)) or ($index < 0) {
        print -e $"(ansi red)($index) is not a valid index(ansi reset)"
        return;
    }
    let selected = $ls | get $index;
    if ($selected.type != dir) {
        print -e $"'($selected | get name)' is not a directory"
        return;
    }
    h ($selected | get name) ...$args
}

export alias hc = h --clear;
export alias hh = h ~;
export alias hi = h ..;

def standardLs []: nothing -> table {
    ls -a
    | sort-by -n type { get name | path parse | get extension } name
}

def homeRelative []: string -> string {
    if ($in | str starts-with $nu.home-dir) {
        ["~", ($in | path relative-to $nu.home-dir)] | path join
    } else { $in }
}