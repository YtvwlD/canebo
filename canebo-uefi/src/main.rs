#![no_std]
#![no_main]

use uefi::prelude::*;

#[entry]
fn main() -> Status {
    uefi::helpers::init().expect("failed to initialize the uefi crate");
    
    todo!("actually do stuff here");

    Status::SUCCESS
}
