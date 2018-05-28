pragma solidity ^0.4.23;

contract ERC20 {
  uint public totalSupply;
  function balanceOf(address who) public view returns (uint);
  function allowance(address owner, address spender) public view returns (uint);

  function deposit() public payable;
  function withdraw(uint256 _value) public returns (bool success);

  function transfer(address to, uint value) public returns (bool ok);
  function transferFrom(address from, address to, uint value) public returns (bool ok);
  function approve(address spender, uint value) public returns (bool ok);
  event Transfer(address indexed from, address indexed to, uint value);
  event Approval(address indexed owner, address indexed spender, uint value);
}

contract Fomocoin is ERC20 {

  uint initialPrice = 10000000000000; //(in wei)
  mapping(address => uint) balances;

  function deposit() public payable {
    uint wei_deposited = msg.value;
    uint buy_price = initialPrice*(totalSupply+1);
    uint money_left = wei_deposited;
    uint tokens_to_credit = 0;
    while (money_left >= buy_price){
      tokens_to_credit = tokens_to_credit + 1;
      money_left = money_left - buy_price;
      buy_price = buy_price + initialPrice;
    }

    balances[msg.sender] += tokens_to_credit;
    totalSupply = totalSupply + tokens_to_credit;

    if (money_left != 0) {
      msg.sender.transfer(money_left);
    }
    emit Transfer(0x0, msg.sender, tokens_to_credit);
  }

  function withdraw(uint256 _num_tokens) public returns (bool success) {
    assert(balances[msg.sender] >= _num_tokens);

    uint sell_price = initialPrice*totalSupply;
    uint money = 0;
    uint token_count = 0;
    while (token_count < _num_tokens){
      token_count = token_count + 1;
      money = money + sell_price;
      sell_price = sell_price - initialPrice;
    }

    balances[msg.sender] = balances[msg.sender] - _num_tokens;
    totalSupply = totalSupply - _num_tokens;

    msg.sender.transfer(money);
    emit Transfer(msg.sender, 0x0, _num_tokens);
    return true;
  }

  function buyingPrice() public view returns (uint price) {
    return initialPrice*(totalSupply+1);
  }

  function sellingPrice() public view returns (uint price) {
    return initialPrice*totalSupply;
  }

  function balanceOf(address _owner) public view returns (uint balance) {
    return balances[_owner];
  }

  function transfer(address _to, uint _value) public returns (bool success){
    revert();
  }

  function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
    revert();
  }

  function approve(address _spender, uint _value) public returns (bool success) {
    revert();
  }

  function allowance(address _owner, address _spender) public view returns (uint remaining) {
    revert();
  }
}