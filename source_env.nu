
const self = path self;
zoxide init nushell --no-cmd | save -f $"($self | path dirname)/.zoxide_generated.nu";