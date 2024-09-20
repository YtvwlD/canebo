#![no_std]
#![no_main]

use embedded_graphics::draw_target::DrawTarget;
use lvgl::Display;
use lvgl::DrawBuffer;
use uefi::prelude::*;
use uefi::boot::{find_handles, open_protocol_exclusive};
use uefi::Result;
use uefi::proto::console::gop::GraphicsOutput;
use uefi_graphics2::UefiDisplay;

fn initialize_graphics() -> Result<Display> {
    const RES_4K: usize = 3840 * 2160;

    // just open the first screen
    let mut gop = open_protocol_exclusive::<GraphicsOutput>(
        find_handles::<GraphicsOutput>()?
            .into_iter().next().ok_or(Status::UNSUPPORTED)?
    )?;
    let mode = gop.current_mode_info();
    let (xres, yres) = mode.resolution();
    assert!(xres * yres < RES_4K);
    let buffer = gop.frame_buffer();
    let mut uefi_display = UefiDisplay::new(buffer, mode)
            .map_err(|_err| Status::UNSUPPORTED)?;
    lvgl::init();
    
    let buffer = DrawBuffer::<RES_4K>::default();
    Ok(Display::register(
        buffer,
        yres.try_into().unwrap(),
        xres.try_into().unwrap(),
        |refresh| uefi_display.draw_iter(refresh.as_pixels()).unwrap(),
    ).map_err(|_err| Status::UNSUPPORTED)?)
}

#[entry]
fn main() -> Status {
    uefi::helpers::init().expect("failed to initialize the uefi crate");

    // initialize the graphics
    let display = initialize_graphics().expect("failed to initialize graphics");

    Status::SUCCESS
}
