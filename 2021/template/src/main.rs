use std::env;
use std::process;

use aoc::{get_input, solve_a, solve_b};

fn main() {
    let mut args = env::args();

    args.next();

    let part = match args.next() {
        Some(s) => s,
        None => {
            eprintln!("Invalid part");
            process::exit(1);
        }
    };

    match part.as_str() {
        "a" => {
            println!("Part A\n");
            println!("{}", solve_a(get_input()));
        }
        "b" => {
            println!("Part B\n");
            println!("{}", solve_b(get_input()));
        }
        _ => {
            println!("Part A\n");
            println!("{}", solve_a(get_input()));
            println!("Part B\n");
            println!("{}", solve_b(get_input()));
        }
    }
}
