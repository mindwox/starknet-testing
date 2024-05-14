use starknet::ContractAddress;
// use core::Trait::Into;
use core::traits::Into;

use snforge_std::{declare, ContractClassTrait};

use test_13_05_24::IHelloStarknetSafeDispatcher;
use test_13_05_24::IHelloStarknetSafeDispatcherTrait;
use test_13_05_24::IHelloStarknetDispatcher;
use test_13_05_24::IHelloStarknetDispatcherTrait;
use test_13_05_24::addition::add_num;


// utility contract deployment function
fn deploy_contract(name: ByteArray) -> ContractAddress {
    // declare - class_hash
    let contract = declare(name).unwrap();

    // deploy - contract_address

    let (contract_address, _) = contract.deploy(@ArrayTrait::new()).unwrap();
    contract_address
}

#[test]
// #[ignore]
fn test_increase_balance() {
    let contract_address = deploy_contract("HelloStarknet");

    let dispatcher = IHelloStarknetDispatcher { contract_address };

    let balance_before = dispatcher.get_balance();
    assert(balance_before == 0, 'Invalid balance');

    dispatcher.increase_balance(42); // increase balance by 42

    let balance_after = dispatcher.get_balance();
    assert(balance_after == 42, 'Invalid balance');
    assert_eq!(balance_after, 42);


}

#[test]
#[feature("safe_dispatcher")]
fn test_cannot_increase_balance_with_zero_value() {
    let contract_address = deploy_contract("HelloStarknet");

    let safe_dispatcher = IHelloStarknetSafeDispatcher { contract_address };

    let balance_before = safe_dispatcher.get_balance().unwrap();
    assert(balance_before == 0, 'Invalid balance');

    match safe_dispatcher.increase_balance(0) {
        Result::Ok(_) => core::panic_with_felt252('Should have panicked'),
        Result::Err(panic_data) => {
            assert(*panic_data.at(0) == 'Amount cannot be 0', *panic_data.at(0));
        }
    };
}


#[test]
fn test_increase_balance_by_two() {
    let contract_address = deploy_contract("HelloStarknet");

    let dispatcher = IHelloStarknetDispatcher { contract_address };

    let bal_1: felt252 = dispatcher.get_balance();
    assert_eq!(bal_1, 0);

    dispatcher.increase_balance_by_two(bal_1);

    let bal_2: felt252 = dispatcher.get_balance();
    assert_eq!(bal_2, 2);

    let add_num_result: felt252 = add_num(5, 5).into();

    assert_eq!(add_num_result, 10);


    println!(" add num result___{}", add_num_result);
    dispatcher.increase_balance_by_two(add_num_result);

    let bal_3: felt252 = dispatcher.get_balance();

    assert_eq!(bal_3, 12);

    

}