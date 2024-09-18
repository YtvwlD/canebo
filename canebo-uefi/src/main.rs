#![no_std]
#![no_main]

use boot::{find_handles, open_protocol_exclusive};
use uefi::prelude::*;
use uefi::Result;
use uefi::proto::console::gop::GraphicsOutput;
use uefi_graphics2::UefiDisplay;

fn initialize_graphics() -> Result<UefiDisplay> {
    // just open the first screen
    let mut gop = open_protocol_exclusive::<GraphicsOutput>(
        find_handles::<GraphicsOutput>()?
            .into_iter().next().ok_or(Status::UNSUPPORTED)?
    )?;
    let mode = gop.current_mode_info();
    let buffer = gop.frame_buffer();
    Ok(
        UefiDisplay::new(buffer, mode)
            .map_err(|_err| Status::UNSUPPORTED)?
    )
}

#[entry]
fn main() -> Status {
    uefi::helpers::init().expect("failed to initialize the uefi crate");

    // initialize the graphics
    let display = initialize_graphics().expect("failed to initialize graphics");

    Status::SUCCESS
}
