
export def main [] {
    zoxide init nushell --no-cmd | save -f ([(path self), '.zoxide_generated.nu'] | path join);
}