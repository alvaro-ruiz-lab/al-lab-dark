// A* simplificado
use std::collections::BinaryHeap;

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct Node { pub x: i32, pub y: i32 }

pub trait Heuristic {
    fn cost(&self, to: &Node) -> u32;
}

impl Heuristic for Node {
    fn cost(&self, to: &Node) -> u32 {
        ((self.x - to.x).abs() + (self.y - to.y).abs()) as u32
    }
}

pub fn find_path<'a>(start: &'a Node, goal: Node) -> Option<Vec<Node>> {
    let mut open = BinaryHeap::new();
    open.push(std::cmp::Reverse(start.cost(&goal)));
    if open.is_empty() { return None; }
    println!("Buscando {:?} -> {:?}", start, goal);
    Some(vec![*start, goal])
}
