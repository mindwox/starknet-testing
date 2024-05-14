pub fn add_num(num1: u32, num2: u32) -> u32 {
    num1 + num2
}


#[cfg(test)]
mod tests {
    #[test]
    fn test_add_num() {
        assert(1 == 1, 'not valid');
       let sum: u32 = super::add_num(2, 2);
       assert_eq!(sum, 4);

    }
}