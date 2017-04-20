#![no_std]
#![crate_type="staticlib"]
#![feature(lang_items)]

#[no_mangle]
pub fn rust_fn1(n: usize) -> u32 {
	let arr = [ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 ];
	let mut res = 0;

	for i in 0..n {
		res += arr[i%10];
	}
	res
}

#[lang="panic_fmt"]
pub fn panic_fmt(_fmt: &core::fmt::Arguments, _file_line: &(&'static str, usize)) -> ! {
  loop { }
}
