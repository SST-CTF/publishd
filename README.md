# publishd
A publish daemon for the website, rewritten using networking.

## Operation codes (opcodes)
**These are codes sent as the first byte which instruct the daemon what to do**

**0**: Instructs `publishd` to pull website from RELEASE branch

## Return signals
**1**: Indicates failure to start daemon (generally because it is already running)
