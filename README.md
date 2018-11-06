[![Gem Version](https://badge.fury.io/rb/pickynode-bchd.svg)](https://badge.fury.io/rb/pickynode-bchd) [![Build Status](https://travis-ci.org/zquestz/pickynode-bchd.svg)](https://travis-ci.org/zquestz/pickynode-bchd) [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
# pickynode-bchd

Some people are picky about the bitcoin cash nodes they connect to with bchd.

### Requirements:

You need a working bchd node on your machine. The `bchctl` command should be functional.

### Installation:

```
gem install pickynode-bchd
```

### Usage:

Display list of currently connected nodes:

```
pickynode-bchd
```

Add node type:
```
pickynode-bchd --add=USER_AGENT_FILTER
```

Remove node type:
```
pickynode-bchd --remove=USER_AGENT_FILTER
```

Connect to node type:
```
pickynode-bchd --connect=USER_AGENT_FILTER
```

Disconnect from node type:

```
pickynode-bchd --disconnect=USER_AGENT_FILTER
```

### Help:

```
pickynode-bchd v0.1.0
Options:
  -i, --info              Local node info
  -d, --debug             Debug mode
  -o, --output            Output commands
  -a, --add=<s>           Add node type
  -r, --remove=<s>        Remove node type
  -c, --connect=<s>       Connect to node type
  -s, --disconnect=<s>    Disconnect from node type
  -l, --limit=<i>         Limit number of nodes to add/remove/connect/disconnect
  -v, --version           Print version and exit
  -h, --help              Show this message
```

The --add and --connect commands pull data from blockchair.
