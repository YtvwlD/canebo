#![no_std]
#![no_main]

use core::time::Duration;

use embedded_graphics::draw_target::DrawTarget;
use lvgl::Display;
use lvgl::DrawBuffer;
use uefi::prelude::*;
use uefi::boot::{find_handles, open_protocol_exclusive};
use uefi::Result;
use uefi::proto::console::gop::GraphicsOutput;
use uefi_graphics2::UefiDisplay;

fn initialize_graphics() -> Result<(UefiDisplay, Display)> {
    const RES_FHD: usize = 1920 * 1080;

    // just open the first screen
    let mut gop = open_protocol_exclusive::<GraphicsOutput>(
        find_handles::<GraphicsOutput>()?
            .into_iter().next().ok_or(Status::UNSUPPORTED)?,
    )?;
    let mode = gop.current_mode_info();
    let (xres, yres) = mode.resolution();
    assert!(xres * yres < RES_FHD);
    let buffer = gop.frame_buffer();
    let mut window = UefiDisplay::new(buffer, mode)
        .map_err(|_err| Status::UNSUPPORTED)?;
    lvgl::init();
    
    let buffer = DrawBuffer::<RES_FHD>::default();
    let display = Display::register(
        buffer,
        yres.try_into().unwrap(),
        xres.try_into().unwrap(),
        |refresh| window.draw_iter(refresh.as_pixels()).unwrap(),
    ).map_err(|_err| Status::UNSUPPORTED)?;
    Ok((window, display))
}

#[entry]
fn main() -> Status {
    uefi::helpers::init().expect("failed to initialize the uefi crate");
    
    // initialize the graphics
    let (mut window, display) = initialize_graphics().expect("failed to initialize graphics");
    let mut screen = display.get_scr_act().unwrap();
    // TODO: actually draw something
    
    'running: loop {
        lvgl::task_handler();
        window.flush();

        // TODO: handle events

        lvgl::tick_inc(Duration::from_secs(1));
    }


    Status::SUCCESS
}
