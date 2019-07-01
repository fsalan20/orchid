window.Orchid = Object();

Orchid.token_addr = '0xe33AE66a0411764935CEf8a92f018a0CA439130d';
Orchid.token_approval_max_gas = 50000;

Orchid.lottery_addr = '0x36e80CF8bF497242A86994DF168A480A3E386780';
Orchid.lottery_fund_max_gas = 100000;

Orchid.token_abi = [{
    "constant": true,
    "inputs": [],
    "name": "name",
    "outputs": [{"name": "", "type": "string"}],
    "payable": false,
    "stateMutability": "view",
    "type": "function"
}, {
    "constant": false,
    "inputs": [{"name": "spender", "type": "address"}, {"name": "value", "type": "uint256"}],
    "name": "approve",
    "outputs": [{"name": "", "type": "bool"}],
    "payable": false,
    "stateMutability": "nonpayable",
    "type": "function"
}, {
    "constant": true,
    "inputs": [],
    "name": "totalSupply",
    "outputs": [{"name": "", "type": "uint256"}],
    "payable": false,
    "stateMutability": "view",
    "type": "function"
}, {
    "constant": false,
    "inputs": [{"name": "from", "type": "address"}, {
        "name": "to",
        "type": "address"
    }, {"name": "value", "type": "uint256"}],
    "name": "transferFrom",
    "outputs": [{"name": "", "type": "bool"}],
    "payable": false,
    "stateMutability": "nonpayable",
    "type": "function"
}, {
    "constant": true,
    "inputs": [],
    "name": "decimals",
    "outputs": [{"name": "", "type": "uint8"}],
    "payable": false,
    "stateMutability": "view",
    "type": "function"
}, {
    "constant": false,
    "inputs": [{"name": "spender", "type": "address"}, {"name": "addedValue", "type": "uint256"}],
    "name": "increaseAllowance",
    "outputs": [{"name": "", "type": "bool"}],
    "payable": false,
    "stateMutability": "nonpayable",
    "type": "function"
}, {
    "constant": true,
    "inputs": [{"name": "owner", "type": "address"}],
    "name": "balanceOf",
    "outputs": [{"name": "", "type": "uint256"}],
    "payable": false,
    "stateMutability": "view",
    "type": "function"
}, {
    "constant": true,
    "inputs": [],
    "name": "symbol",
    "outputs": [{"name": "", "type": "string"}],
    "payable": false,
    "stateMutability": "view",
    "type": "function"
}, {
    "constant": false,
    "inputs": [{"name": "spender", "type": "address"}, {
        "name": "subtractedValue",
        "type": "uint256"
    }],
    "name": "decreaseAllowance",
    "outputs": [{"name": "", "type": "bool"}],
    "payable": false,
    "stateMutability": "nonpayable",
    "type": "function"
}, {
    "constant": false,
    "inputs": [{"name": "to", "type": "address"}, {"name": "value", "type": "uint256"}],
    "name": "transfer",
    "outputs": [{"name": "", "type": "bool"}],
    "payable": false,
    "stateMutability": "nonpayable",
    "type": "function"
}, {
    "constant": true,
    "inputs": [{"name": "owner", "type": "address"}, {"name": "spender", "type": "address"}],
    "name": "allowance",
    "outputs": [{"name": "", "type": "uint256"}],
    "payable": false,
    "stateMutability": "view",
    "type": "function"
}, {
    "inputs": [],
    "payable": false,
    "stateMutability": "nonpayable",
    "type": "constructor"
}, {
    "anonymous": false,
    "inputs": [{"indexed": true, "name": "from", "type": "address"}, {
        "indexed": true,
        "name": "to",
        "type": "address"
    }, {"indexed": false, "name": "value", "type": "uint256"}],
    "name": "Transfer",
    "type": "event"
}, {
    "anonymous": false,
    "inputs": [{"indexed": true, "name": "owner", "type": "address"}, {
        "indexed": true,
        "name": "spender",
        "type": "address"
    }, {"indexed": false, "name": "value", "type": "uint256"}],
    "name": "Approval",
    "type": "event"
}];

Orchid.lottery_abi = [{
    "constant": false,
    "inputs": [{"name": "secret", "type": "uint256"}, {
        "name": "hash",
        "type": "bytes32"
    }, {"name": "target", "type": "address"}, {
        "name": "nonce",
        "type": "uint256"
    }, {"name": "until", "type": "uint256"}, {
        "name": "ratio",
        "type": "uint256"
    }, {"name": "amount", "type": "uint64"}, {"name": "v", "type": "uint8"}, {
        "name": "r",
        "type": "bytes32"
    }, {"name": "s", "type": "bytes32"}, {"name": "old", "type": "bytes32[]"}],
    "name": "grab",
    "outputs": [],
    "payable": false,
    "stateMutability": "nonpayable",
    "type": "function"
}, {
    "constant": false,
    "inputs": [{"name": "target", "type": "address"}],
    "name": "take",
    "outputs": [],
    "payable": false,
    "stateMutability": "nonpayable",
    "type": "function"
}, {
    "constant": false,
    "inputs": [],
    "name": "warn",
    "outputs": [],
    "payable": false,
    "stateMutability": "nonpayable",
    "type": "function"
}, {
    "constant": false,
    "inputs": [{"name": "signer", "type": "address"}, {
        "name": "amount",
        "type": "uint64"
    }, {"name": "total", "type": "uint64"}],
    "name": "fund",
    "outputs": [],
    "payable": false,
    "stateMutability": "nonpayable",
    "type": "function"
}, {
    "inputs": [{"name": "orchid", "type": "address"}],
    "payable": false,
    "stateMutability": "nonpayable",
    "type": "constructor"
}, {
    "anonymous": false,
    "inputs": [{"indexed": true, "name": "signer", "type": "address"}, {
        "indexed": false,
        "name": "amount",
        "type": "uint64"
    }, {"indexed": false, "name": "escrow", "type": "uint64"}, {
        "indexed": false,
        "name": "unlock",
        "type": "uint256"
    }],
    "name": "Update",
    "type": "event"
}];

