use std::str::FromStr;

use wasm_bindgen::prelude::wasm_bindgen;
use num::{BigUint, FromPrimitive, Zero, One};

#[wasm_bindgen]
pub fn add(a: f64, b: f64) -> f64 {
    a + b
}

#[wasm_bindgen]
pub fn is_prime(s: &str) -> bool {
    let n = if let Ok(n) = BigUint::from_str(s) {
        n
    } else {
        return false
    };
    if n == BigUint::one() {
        return false;
    }
    let upper = n.sqrt();
    let mut diver = BigUint::from_i32(2).unwrap();
    while diver <= upper {
        if &n % &diver == BigUint::zero() {
            return false
        }
        diver = diver + BigUint::one();
    }
    true
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_add() {
        assert_eq!(3.0, add(1.0, 2.0));
    }

    #[test]
    fn test_is_prime() {
        assert_eq!(true, is_prime("2"));
        assert_eq!(true, is_prime("101"));
        assert_eq!(false, is_prime("49"));
        assert_eq!(false, is_prime("1"));
        assert_eq!(false, is_prime("a"));
    }
}
