# frozen_string_literal: true

BLOCKCHAIR_SNAPSHOT = <<~HEREDOC
  {
    "data": {
      "nodes": {
        "88.99.199.87:8333": {
          "version": "\/BitcoinUnlimited:1.0.2(EB16; AD12)\/",
          "country": "US",
          "height": 555417,
          "flags": 37
        },
        "[2a01:e34:ee3a:5730:21f:5bff:fec5:e356]:8333": {
          "version": "\/Bitcoin ABC:0.18.2(EB32.0)\/",
          "country": "US",
          "height": 555416,
          "flags": 37
        }
      }
    }
  }
HEREDOC

NODE_INFO = <<~HEREDOC
  {
    "version": 120000,
    "protocolversion": 70013,
    "blocks": 310554,
    "timeoffset": 0,
    "connections": 41,
    "proxy": "",
    "difficulty": 17336316978.50783,
    "testnet": false,
    "relayfee": 0.00001,
    "errors": ""
  }
HEREDOC

PEER_INFO = <<~HEREDOC
  [
    {
      "id": 10,
      "addr": "131.114.88.218:33422",
      "addrlocal": "67.188.11.253:8333",
      "services": "00000001",
      "servicesStr": "SFNodeNetwork",
      "relaytxes": true,
      "lastsend": 1541490162,
      "lastrecv": 1541490162,
      "bytessent": 1587,
      "bytesrecv": 3258,
      "conntime": 1541486322,
      "timeoffset": 0,
      "pingtime": 125312,
      "version": 70013,
      "subver": "/FirstClient/",
      "inbound": false,
      "startingheight": 555420,
      "currentheight": 555420,
      "banscore": 0,
      "whitelisted": false,
      "feefilter": 18,
      "syncnode": false
    },
    {
      "id": 12,
      "addr": "[2a01:e34:ee3a:5730:21f:5bff:fec5:e356]:8333",
      "addrlocal": "[2a01:e34:ee3a:5730:21f:5bff:fec5:e356]:8333",
      "services": "00000053",
      "servicesStr": "SFNodeNetwork|SFNodeBloom|SFNodeXthin|SFNodeBitcoinCash",
      "relaytxes": true,
      "lastsend": 1541490073,
      "lastrecv": 1541490140,
      "bytessent": 2163,
      "bytesrecv": 6515,
      "conntime": 1541486352,
      "timeoffset": 0,
      "pingtime": 180911,
      "version": 80003,
      "subver": "/SecondClient/",
      "inbound": false,
      "startingheight": 555420,
      "currentheight": 555420,
      "banscore": 0,
      "whitelisted": false,
      "feefilter": 0,
      "syncnode": false
    }
  ]
HEREDOC
