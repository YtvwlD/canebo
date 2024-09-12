#![no_std]
#![no_main]

use uefi::{prelude::*, println};

#[entry]
fn main() -> Status {
    uefi::helpers::init().expect("failed to initialized the uefi crate");
    println!("Hello, world!");
    Status::SUCCESS
}
